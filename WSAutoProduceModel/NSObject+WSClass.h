//
//  NSObject+WSClass.h
//  WSBase
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WSClass)

+ (NSString *)getClassName;
+ (NSArray *)getProperties;


- (NSString *)getClassName;

- (NSArray *)getProperties;

@end
