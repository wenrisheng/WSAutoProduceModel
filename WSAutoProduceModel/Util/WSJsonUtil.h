//
//  WSJsonUtil.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSJsonUtil : NSObject

+ (void)convertJsonStrToObjWithJsonStr:(NSString *)jsonStr handle:(void(^)(id obj, NSError *error))handle;

@end
