//
//  AppDelegate.h
//  ConnectionView
//
//  Created by 朱鹏的Mac on 16/3/7.
//  Copyright © 2016年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IvanViewLayout;

@protocol IvanMasonryViewLayoutDelegate <NSObject>

@required
- (CGFloat) collectionView:(UICollectionView*) collectionView
                   layout:(IvanViewLayout*) layout
 heightForItemAtIndexPath:(NSIndexPath*) indexPath;

@end



@interface IvanViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;

@property (weak, nonatomic) IBOutlet id<IvanMasonryViewLayoutDelegate> delegate;

@end
