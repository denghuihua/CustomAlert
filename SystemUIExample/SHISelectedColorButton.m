//
//  SNSBgChangeButton.m
//  SNS
//
//  Created by SPC_IOS_01 on 2018/1/16.
//  Copyright © 2018年 sohu. All rights reserved.
//
#import "UIColor+Hex.h"
#import "SHISelectedColorButton.h"

@implementation SHISelectedColorButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    SHISelectedColorButton *btn = [super buttonWithType:buttonType];
    btn.adjustsImageWhenHighlighted = NO;
    return btn;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    self.backgroundColor = self.selectedBgColor;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    self.backgroundColor = self.normalBgColor;
    [super touchesCancelled:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    self.backgroundColor = self.normalBgColor;
    [super touchesEnded:touches withEvent:event];
}
@end
