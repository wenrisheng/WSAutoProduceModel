//
//  WSFileUtil.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSFileUtil : NSObject

+ (BOOL)createFileAtFilePath:(NSString *)filePath contents:(NSData *)data attributes:(NSDictionary<NSString *, id> *)attr;

+ (void)getFileContentInBundleWithResource:(NSString *)name ofType:(NSString *)ext handle:(void(^)(NSString *fileContent, NSError *error))handle;

+ (void)getFileContentWithFilePath:(NSString *)filePath handle:(void(^)(NSString *fileContent, NSError *error))handle;

@end
