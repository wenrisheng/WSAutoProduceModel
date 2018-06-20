//
//  WSNumUtil.h
//  WSXcodePlugin
//
//  Created by wenrisheng on 17/5/16.
//  Copyright © 2017年 wrs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSNumUtil : NSObject

+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (BOOL)isPureDouble:(NSString*)string;

@end
