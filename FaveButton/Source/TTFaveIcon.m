//
//  TTFaveIcon.m
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "TTFaveIcon.h"
#import "Masonry.h"



@interface TTFaveIcon ()

@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) CAShapeLayer *iconLayer;
@property (nonatomic, strong) CALayer *iconMask;
@property (nonatomic, assign) CGRect contentRegion;

@property (nonatomic, strong) NSArray *tweenValues;

@end

@implementation TTFaveIcon

- (instancetype)initRegion:(CGRect)region icon:(UIImage *)icon color:(UIColor *)color
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.contentRegion = region;
        self.iconImage = icon;
        self.iconColor = color;
        [self applyInit];
    }
    return self;
}

- (void)applyInit
{
    CGSize maskSize = CGSizeMake(self.contentRegion.size.width*0.7, self.contentRegion.size.height*0.7);
    CGPoint maskOrigin = CGPointMake(self.contentRegion.origin.x-maskSize.width/2, self.contentRegion.origin.y-maskSize.height/2);
    
    CGRect maskRegion = (CGRect){
        .origin = maskOrigin,
        .size = maskSize
    };
    
    CGPoint shapeOrigin = CGPointMake(-self.contentRegion.size.width*0.5, -self.contentRegion.size.height*0.5);
    
    self.iconMask = [[CALayer alloc] init];
    self.iconMask.contents = (__bridge id _Nullable)(self.iconImage.CGImage);
    self.iconMask.contentsScale = [UIScreen mainScreen].scale;
    self.iconMask.bounds = maskRegion;
    
    self.iconLayer = [[CAShapeLayer alloc] init];
    self.iconLayer.fillColor = self.iconColor.CGColor;
    self.iconLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(shapeOrigin.x, shapeOrigin.y, self.contentRegion.size.width, self.contentRegion.size.height)].CGPath;
    self.iconLayer.mask = self.iconMask;
    
    [self.layer addSublayer:self.iconLayer];
}

- (void)animateSelect:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(NSTimeInterval )duration delay:(NSTimeInterval )delay
{
    if (!self.tweenValues) {
        self.tweenValues = [self generateTweenValues:0 to:1 duration:duration];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.iconLayer.fillColor = fillColor.CGColor;
    [CATransaction commit];
    
    NSTimeInterval selectedDelay = isSelected ? delay : 0;

    
    if (isSelected ) {
        self.alpha = 0;
        [UIView animateWithDuration:0 delay:selectedDelay options: UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1;
        } completion:nil];
    }
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = self.tweenValues;
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = CACurrentMediaTime()+selectedDelay;
    [self.iconMask addAnimation:scaleAnimation forKey:nil];
}


+ (TTFaveIcon *)createFaveIcon:(UIView *)onView icon:(UIImage *)icon color:(UIColor *)color{
    
    TTFaveIcon *favaIcon = [[TTFaveIcon alloc] initRegion:onView.bounds icon:icon color:color];
    favaIcon.backgroundColor = [UIColor clearColor];
    [onView addSubview:favaIcon];
    [favaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(onView);
        make.width.height.equalTo(@(0));
    }];
    
    
    return favaIcon;
}

- (NSArray *)generateTweenValues:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration
{
    NSMutableArray *values = [@[] mutableCopy];
    CGFloat fps = 60.0;
    CGFloat tpf = duration/fps;
    CGFloat c = to-from;
    CGFloat d = duration;
    CGFloat t = 0.0;
    
    while (t < d) {
        CGFloat scale = TTTimingFunctionElasticOut(t, from, c, d, c+0.001, 0.39988);
        [values addObject:@(scale)];
        t += tpf;
    }
    return values;
}

@end
