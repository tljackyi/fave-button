//
//  TTRing.h
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFaveButton.h"

@interface TTRing : UIView

- (instancetype)initRadius:(CGFloat)radius linwWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor;
- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;
- (void)animateColapse:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

+ (TTRing *)createRingFavaButton:(TTFaveButton *)faveButton radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillCorlor;
@end
