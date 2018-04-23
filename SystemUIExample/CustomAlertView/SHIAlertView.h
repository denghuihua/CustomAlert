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
 
 注意：alert 添加在keywindow上，当项目中有keyWindow切换时，比如广告开屏占用keywindow，这时storylist业务里添加上keyWindow上的弹框将会出现，这是不友好的，需要传入parentView
 
 更好的实现方式：采用presention动画的方式，demo已突破技术难题，代码需要继续码
 
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

@property (nonatomic, assign)UIView *_Nullable parentView;

@property (nonatomic, readonly) NSMutableArray<SHIAlertAction *> * _Nullable actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) SHIAlertControllerStyle preferredStyle;

@end
