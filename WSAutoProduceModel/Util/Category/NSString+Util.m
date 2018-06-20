


//
//  NSString+Util.m
//  WSXcodePlugin
//
//  Created by wenrisheng on 17/5/9.
//  Copyright © 2017年 wrs. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString *)capitalizedStringOnyFirstCharacter
{
    NSMutableString *str = [NSMutableString stringWithString:self];
    NSString *firstStr = [str substringToIndex:1];
    [str deleteCharactersInRange:NSMakeRange(0, 1)];
    [str insertString:[firstStr uppercaseString] atIndex:0];
    return str;
}


@end
