//
//  SHIAlertView.h
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//


/*
 alert 只支持两个按钮
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHIAlertActionStyle) {
    SHIAlertActionStyleDefault = 0,
    SHIAlertActionStyleCancel,
    SHIAlertActionStyleDestructive
} NS_ENUM_AVAILABLE_IOS(8_0);

typedef NS_ENUM(NSInteger, SHIAlertControllerStyle) {
    SHIAlertControllerStyleActionSheet = 0,
    SHIAlertControllerStyleAlert
} NS_ENUM_AVAILABLE_IOS(8_0);



NS_CLASS_AVAILABLE_IOS(8_0) @interface SHIAlertAction : NSObject <NSCopying>

+ (instancetype _Nullable )actionWithTitle:(nullable NSString *)title style:(SHIAlertActionStyle)style handler:(void (^ __nullable)(SHIAlertAction * _Nonnull action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) SHIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface SHIAlertView : UIWindow

+ (instancetype _Nonnull )alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(SHIAlertControllerStyle)preferredStyle;

- (void)addAction:(SHIAlertAction *_Nullable)action;

- (void)show;
@property (nonatomic, readonly) NSMutableArray<SHIAlertAction *> * _Nullable actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) SHIAlertControllerStyle preferredStyle;

@end
