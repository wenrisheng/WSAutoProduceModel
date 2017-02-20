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

+ (NSString *)convertObjToJson:(id)obj
{
    if (!obj) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        NSLog(@"对象转Json解析失败：%@",error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
