
//
//  AppService.m
//  WSAutoProduceModel
//
//  Created by wrs on 2018/7/2.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import "AppService.h"

#define kLanguageTypeKey  @"kLanguageTypeKey"

@implementation AppService

+ (LanguageType)getCurrentLanguageType
{
    LanguageType type = LanguageTypeOC;
   NSNumber *typeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kLanguageTypeKey];
    if (typeNum) {
        type = [typeNum integerValue];
    }
    return type;
}

+ (void)setCurrentLanguageType:(LanguageType)type
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithInt:type] forKey:kLanguageTypeKey];
    [userDefault synchronize];
}

@end
