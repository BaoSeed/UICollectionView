//
//  AppDelegate.h
//  ConnectionView
//
//  Created by 朱鹏的Mac on 16/3/7.
//  Copyright © 2016年 朱鹏的Mac. All rights reserved.
//

#import "IvanPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation IvanPhotoCell

-(void) awakeFromNib {
  
  self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
  
    
    
  [super awakeFromNib];
    
}
@end
