//
//  SHIAlertView.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//
#import "SHIAlertView.h"

#import "UIColor+Hex.h"
#import "SHISelectedColorButton.h"
#import "NSString+TextHeight.h"
#import <Masonry.h>

#define Alert_text_Left_right_margin 20
#define Alert_Text_Top_Bottom_Margin 20
#define Alert_Title_FontSize 16
#define Alert_width  270
#define Alert_CustomView_BottomMargin 10

#define destructive_button_tag 10
#define cancel_button_tag 11
#define default_button_tag 12
#define vertical_seprator_line_tag 13

#define actionSheet_button_start_tag 30
#define actionSheet_button_height 48
#define actionSheet_cancel_button_height 51
#define actionSheet_top_bottom_margin 17

#define fontHeigh(x) [@"我" boundingRectWithSize:CGSizeMake(2000, 2000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:x} context:nil].size.height

@interface SHIAlertView()<CAAnimationDelegate>
{
    UIView *_alertHorizontalLine;
}
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *customeView;
@property(nonatomic,strong)UIButton *bgBtn;
@end

@implementation SHIAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
preferredStyle:(SHIAlertControllerStyle)preferredStyle{
    
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    if (self) {
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        _actions = [[NSMutableArray alloc] initWithCapacity:20];
        if (_preferredStyle == SHIAlertControllerStyleAlert) {
            [self createAlertUI];
        }else
        {
            [self createActionSheetUI];
        }
    }
    return self;
}

+ (instancetype _Nonnull )alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(SHIAlertControllerStyle)preferredStyle{
    
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (void)layoutSubviews{
//    [super layoutSubviews];
    if (self.preferredStyle == SHIAlertControllerStyleActionSheet) {
        [self layoutActionSheet];
    }else
    {
        [self layoutAlertUI];
    }
}

- (void)addAction:(SHIAlertAction *)action{
    [self.actions addObject:action];
    if (self.preferredStyle == SHIAlertControllerStyleActionSheet) {
        [self addActionSheetButton:action];
    }else
    {
        switch (action.style ) {
            case SHIAlertActionStyleCancel:
            {
                [self addAlertCancelButton:action];
            }
                break;
            case SHIAlertActionStyleDefault:
            {
                [self addAlertDefaultButton:action];
            }
                break;
            case SHIAlertActionStyleDestructive:
            {
                [self addAlertDestructiveButton:action]; 
            }
                break;
            default:
                break;
        }   
    }
}

#pragma mark - ActionSheetUI

- (void)layoutActionSheet{
    
    UIView *destructiveBtn = [_containerView viewWithTag:destructive_button_tag];
    UIView *cancelBtn = [_containerView viewWithTag:cancel_button_tag];
    CGFloat bottom_margin_from_container = 70;
    
    if (cancelBtn) {
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_containerView);
            make.bottom.equalTo(_containerView.mas_bottom);
            make.height.mas_equalTo(@actionSheet_cancel_button_height);
        }];    
        bottom_margin_from_container = 70;
    }
    
    if (destructiveBtn && cancelBtn) {
        [destructiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_containerView);
            make.bottom.equalTo(_containerView.mas_bottom).offset(-bottom_margin_from_container);
            make.height.mas_equalTo(@actionSheet_button_height);
        }];
        bottom_margin_from_container = 70 + actionSheet_button_height;
    }
  
    for (int i = 0; i< [_actions count]; i++) {
        SHIAlertAction *action = [_actions objectAtIndex:i];
        if (action.style != SHIAlertActionStyleDestructive && action.style != SHIAlertActionStyleCancel) {
            UIView *btn = [_containerView viewWithTag:actionSheet_button_start_tag + i];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.bottom.equalTo(_containerView.mas_bottom).offset(-bottom_margin_from_container);
                make.height.mas_equalTo(@actionSheet_button_height);
            }];
            bottom_margin_from_container = bottom_margin_from_container + actionSheet_button_height;
        }
    }
}

- (void)createActionSheetUI{
    // containerView  cancel
    self .backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
    [self addSubview:self.containerView];
    
    _alertHorizontalLine = nil;
    
    if (_title || _message) {
        
        [self addSubview:self.bgBtn];
        self.bgBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        //title Message
        NSString *text = _title?_title:_message;
        UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
        CGSize titleSize = [_title sizeWithFont:titleFont constrainSize:CGSizeMake(_containerView.frame.size.width-2*Alert_text_Left_right_margin, 1000) mode:NSLineBreakByWordWrapping lineSpace:3.5 rowHeight:1.0];
        NSString *oneStr = @"我";
        CGSize oneStrSize = [oneStr sizeWithFont:titleFont constrainSize:CGSizeMake(_containerView.frame.size.width-2*Alert_text_Left_right_margin, 1000) mode:NSLineBreakByWordWrapping lineSpace:3.5 rowHeight:1.0];
        
        BOOL isOneLine = YES;
        NSLog(@"%f",fontHeigh(titleFont));
        if (titleSize.height>oneStrSize.height) {
            isOneLine = NO;
        }
        float height = isOneLine?30:ceilf(titleSize.height);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3.5;
        paragraphStyle.alignment =isOneLine?NSTextAlignmentCenter:NSTextAlignmentLeft;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        self.titleLabel.attributedText = attributedString;
        [_containerView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.mas_equalTo(actionSheet_top_bottom_margin);
            make.height.mas_equalTo(actionSheet_button_height);
        }];
        
        _alertHorizontalLine = [[UIView alloc]init];
        _alertHorizontalLine.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        [_containerView addSubview:_alertHorizontalLine];
        [_alertHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_containerView);
            make.height.equalTo(@1);
            make.bottom.equalTo(_containerView.mas_bottom).offset(-actionSheet_cancel_button_height);
            make.left.equalTo(_containerView);
        }];
        self.containerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 300);
        
    }
}

- (void)addActionSheetButton:(SHIAlertAction *)action{
    NSInteger actionIndex = [self.actions indexOfObject:action];
    
    UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:Alert_Title_FontSize];
    SHISelectedColorButton *btn = [SHISelectedColorButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = titleFont;
    if (action.style == SHIAlertActionStyleDefault) {
        btn.tag = actionSheet_button_start_tag + actionIndex; 
        [btn setTitleColor:[UIColor colorWithHex:0x4a4a4a] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x4a4a4a] forState:UIControlStateHighlighted];
    }else if(action.style == SHIAlertActionStyleDestructive) 
    {
       btn.tag = destructive_button_tag;
        [btn setTitleColor:[UIColor colorWithHex:0xEE2F10] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0xEE2F10] forState:UIControlStateHighlighted];
    }else
    {
        btn.tag = cancel_button_tag;
        [btn setTitleColor:[UIColor colorWithHex:0x9B9B9B] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x9B9B9B] forState:UIControlStateHighlighted];
    }
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btn];
}

#pragma mark - AlertUI

- (void)layoutAlertUI{
    
    if (self.actions.count == 1) {
        UIButton *defaultBtn = [_containerView viewWithTag:default_button_tag];
        [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView);
            make.width.equalTo(@(Alert_width));
            make.height.equalTo(@44);
            make.top.equalTo(_alertHorizontalLine.mas_bottom);
        }];
    }else
    {
        //2个按钮
        UIButton *destructiveBtn = [_containerView viewWithTag:destructive_button_tag];
        UIButton *cancelBtn = [_containerView viewWithTag:cancel_button_tag];
        UIButton *defaultBtn = [_containerView viewWithTag:default_button_tag];
        if (destructiveBtn && cancelBtn) {
            [destructiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_containerView);
                make.width.equalTo(@(Alert_width/2));
                make.height.equalTo(@44);
                make.top.equalTo(_alertHorizontalLine.mas_bottom);
            }]; 
            
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(destructiveBtn.mas_right);
                make.width.equalTo(@(Alert_width/2));
                make.height.equalTo(@44);
                make.top.equalTo(_alertHorizontalLine.mas_bottom);
            }];
        }
        
        if (cancelBtn && defaultBtn) {
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_containerView);
                make.width.equalTo(@(Alert_width/2));
                make.height.equalTo(@44);
                make.top.equalTo(_alertHorizontalLine.mas_bottom);
            }]; 
            
            [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cancelBtn.mas_right);
                make.width.equalTo(@(Alert_width/2));
                make.height.equalTo(@44);
                make.top.equalTo(_alertHorizontalLine.mas_bottom);
            }];
        }
        UIView *sepLine = [_containerView viewWithTag:vertical_seprator_line_tag];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertHorizontalLine.mas_bottom);
            make.bottom.equalTo(_containerView.mas_bottom);
            make.centerX.equalTo(_containerView.mas_centerX);
            make.width.equalTo(@(0.5));
        }];
    }
}

- (void)addAlertCancelButton:(SHIAlertAction *)action{
    
    UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
    SHISelectedColorButton *cancelbtn = [SHISelectedColorButton buttonWithType:UIButtonTypeCustom];
    cancelbtn.titleLabel.font = titleFont;
    cancelbtn.tag = cancel_button_tag;
    [cancelbtn setTitle:action.title forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor colorWithHex:0x4a4a4a] forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor colorWithHex:0x4a4a4a] forState:UIControlStateHighlighted];
    [cancelbtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:cancelbtn];
}

- (void)addAlertDestructiveButton:(SHIAlertAction *)action{
    
    UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
    SHISelectedColorButton *destructiveBtn = [SHISelectedColorButton buttonWithType:UIButtonTypeCustom];
    destructiveBtn.titleLabel.font = titleFont;
    destructiveBtn.tag = destructive_button_tag;
    [destructiveBtn setTitle:action.title forState:UIControlStateNormal];
    [destructiveBtn setTitleColor:[UIColor colorWithHex:0xE94832] forState:UIControlStateNormal];
    [destructiveBtn setTitleColor:[UIColor colorWithHex:0xE94832] forState:UIControlStateHighlighted];
    
    [destructiveBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:destructiveBtn];
}

- (void)addAlertDefaultButton:(SHIAlertAction *)action{
    
    if (!action.title.length) {
        return;
    }
    UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
    SHISelectedColorButton *destructiveBtn = [SHISelectedColorButton buttonWithType:UIButtonTypeCustom];
    destructiveBtn.titleLabel.font = titleFont;
    destructiveBtn.tag = default_button_tag;
    [destructiveBtn setTitle:action.title forState:UIControlStateNormal];
    [destructiveBtn setTitleColor:[UIColor colorWithHex:0x5eCf75] forState:UIControlStateNormal];
    [destructiveBtn setTitleColor:[UIColor colorWithHex:0x5ECF75] forState:UIControlStateHighlighted];
    [destructiveBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:destructiveBtn];
}

- (void)createAlertUI
{    
   self .backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
    [self addSubview:self.containerView];

    _alertHorizontalLine = nil;
   
    if (_title || _message) {
        
        //title Message
        NSString *text = _title?_title:_message;
        UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
        CGSize titleSize = [_title sizeWithFont:titleFont constrainSize:CGSizeMake(_containerView.frame.size.width-2*Alert_text_Left_right_margin, 1000) mode:NSLineBreakByWordWrapping lineSpace:3.5 rowHeight:1.0];
        BOOL isOneLine = YES;
        NSLog(@"%f",fontHeigh(titleFont));
        if (titleSize.height>(ceilf(fontHeigh(titleFont)))) {
            isOneLine = NO;
        }
        float height = isOneLine?30:ceilf(titleSize.height);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3.5;
        paragraphStyle.alignment =isOneLine?NSTextAlignmentCenter:NSTextAlignmentLeft;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        self.titleLabel.attributedText = attributedString;
        [_containerView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Alert_text_Left_right_margin);
             make.right.mas_equalTo(-Alert_text_Left_right_margin);
            make.top.mas_equalTo(Alert_Text_Top_Bottom_Margin);
            make.height.mas_equalTo(height);
        }];
        
        _alertHorizontalLine = [[UIView alloc]init];
        _alertHorizontalLine.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        [_containerView addSubview:_alertHorizontalLine];
        [_alertHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_containerView);
            make.height.equalTo(@0.5);
            make.top.equalTo(_titleLabel.mas_bottom).offset(Alert_Text_Top_Bottom_Margin);
            make.left.equalTo(_containerView);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self); 
            make.width.equalTo(@(Alert_width));
            make.bottom.equalTo(_alertHorizontalLine.mas_bottom).offset(44);
        }];
        
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        sepLine.tag = vertical_seprator_line_tag;
        [_containerView addSubview:sepLine];
    }
}


#pragma mark - action

- (void)btnClick:(UIButton *)sender event:(UIEvent *)event{
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 1) {
        if (self.preferredStyle == SHIAlertControllerStyleAlert) {
            [self dismissAlertWithViewTag:sender.tag];        
        }else
        {
            [self dismissActionSheetWithViewTag:sender.tag]; 
        }
    }
}

#pragma mark - show && dismiss

- (void)show
{
    if (!self.actions.count) {
        NSLog(@"alertView no actions");
        return;
    }
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    if (self.parentView) {
        [self.parentView addSubview:self];
    }else
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
    
    if (self.preferredStyle == SHIAlertControllerStyleActionSheet) {
        
        [self showActionSheet];
    }else
    {
        [self showAlert];
    }
}

- (void)showActionSheet{
    CGFloat actionHeight = (actionSheet_top_bottom_margin + [self.actions count] *48 + 70) ;
    [UIView animateWithDuration:.266 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.containerView.frame = CGRectMake(0, self.frame.size.height-actionHeight , self.frame.size.width, actionHeight);
        self.bgBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-actionHeight);
        self.alpha = 1.0;
        self.bgBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)showAlert{
    _containerView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    self.alpha = 1.0;    
    CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.0,@0.6,@1.0];
    scaleAnimation.keyTimes = @[@0.0,@0.155,@1.0];
    scaleAnimation.duration = 0.2;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[@0.0,@0.2,@1.0];
    alphaAnimation.keyTimes = @[@0.0,@0.155,@1.0];
    alphaAnimation.duration = 0.2;
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnimation.delegate = self;
    
    CAKeyframeAnimation * scaleAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.values = @[@(1.0),@(1.02),@(1.0)];
    scaleAnimation2.keyTimes = @[@(0.0),@(0.33),@(1.0)];
    scaleAnimation2.duration = 0.2;
    scaleAnimation2.beginTime = 0.2;
    scaleAnimation2.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation2.fillMode = kCAFillModeForwards;
    scaleAnimation2.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation,scaleAnimation2];
    animationGroup.duration = 0.4;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate =self;
    [_containerView.layer addAnimation:animationGroup forKey:@"scale"];
    [self.layer addAnimation:alphaAnimation forKey:@"alpha"]; 
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAAnimation *alphaAnimation = [self.layer animationForKey:@"alpha"];
    if (alphaAnimation == anim) {
        self.layer.opacity = 1.0;
    }
    CAAnimation *scaleAnimation = [self.containerView.layer animationForKey:@"scale"];
    if (scaleAnimation == anim) {
        _containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [_containerView.layer removeAllAnimations];
    }
}

- (void)dismissAlertWithViewTag:(NSInteger)viewTag
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@1.0,@0.6,@0.01];
    scaleAnimation.keyTimes = @[@0.0,@0.85,@1.0];
    scaleAnimation.duration = 0.238;
    [scaleAnimation setFillMode:kCAFillModeForwards];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[@1.0,@0.2,@0.0];
    alphaAnimation.keyTimes = @[@0.0,@0.85,@1.0];
    alphaAnimation.duration = 0.238;
    alphaAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnimation.removedOnCompletion = NO;
    [alphaAnimation setFillMode:kCAFillModeForwards];
    
    [_containerView.layer addAnimation:scaleAnimation forKey:nil];
    [self.layer addAnimation:alphaAnimation forKey:nil];
    
   
    SHIAlertAction *selectAlertAction = [self alertActionWithSelectViewTag:viewTag];
    NSLog(@"selectAlertAction:%@",selectAlertAction.title);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
        if (selectAlertAction.alertActionHander) {
            selectAlertAction.alertActionHander(selectAlertAction);
        }
    });
}

- (void)dismissActionSheetWithViewTag:(NSInteger)viewTag{
    
    SHIAlertAction *selectAlertAction = [self sheetActionWithSelectViewTag:viewTag];
    [UIView animateWithDuration:.266 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.containerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.containerView.frame.size.height);
        self.bgBtn.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
        self.bgBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];    
        self.hidden = YES;
        if (selectAlertAction.alertActionHander) {
            selectAlertAction.alertActionHander(selectAlertAction);
        }
    }];
 
}

#pragma mark - getter && setter

- (SHIAlertAction *)sheetActionWithSelectViewTag:(NSInteger)viewTag{
    
    __block __weak SHIAlertAction *selectAlertAction = nil;
    if (viewTag == cancel_button_tag) {
        [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style ==  SHIAlertActionStyleCancel) {
                selectAlertAction = obj;
            }
        }];
    }else if (viewTag == destructive_button_tag){
        [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style ==  SHIAlertActionStyleDestructive) {
                selectAlertAction = obj;
            }
        }]; 
    }else
    {
        [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style ==  SHIAlertActionStyleDefault) {
                if (idx == viewTag - actionSheet_button_start_tag) {
                    selectAlertAction = obj;
                }
            }
        }]; 
    }
    return selectAlertAction;
}

- (SHIAlertAction *)alertActionWithSelectViewTag:(NSInteger)viewTag{
    __block __weak SHIAlertAction *selectAlertAction = nil;
    UIButton *cancelBtn = [_containerView viewWithTag:cancel_button_tag];
    UIButton *defaultBtn = [_containerView viewWithTag:default_button_tag];
    switch (viewTag) {
        case default_button_tag:
        {
            if (cancelBtn&&defaultBtn) {
                [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.style ==  SHIAlertActionStyleDefault) {
                        selectAlertAction = obj;
                    }
                }];
            }else
            {
                selectAlertAction = [self.actions lastObject];
            }
        }
            break;
        case cancel_button_tag:
        {
            [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.style ==  SHIAlertActionStyleCancel) {
                    selectAlertAction = obj;
                }
            }]; 
        }
            break;
        case destructive_button_tag:
        {
            [self.actions enumerateObjectsUsingBlock:^(SHIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.style ==  SHIAlertActionStyleDestructive) {
                    selectAlertAction = obj;
                }
            }]; 
        }
            break;
        default:
            break;
    }
    return selectAlertAction;
}

- (UIButton *)bgBtn{
    if (_bgBtn == nil) {
        _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgBtn.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
        [_bgBtn addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:Alert_Title_FontSize];
        UILabel *label = [[UILabel alloc]init];
        label.font = titleFont;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.textColor = [UIColor colorWithHex:0x4A4A4A];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [[UIView  alloc]init];
        _containerView.backgroundColor = [UIColor colorWithHex:0xffffff];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.borderColor = [UIColor colorWithHex:0xE2E2E2].CGColor;
        _containerView.layer.borderWidth = 0.5;
    }
    return _containerView;
}


@end
