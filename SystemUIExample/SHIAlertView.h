//
//  SHIAlertView.h
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//


/*
 alert 只支持两个按钮
 如果
 alert继承 window,则window需要global变量保存 
 
 */

#import <UIKit/UIKit.h>
#import "SHIAlertAction.h"

typedef NS_ENUM(NSInteger, SHIAlertControllerStyle) {
    SHIAlertControllerStyleActionSheet = 0,
    SHIAlertControllerStyleAlert
} NS_ENUM_AVAILABLE_IOS(8_0);


NS_CLASS_AVAILABLE_IOS(8_0) @interface SHIAlertView : UIView

+ (instancetype _Nonnull )alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(SHIAlertControllerStyle)preferredStyle;

- (void)addAction:(SHIAlertAction *_Nullable)action;

- (void)show;

@property (nonatomic, assign)UIView *parentView;

@property (nonatomic, readonly) NSMutableArray<SHIAlertAction *> * _Nullable actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) SHIAlertControllerStyle preferredStyle;

@end
