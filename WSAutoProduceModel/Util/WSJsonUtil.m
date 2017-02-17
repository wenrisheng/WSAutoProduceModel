//
//  WSJsonUtil.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "WSJsonUtil.h"

@implementation WSJsonUtil

+ (void)convertJsonStrToObjWithJsonStr:(NSString *)jsonStr handle:(void (^)(id, NSError *))handle
{
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (handle) {
        if (error) {
            handle(nil, error);
        } else {
            handle(obj, nil);
        }
    }
}

@end
