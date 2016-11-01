//
//  FaveButton.h
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TTFaveButton;

@protocol TTFaveButtonDelegate <NSObject>

@optional
- (BOOL)faveButtonShouldAnimation;
- (void)faveButton:(TTFaveButton *)button didSelected:(BOOL)selected;
- (NSArray<NSArray *> *)faveButtonDotColors:(TTFaveButton *)button;

@end

@interface TTFaveButton : UIButton

@property (nonatomic, strong) IBInspectable UIColor *normalColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;
@property (nonatomic, strong) IBInspectable UIColor *dotFirstColor;
@property (nonatomic, strong) IBInspectable UIColor *dotSecondColor;
@property (nonatomic, strong) IBInspectable UIColor *circleFromColor;
@property (nonatomic, strong) IBInspectable UIColor *circleToColor;

@property (nonatomic, weak) id delegate;

- (instancetype)initWithFrame:(CGRect)frame faveIconImage:(UIImage *)faveIconImage selectedFaveIconImage:(UIImage *)selectedFaveIconImage;

@end
