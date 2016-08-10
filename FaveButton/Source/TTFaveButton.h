//
//  FaveButton.h
//  FaveButton
//
//  Created by yitailong on 16/8/8.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTFaveButtonDelegate <NSObject>

@optional
- (void)faveButton:(UIButton *)button didSelected:(BOOL)selected;

@end

@interface TTFaveButton : UIButton

@property (nonatomic, strong) IBInspectable UIColor *normalColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;
@property (nonatomic, strong) IBInspectable UIColor *dotFirstColor;
@property (nonatomic, strong) IBInspectable UIColor *dotSecondColor;
@property (nonatomic, strong) IBInspectable UIColor *circleFromColor;
@property (nonatomic, strong) IBInspectable UIColor *circleToColor;

@property (nonatomic, weak) id delegate;

@end
