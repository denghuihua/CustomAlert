//
//  SHIPromotAction.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/20.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import "SHIAlertAction.h"


@interface SHIAlertAction(){
    
}

@end

@implementation SHIAlertAction

+ (instancetype _Nullable )actionWithTitle:(nullable NSString *)title style:(SHIAlertActionStyle)style handler:(void (^ __nullable)(SHIAlertAction * _Nonnull action))handler{
    SHIAlertAction *action = [[SHIAlertAction alloc]initWithTitle:title style:style handler:handler];
    return action;
}

- (instancetype _Nullable )initWithTitle:(nullable NSString *)title style:(SHIAlertActionStyle)style handler:(void (^ __nullable)(SHIAlertAction * _Nonnull action))handler{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _alertActionHander = handler;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    SHIAlertAction *newAction = [[SHIAlertAction allocWithZone:zone]initWithTitle:_title style:_style handler:_alertActionHander];
    return newAction;
}

@end
