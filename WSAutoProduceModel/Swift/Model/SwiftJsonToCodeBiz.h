//
//  SwiftJsonToCodeBiz.h
//  WSAutoProduceModel
//
//  Created by wrs on 2018/6/28.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwiftJsonToCodeBiz : NSObject

+ (void)processJsonObjWithObj:(id)obj key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express callBack:(void(^)(NSString *fileContent, NSString *key))callBack;

@end
