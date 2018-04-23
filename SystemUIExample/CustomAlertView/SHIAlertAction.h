//
//  SHIPromotAction.h
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/20.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHIAlertAction;
typedef  void (^AlertSelectedHander)(SHIAlertAction * _Nonnull action) ;

typedef NS_ENUM(NSInteger, SHIAlertActionStyle) {
    SHIAlertActionStyleDefault = 0,
    SHIAlertActionStyleCancel,
    SHIAlertActionStyleDestructive
} NS_ENUM_AVAILABLE_IOS(8_0);

NS_CLASS_AVAILABLE_IOS(8_0) @interface SHIAlertAction : NSObject <NSCopying>

+ (instancetype _Nullable )actionWithTitle:(nullable NSString *)title style:(SHIAlertActionStyle)style handler:(void (^ __nullable)(SHIAlertAction * _Nonnull action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) SHIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic,copy)AlertSelectedHander _Nullable alertActionHander;
@end
