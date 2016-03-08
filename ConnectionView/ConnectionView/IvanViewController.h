//
//  AppDelegate.h
//  ConnectionView
//
//  Created by 朱鹏的Mac on 16/3/7.
//  Copyright © 2016年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IvanViewLayout.h"

@interface IvanViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, IvanViewLayoutDelegate, UICollectionViewDelegateFlowLayout>

@end                                                        
