//
//  SCTCarouselLayout.m
//  iOS PTL
//
//  Created by Mugunth on 6/12/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "IvanCoverFlowLayout.h"

@implementation IvanCoverFlowLayout

#define ZOOM_FACTOR 0.35


/*
首先，-(void)prepareLayout将被调用，

默认下该方法什么没做，但是在自己的子类实现中
，一般在该方法中设定一些必要的layout的结构和初始需要的参数等。
之后，-(CGSize) collectionViewContentSize将被调用，

以确定collection应该占据的尺寸。注意这里的尺寸不是指可视部分的尺寸，而应该是所有内容所占的尺寸。
collectionView的本质是一个scrollView，因此需要这个尺寸来配置滚动行为。
 

// 返回对应于indexPath的位置的cell的布局属性
-(UICollectionViewLayoutAttributes _)layoutAttributesForItemAtIndexPath:(NSIndexPath _)indexPath

//返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
-(UICollectionViewLayoutAttributes _)layoutAttributesForSupplementaryViewOfKind:(NSString _)kind atIndexPath:(NSIndexPath *)indexPath

// 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
-(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString_)decorationViewKind atIndexPath:(NSIndexPath _)indexPath
 
 
 // 边框
 @property (nonatomic) CGRect frame
 // 中心点
 @property (nonatomic) CGPoint center
 // 大小
 @property (nonatomic) CGSize size
 // 形状
 @property (nonatomic) CATransform3D transform3D
 // 透明度
 @property (nonatomic) CGFloat alpha
 // 层次关系
 @property (nonatomic) NSInteger zIndex
 // 是否隐藏
 @property (nonatomic, getter=isHidden) BOOL hidden

*/


//系统方法
-(void)prepareLayout {
  
  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  CGSize size = self.collectionView.frame.size;
  self.itemSize = CGSizeMake(size.width/3.0f, size.height*0.3);
  self.sectionInset = UIEdgeInsetsMake(size.height * 0.15, size.height * 0.1, size.height * 0.15, size.height * 0.1);
}


// 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
  return YES;
}



// 返回rect中的所有的元素的布局属性
/*
 返回的是包含UICollectionViewLayoutAttributes的NSArray
 UICollectionViewLayoutAttributes可以是cell，追加视图或装饰
 视图的信息，通过不同的UICollectionViewLayoutAttributes初始
 化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 */
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
  NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    
  CGRect visibleRect;
  visibleRect.origin = self.collectionView.contentOffset;
  visibleRect.size = self.collectionView.bounds.size;
  float collectionViewHalfFrame = self.collectionView.frame.size.width/2.0f;
  
    
    //只会创建比屏幕上能够显示个数多一个
  for (UICollectionViewLayoutAttributes* attributes in array) {
      
    if (CGRectIntersectsRect(attributes.frame, rect)) {
        
      CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
      CGFloat normalizedDistance = distance / collectionViewHalfFrame;
        
        //比较绝对值  在屏幕范围内的就显示
       if (ABS(distance) < collectionViewHalfFrame) {
        
           //围绕y轴旋转  靠近中线角度变小  离开中线角度变大
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500;  //逆时针旋转
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (normalizedDistance) * M_PI_4, 0.0f, 1.0f, 0.0f);
          
           //靠近中线变大  离开中线缩小
            CGFloat zoom = 1 +  ZOOM_FACTOR * (1 - ABS(normalizedDistance));
            CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);
          
          
            attributes.transform3D = CATransform3DConcat(zoomTransform, rotationAndPerspectiveTransform);
           
            // 层次关系
           attributes.zIndex = ABS(normalizedDistance) * 10.0f;
          
             //越近越明显
            CGFloat alpha = (1 - ABS(normalizedDistance)) + 0.1;
            if(alpha > 1.0f)
                alpha = 1.0f;
            attributes.alpha = alpha;
          
       } else {
        
           attributes.alpha = 0.0f;
       }
        
    }
  }
  return array;
}

@end