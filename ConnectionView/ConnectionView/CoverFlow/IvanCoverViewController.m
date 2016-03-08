//
//  SCTViewController.m
//  CoverFlowDemo
//
//  Created by Mugunth on 7/12/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "IvanCoverViewController.h"

#import "IvanCoverPhotoCell.h"
#import "IvanCoverFlowLayout.h"

@interface IvanCoverViewController ()


@property (strong, nonatomic) NSArray *photosList;
@property (strong, nonatomic) NSCache *photosCache;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@end

@implementation IvanCoverViewController



-(NSString*) photosDirectory {
  
  return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photosList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photosDirectory] error:nil];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return self.photosList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"IvanCoverPhotoCell";
  
  IvanCoverPhotoCell *cell = (IvanCoverPhotoCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  
  NSString *photoName = self.photosList[indexPath.row];
  NSString *photoFilePath = [[self photosDirectory] stringByAppendingPathComponent:photoName];
  cell.nameLabel.text =[photoName stringByDeletingPathExtension];
  
  __block UIImage* thumbImage = [self.photosCache objectForKey:photoName];
  cell.photoView.image = thumbImage;
    
    
  IvanCoverFlowLayout *layout = (IvanCoverFlowLayout *) collectionView.collectionViewLayout;
  
    
  if(!thumbImage) {
      
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      
      UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
      float scale = [UIScreen mainScreen].scale;
      UIGraphicsBeginImageContextWithOptions(layout.itemSize, YES, scale);
      [image drawInRect:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
      thumbImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
        
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.photosCache setObject:thumbImage forKey:photoName];
        cell.photoView.image = thumbImage;
          
      });
        
    });
  }
  
  return cell;
}
@end
