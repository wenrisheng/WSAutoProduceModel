//
//  AppService.h
//  WSAutoProduceModel
//
//  Created by wrs on 2018/7/2.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 属性类型
typedef NS_ENUM(NSInteger, PropertyType)
{
    PropertyTypeString = 0, // 字符串
    PropertyTypeNumber,     // 数字
    PropertyTypeInt,        // 整型
    PropertyTypeFloat,       // 浮点型
    PropertyTypeDouble,      // 双精度浮点型
    PropertyTypeArray,       // 数组
    PropertyTypeObject,       // 对象
    PropertyTypeUnknow        // 未知
};

// 语言类型
typedef NS_ENUM(NSInteger, LanguageType)
{
    LanguageTypeOC = 0, // Object-C
    LanguageTypeSwift    // Swift
};

// 转换选项
typedef NS_ENUM(NSInteger, TransformItem)
{
    TransformItemJSONSerializing = 0, // JSONSerializing
    TransformItemManagedObjectSerializing = 1 << 0,
};

typedef NS_ENUM(NSInteger, FrameworkType)
{
    FrameworkTypeMantle = 0,
    FrameworkTypeMJExtension,
    FrameworkTypeJSONModel
};


@interface AppService : NSObject

+ (LanguageType)getCurrentLanguageType;
+ (void)setCurrentLanguageType:(LanguageType)type;

@end
