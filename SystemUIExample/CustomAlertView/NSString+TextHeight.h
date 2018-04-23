//
//  NSString+TextHeight.h
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (TextHeight)

- (CGSize)sizeWithFont:(UIFont *)font constrainSize:(CGSize)constrainSize mode:(NSLineBreakMode)mode lineSpace:(float)lineSpace rowHeight:(float)rowHeight;

@end
