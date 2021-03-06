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
    
    NSArray *pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString *fileName = [pathArray lastObject];
    NSString *dirPath = [filePath substringToIndex:(filePath.length - fileName.length)];
    
    // 判断文件夹是否存在，不存在就创建
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExit = [fileManager fileExistsAtPath:dirPath isDirectory:(&isDir)];
    if (!dirExit || !isDir) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件夹失败！:%@", error);
            return NO;
        }
    }
   
    BOOL createSuc = [fileManager createFileAtPath:filePath contents:data attributes:attr];
    return createSuc;
}

+ (NSString *)getFileContentInBundleWithResource:(NSString *)name ofType:(NSString *)ext
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:name ofType:ext];
    return [self getFileContentWithFilePath:filePath];
}

+ (NSString *)getFileContentWithFilePath:(NSString *)filePath
{
    NSError *readFileError = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&readFileError];
    return fileContent;
}

@end
