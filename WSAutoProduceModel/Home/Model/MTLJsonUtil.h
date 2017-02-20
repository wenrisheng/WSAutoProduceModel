//
//  MTLJsonUtil.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 17/2/17.
//  Copyright © 2017年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PropertyType)
{
    PropertyTypeString = 0,
    PropertyTypeNumber,
    PropertyTypeArray,
    PropertyTypeObject,
    PropertyTypeUnknow
};

@interface MTLJsonUtil : NSObject

// 获取MTLJSONSerializing需要转换的属性字典的字符串
+ (NSString *)getMTLJSONSerializingPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

// 获取MTLJSONSerializing的属性转换方法字符串
+ (NSString *)getMTLJSONSerializingPropertiesValueTransformerStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

+ (NSString *)getMTLManagedObjectSerializingStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray entityName:(NSString *)entityName;

+ (NSString *)getMTLPropertyJSONTransformerWithModel:(WSPropertyModel *)model;
+ (NSString *)getPropertyTypeNameWithValue:(id)value;
+ (PropertyType)getPropertyTypeWithModel:(WSPropertyModel *)model;

@end
