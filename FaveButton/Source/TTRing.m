//
//  TTRing.m
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "TTRing.h"
#import "Masonry.h"
#import "UIView+TTAutoLayout.h"

@interface TTRing ()

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) CAShapeLayer *ringLayer;

@end

@implementation TTRing

- (instancetype)initRadius:(CGFloat)radius linwWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.fillColor = fillColor;
        self.radius = radius;
        self.lineWidth = lineWidth;
        
        [self applyInit];
    }
    return self;
}

- (void)applyInit
{
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectZero];
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.equalTo(@(0));
    }];
    
    CAShapeLayer *circle = [self createRingLayerRadius:self.radius lineWidth:self.lineWidth fillColor:[UIColor clearColor] strokeColor:self.fillColor];
    [centerView.layer addSublayer:circle];
    
    self.ringLayer = circle;
    
}

- (CAShapeLayer *)createRingLayerRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor
{
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius - lineWidth/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CAShapeLayer *ring = [[CAShapeLayer alloc] init];
    ring.path = circle.CGPath;
    ring.fillColor = fillColor.CGColor;
    ring.lineWidth = 0;
    ring.strokeColor = strokeColor.CGColor;
    
    return ring;
}

- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [self layoutIfNeeded];
    
    NSLayoutConstraint *heightConstraint = [self TTConstraintForAttribute:NSLayoutAttributeWidth];
    NSLayoutConstraint *widthConstraint = [self TTConstraintForAttribute:NSLayoutAttributeHeight];
    heightConstraint.constant = radius * 2;
    widthConstraint.constant = radius * 2;
    
    CGFloat fittedRadius = radius - self.lineWidth/2;
    CABasicAnimation *fillColorAnimation = [self animationFillColor:self.fillColor toColor:toColor duration:duration delay:delay];
    CABasicAnimation *lineWidthAnimation = [self animationLineWidth:self.lineWidth duration:duration delay:delay];
    CABasicAnimation *lineColorAnimation = [self animationStrokeColor:toColor duration:duration delay:delay];
    CABasicAnimation *circlePathAnimation = [self animationCirclePath:fittedRadius duration:duration delay:delay];
    
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear  animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    [_ringLayer addAnimation:fillColorAnimation forKey:nil];
    [_ringLayer addAnimation:lineWidthAnimation forKey:nil];
    [_ringLayer addAnimation:lineColorAnimation forKey:nil];
    [_ringLayer addAnimation:circlePathAnimation forKey:nil];
}

- (void)animateColapse:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    CABasicAnimation *lineWidthAnimation = [self animationLineWidth:0 duration:duration delay:delay];
    CABasicAnimation *circlePathAnimation = [self animationCirclePath:radius duration:duration delay:delay];
    
    circlePathAnimation.delegate = self;
    [circlePathAnimation setValue:@"collapseAnimation" forKey:@"collapseAnimation"];
    
    [_ringLayer addAnimation:lineWidthAnimation forKey:nil];
    [_ringLayer addAnimation:circlePathAnimation forKey:nil];

}


- (CABasicAnimation *)animationFillColor:(UIColor *)fromColor toColor:(UIColor *)toColor duration:(NSTimeInterval)duraiton delay:(NSTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id _Nullable)(fromColor.CGColor);
    animation.toValue = (__bridge id _Nullable)toColor.CGColor;
    animation.duration = duraiton;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationStrokeColor:(UIColor *)strokeColor duration:(NSTimeInterval)duraiton delay:(NSTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    animation.fromValue = (__bridge id _Nullable)(strokeColor.CGColor);
    animation.duration = duraiton;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationLineWidth:(CGFloat)lineWidth duration:(NSTimeInterval)duraiton delay:(NSTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.toValue = @(lineWidth);
    animation.duration = duraiton;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationCirclePath:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id _Nullable)(path.CGPath);
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"collapseAnimation"] isEqualToString:@"collapseAnimation"]) {
        [self removeFromSuperview];
    }
}

+ (TTRing *)createRingFavaButton:(TTFaveButton *)faveButton radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillCorlor
{
    TTRing *ring = [[TTRing alloc] initRadius:radius linwWidth:lineWidth fillColor:fillCorlor];
    ring.backgroundColor = [UIColor clearColor];
    [faveButton.superview insertSubview:ring belowSubview:faveButton];
    
    
    [ring mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(faveButton);
        make.width.height.equalTo(@(radius*2));
    }];
    
    return ring;
}

@end
