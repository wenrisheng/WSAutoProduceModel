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

// 获取MTLJSONSerializing的字符串
+ (NSString *)getMTLJSONSerializingPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

+ (NSString *)getMTLPropertyJSONTransformerWithPropertyName:(NSString *)propertyName propertyType:(PropertyType)propertyType;

@end
