//
//  TTFaveIcon.h
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEasing.h"

@interface TTFaveIcon : UIView

+ (TTFaveIcon *)createFaveIcon:(UIView *)onView icon:(UIImage *)icon color:(UIColor *)color;
+ (TTFaveIcon *)createFaveIcon:(UIView *)onView icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon color:(UIColor *)color;

- (void)selectWithoutAnimation:(BOOL)isSelected fillColor:(UIColor *)fillColor;
- (void)animateSelect:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(NSTimeInterval )duration delay:(NSTimeInterval )delay;

@end
