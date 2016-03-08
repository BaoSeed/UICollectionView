//
//  AppDelegate.h
//  ConnectionView
//
//  Created by 朱鹏的Mac on 16/3/7.
//  Copyright © 2016年 朱鹏的Mac. All rights reserved.
//

#import "IvanViewController.h"
#import "IvanPhotoCell.h"
@interface IvanViewController (){
  
    NSMutableArray *numbers;
}

@end

@implementation IvanViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    numbers = [NSMutableArray array];
    for(int i=0;i < 100;i++){
        [numbers addObject:[NSNumber numberWithInt:i]];
    }
    
    
    
    /*  改变当前UICollectionView的 Layout的时候，动画过渡
    // We need to explicitly tell the collection view layout that we want the change animated.
    if (self.collectionView.collectionViewLayout == self.circleLayout)
    {
        [self.flowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    }
    else
    {
        [self.circleLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
    }
     */
    
    
    /*push到UICollectionViewController 可以如下初始化  过渡效果
    SecondaryViewController *viewController = [[SecondaryViewController alloc] initWithCollectionViewLayout:[[AFSecondaryLayout alloc] init]];
    viewController.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    */
    
    
    
    /*手动创建 aaaa
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(100, 100);
     
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //代理设置
    collect.delegate=self;
    collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.view addSubview:collect];
     */
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"IvanCell";
    
  IvanPhotoCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                              forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    if(indexPath.item % 2 == 0){
    
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IvanCoverViewController" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IvanCoverViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
    
    }
   
}



/*
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

    //取出源item数据
    id objc = [numbers objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [numbers removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [numbers insertObject:objc atIndex:destinationIndexPath.item];
}
 */


#pragma mark UICollectionViewDelegateFlowLayout
// this will be called if our layout is UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat randomHeight = 100 + (arc4random() % 140);
  return CGSizeMake(100, randomHeight); // 100 to 240 pixels tall
}



#pragma mark IvanViewLayoutDelegate
// this will be called if our layout is IvanMasonryViewLayout
- (CGFloat) collectionView:(UICollectionView*) collectionView
                    layout:(IvanViewLayout*) layout
  heightForItemAtIndexPath:(NSIndexPath*) indexPath {
  
  // we will use a random height from 100 - 400
  
  CGFloat randomHeight = 100 + (arc4random() % 140);
  return randomHeight;
}

@end
