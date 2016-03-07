//
//  AppDelegate.h
//  ConnectionView
//
//  Created by 朱鹏的Mac on 16/3/7.
//  Copyright © 2016年 朱鹏的Mac. All rights reserved.
//

#import "IvanViewLayout.h"

@interface IvanViewLayout (/*Private Methods*/)

@property (nonatomic, strong) NSMutableDictionary *lastYValueForColumn;
@property (strong, nonatomic) NSMutableDictionary *layoutInfo;
@end

@implementation IvanViewLayout


//当collectionView修改布局的时候会掉用次方法
//一般在这个方法里面,设置准备工作, 如 itemSize  滚动方向  内边距 如果不设置,则默认是sb中设置的数值
-(void)prepareLayout {
  
    /*
     *  1  2   3
     *  4  5   6    这么排列最后一行的话，很差劲啊！！！！
     *  7  8   9
     */
    
    //几栏（几列）
  self.numberOfColumns = 3;
  self.interItemSpacing =   10.0;
  
 
  CGFloat fullWidth = self.collectionView.frame.size.width;
  CGFloat availableSpaceExcludingPadding = fullWidth - (self.interItemSpacing * (self.numberOfColumns + 1));
    
  CGFloat itemWidth = availableSpaceExcludingPadding / self.numberOfColumns;
    
    
  self.lastYValueForColumn = [NSMutableDictionary dictionary];
  self.layoutInfo = [NSMutableDictionary dictionary];

  NSIndexPath *indexPath;
  NSInteger numSections = [self.collectionView numberOfSections];
    //几组
  for(NSInteger section = 0; section < numSections; section++) {
    
      //每组几个item
    NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
      
    for(NSInteger item = 0; item < numItems; item++){
        
      indexPath = [NSIndexPath indexPathForItem:item inSection:section];
      
      UICollectionViewLayoutAttributes *itemAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
      

      CGFloat temp = [self.lastYValueForColumn[@0] doubleValue];
      int min = 0;
      for (int a = 1; a < self.numberOfColumns; a++) {
            if (temp > [self.lastYValueForColumn[@(a)] doubleValue]) {
                temp = [self.lastYValueForColumn[@(a)] doubleValue];
                min = a;
            }
       }
      CGFloat y = temp;
      CGFloat x = self.interItemSpacing + (self.interItemSpacing + itemWidth) * min;
      CGFloat height =   [((id<IvanMasonryViewLayoutDelegate>)self.collectionView.delegate)
                             collectionView:self.collectionView
                             layout:self
                             heightForItemAtIndexPath:indexPath];
        
      itemAttributes.frame = CGRectMake(x, y, itemWidth, height);
      y =  y +  height + self.interItemSpacing;
      self.lastYValueForColumn[@(min)] = @(y);
    
      //保存itemAttributes数组，供layoutAttributesForElementsInRect使用
      self.layoutInfo[indexPath] = itemAttributes;
    }
  }
}


//计算给定矩形区域中的物件
//返回一个数组  数组里面盛放的是  UICollectionViewLayoutAttributes 对象  布局属性
//UICollectionViewLayoutAttributes  里面的frame 正好对应item的frame
//是根据 itemSize 自动算出来的 如果想改变每个的位置,提前计算出来,并且创建 布局属性保存
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
  
  [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                       UICollectionViewLayoutAttributes *attributes,
                                                       BOOL *stop) {
    
      //CGRectIntersectsRect允许我们确定两个矩形是否相交
    if (CGRectIntersectsRect(rect, attributes.frame)) {
        
      [allAttributes addObject:attributes];
    }
  }];
  return allAttributes;
}


// 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
//- (BOOL)shouldInvalidateLayoutForBoundsChange{

  //  return YES;
//}
/*
// 返回对应于indexPath的位置的cell的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

}
//返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

}
// 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
-(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{

}
*/

//计算集合视图的ontentSize
-(CGSize)collectionViewContentSize{
  
  NSUInteger currentColumn = 0;
  CGFloat maxHeight = 0;
  do {
    CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
    if(height > maxHeight)
      maxHeight = height;
    currentColumn ++;
  } while (currentColumn < self.numberOfColumns);
  
  return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

@end
