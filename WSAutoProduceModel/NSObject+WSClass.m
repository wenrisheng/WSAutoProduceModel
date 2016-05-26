//
//  NSObject+WSClass.m
//  WSBase
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "NSObject+WSClass.h"
#import <objc/runtime.h>

@implementation NSObject (WSClass)

+ (NSString *)getClassName
{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

+ (NSArray *)getProperties
{
    NSMutableArray *propertiesArray = [NSMutableArray array];
    //对字典本身的属性进行过滤
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    for(int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        [propertiesArray addObject:propName];
        
    }
    free(props);
    
    return propertiesArray;
}

- (NSString *)getClassName
{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

- (NSArray *)getProperties
{
    NSMutableArray *propertiesArray = [NSMutableArray array];
    //对字典本身的属性进行过滤
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    for(int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        [propertiesArray addObject:propName];
        
    }
    free(props);
    
    return propertiesArray;
}


@end
