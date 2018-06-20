



//
//  WSNumUtil.m
//  WSXcodePlugin
//
//  Created by wenrisheng on 17/5/16.
//  Copyright © 2017年 wrs. All rights reserved.
//

#import "WSNumUtil.h"

@implementation WSNumUtil

//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureDouble:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

@end
