//
//  NSString+TextHeight.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import "NSString+TextHeight.h"

@implementation NSString (TextHeight)

- (CGSize)sizeWithFont:(UIFont *)font constrainSize:(CGSize)constrainSize mode:(NSLineBreakMode)mode lineSpace:(float)lineSpace rowHeight:(float)rowHeight
{
    if(!mode) mode = NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:mode];
    [style setLineSpacing:lineSpace];
    [style setLineHeightMultiple:rowHeight];
    return [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size;
}

@end
