//
//  WSFileUtil.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "WSFileUtil.h"

@implementation WSFileUtil

+ (BOOL)createFileAtFilePath:(NSString *)filePath contents:(NSData *)data attributes:(NSDictionary<NSString *,id> *)attr
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExit = [fileManager fileExistsAtPath:filePath isDirectory:(&isDir)];
    if (fileExit && !isDir) {
        NSLog(@"已经存在%@文件", filePath);
    }
    BOOL createSuc = [fileManager createFileAtPath:filePath contents:data attributes:attr];
    return createSuc;
}

+ (void)getFileContentInBundleWithResource:(NSString *)name ofType:(NSString *)ext handle:(void (^)(NSString *, NSError *))handle
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSError *readFileError = nil;
    NSString *filePath = [mainBundle pathForResource:name ofType:ext];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&readFileError];
    if (handle) {
        if (readFileError) {
            handle(nil, readFileError);
        } else {
            handle(fileContent, nil);
        }
    }
}

@end
