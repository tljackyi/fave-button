//
//  FaveButton.m
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "TTFaveButton.h"
#import "TTFaveIcon.h"
#import "TTRing.h"
#import "TTSpark.h"

#define dtDuration 1.0
#define dtExpandDuration 0.1298 
#define dtCollapseDuration 0.108
#define dtFaveIconShowDelay (dtExpandDuration+dtCollapseDuration/2.0)

@interface TTFaveButton ()

@property (nonatomic, strong) UIImage *faveIconImage;
@property (nonatomic, strong) UIImage *selectedFaveIconImage;
@property (nonatomic, strong) TTFaveIcon *faveIcon;

@end

@implementation TTFaveButton

- (instancetype)initWithFrame:(CGRect)frame faveIconImage:(UIImage *)faveIconImage selectedFaveIconImage:(UIImage *)selectedFaveIconImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setImage:faveIconImage forState:UIControlStateNormal];
        [self setImage:selectedFaveIconImage forState:UIControlStateSelected];
        
        self.normalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.selectedColor = [UIColor colorWithRed:226/255.0 green:38/255.0 blue:77/255.0 alpha:1];
        self.dotFirstColor = [UIColor colorWithRed:152/255.0 green:219/255.0 blue:236/255.0 alpha:1];
        self.dotSecondColor = [UIColor colorWithRed:247/255.0 green:188/255.0 blue:48/255.0 alpha:1];
        self.circleFromColor = [UIColor colorWithRed:221/255.0 green:70/255.0 blue:136/255.0 alpha:1];
        self.circleToColor = [UIColor colorWithRed:205/255.0 green:143/255.0 blue:246/255.0 alpha:1];
        
        [self applyInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.normalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.selectedColor = [UIColor colorWithRed:226/255.0 green:38/255.0 blue:77/255.0 alpha:1];
        self.dotFirstColor = [UIColor colorWithRed:152/255.0 green:219/255.0 blue:236/255.0 alpha:1];
        self.dotSecondColor = [UIColor colorWithRed:247/255.0 green:188/255.0 blue:48/255.0 alpha:1];
        self.circleFromColor = [UIColor colorWithRed:221/255.0 green:70/255.0 blue:136/255.0 alpha:1];
        self.circleToColor = [UIColor colorWithRed:205/255.0 green:143/255.0 blue:246/255.0 alpha:1];

        [self applyInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.normalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.selectedColor = [UIColor colorWithRed:226/255.0 green:38/255.0 blue:77/255.0 alpha:1];
        self.dotFirstColor = [UIColor colorWithRed:152/255.0 green:219/255.0 blue:236/255.0 alpha:1];
        self.dotSecondColor = [UIColor colorWithRed:247/255.0 green:188/255.0 blue:48/255.0 alpha:1];
        self.circleFromColor = [UIColor colorWithRed:221/255.0 green:70/255.0 blue:136/255.0 alpha:1];
        self.circleToColor = [UIColor colorWithRed:205/255.0 green:143/255.0 blue:246/255.0 alpha:1];

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyInit];
}

- (void)applyInit
{
    if (!_faveIconImage) {
        _faveIconImage = [self imageForState:UIControlStateNormal];
    }
    
    if (!_selectedFaveIconImage) {
        _selectedFaveIconImage = [self imageForState:UIControlStateSelected];
    }
    
    [self setImage:[UIImage new] forState:UIControlStateNormal];
    [self setImage:[UIImage new] forState:UIControlStateSelected];
    [self setTitle:nil forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateSelected];
    
    self.faveIcon = [self createFaveIcon:_faveIconImage selectedFaveIconImage:_selectedFaveIconImage];
    [self addActions];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *color =  selected ? self.selectedColor : self.normalColor;
    [self.faveIcon selectWithoutAnimation:selected fillColor:color];
}


- (TTFaveIcon *)createFaveIcon:(UIImage *)faveIconImage
{
    return [TTFaveIcon createFaveIcon:self icon:faveIconImage color:self.normalColor];
}

- (TTFaveIcon *)createFaveIcon:(UIImage *)faveIconImage selectedFaveIconImage:(UIImage *)selectedFaveIconImage;
{
    return [TTFaveIcon createFaveIcon:self icon:faveIconImage selectedIcon:selectedFaveIconImage color:self.normalColor];
}

- (void)addActions
{
    [self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)createSparks:(CGFloat)radius
{
    NSMutableArray *sparks = [@[] mutableCopy];
    CGFloat step = 360.0/7;
    CGFloat base = self.bounds.size.width;
    DotRadius dotRadius = {base*0.0633, base*0.04};
    CGFloat offset = 10.0;
    
    
    for (NSInteger index=0; index<=7; index++) {
        CGFloat theta  = step * index + offset;
        
        NSArray *colors = [self dotColorsAtIndex:index];
        
        TTSpark *spark = [TTSpark createSpark:self radius:radius firstColor:colors.firstObject secondColor:colors.lastObject angle:theta dotRadius:dotRadius];
        [sparks addObject:spark];
    }
    
    return sparks;
}

- (NSArray *)dotColorsAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(faveButtonDotColors:)]) {
        NSArray *colors = [self.delegate faveButtonDotColors:self];
        return colors[index];
    }
    
    return @[self.dotFirstColor, self.dotSecondColor];
}

- (void)toggle:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(faveButtonShouldAnimation)]) {
        BOOL shouldAnimation = [self.delegate faveButtonShouldAnimation];
        if (!shouldAnimation) {
            return;
        }
    }
    
    button.selected = !button.selected;
//    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [self animateSelect:button.selected duration:dtDuration];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dtDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(faveButton:didSelected:)]) {
            [self.delegate faveButton:self didSelected:button.selected];
        }
        
//        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    });
}

- (void)animateSelect:(BOOL)isSelected duration:(NSTimeInterval)duration
{
    UIColor *color = isSelected ? self.selectedColor : self.normalColor;
    [self.faveIcon animateSelect:isSelected fillColor:color duration:duration delay:0];
    
    if (isSelected) {
        
        CGFloat radius  = self.bounds.size.height*1.3/2; // ring radius
        CGFloat igniteFromRadius = radius*0.8;
        CGFloat igniteToRadius   = radius*1.1;
        
        TTRing *ring = [TTRing createRingFavaButton:self radius:0.01 lineWidth:3 fillColor:self.circleFromColor];
        NSArray *sparks = [self createSparks:igniteFromRadius];
        
        [ring animateToRadius:radius toColor:self.circleToColor duration:dtExpandDuration delay:0];
        [ring animateColapse:radius duration:dtCollapseDuration delay:dtExpandDuration];
        
        for (TTSpark *spark in sparks) {
            [spark animateIgniteShow:igniteToRadius duration:0.4 delay:dtCollapseDuration/3.0];
            [spark animateIgniteHide:0.7 delay:0.2];
        }
    }
}

@end
