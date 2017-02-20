






//
//  MTLJsonUtil.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 17/2/17.
//  Copyright © 2017年 wenrisheng. All rights reserved.
//

#import "MTLJsonUtil.h"

@implementation MTLJsonUtil

+ (NSString *)getMTLJSONSerializingPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray
{
    NSMutableString *result = [NSMutableString string];
    [result appendFormat:@"#pragma mark - MTLJSONSerializing \n"];
    [result appendFormat:@"+ (NSDictionary *)JSONKeyPathsByPropertyKey \n"];
    [result appendFormat:@"{\n"];
    [result appendFormat:@"    return @{\n"];
    NSInteger count = modelArray.count;
    for (int i = 0; i < count; i++) {
        WSPropertyModel *model = [modelArray objectAtIndex:i];
        NSString *propertyName = model.name;
        NSString *jsonKey = propertyName;
        propertyName = [self converPropertyName:propertyName];
        NSString *lineStr = nil;
        if (i == 0) {
            lineStr = [NSString stringWithFormat:@"                 @\"%@\": @\"%@\", \n", propertyName, jsonKey];
        } else {
            lineStr = [NSString stringWithFormat:@"                 @\"%@\": @\"%@\", \n", propertyName, jsonKey];
        }
        [result appendString:lineStr];
    }
    [result appendFormat:@"            }; \n"];
    [result appendFormat:@"} \n"];
    return result;
}

+ (NSString *)getMTLJSONSerializingPropertiesValueTransformerStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray
{
    NSMutableString *result = [NSMutableString string];
    NSInteger count = modelArray.count;
    for (int i = 0; i < count; i++) {
        WSPropertyModel *model = [modelArray objectAtIndex:i];
        NSString *propertyValueTransformerStr = [self getMTLPropertyJSONTransformerWithModel:model];
        [result appendFormat:@"%@ \n", propertyValueTransformerStr];
    }
    return result;
}

+ (NSString *)getMTLManagedObjectSerializingStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray entityName:(NSString *)entityName
{
    NSMutableString *result = [NSMutableString string];
    [result appendFormat:@"#pragma mark - MTLManagedObjectSerializing \n"];
    [result appendFormat:@"+ (NSString *)managedObjectEntityName \n"];
    [result appendFormat:@"{\n"];
    [result appendFormat:@"    return @\"%@\"; \n", entityName];
    [result appendFormat:@"} \n"];
    [result appendFormat:@"\n"];
    [result appendFormat:@"+ (NSDictionary *)managedObjectKeysByPropertyKey{ \n"];
    [result appendFormat:@"    return @{ \n"];
    NSInteger count = modelArray.count;
    for (int i = 0; i < count; i++) {
        WSPropertyModel *model = [modelArray objectAtIndex:i];
        NSString *propertyName = model.name;
        NSString *jsonKey = propertyName;
        propertyName = [self converPropertyName:propertyName];
        NSString *lineStr = nil;
        if (i == 0) {
            lineStr = [NSString stringWithFormat:@"                 @\"%@\": @\"%@\", \n", propertyName, jsonKey];
        } else {
            lineStr = [NSString stringWithFormat:@"                 @\"%@\": @\"%@\", \n", propertyName, jsonKey];
        }
        [result appendString:lineStr];
    }
    [result appendFormat:@"            }; \n"];
    [result appendFormat:@"} \n"];
    return result;
}

+ (NSString *)converPropertyName:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"id"]) {
        return @"_id";
    } else {
        return propertyName;
    }
}

+ (NSString *)getMTLPropertyJSONTransformerWithModel:(WSPropertyModel *)model
{
    NSString *propertyName = model.name;
    PropertyType propertyType = [self getPropertyTypeWithModel:model];
    NSMutableString *result = [NSMutableString string];
    [result appendFormat:@"+ (NSValueTransformer *)%@JSONTransformer \n", propertyName];
    [result appendFormat:@"{ \n"];
    [result appendFormat:@"    NSValueTransformer *valueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) \n"];
    [result appendFormat:@"    { \n"];
    switch (propertyType) {
        case PropertyTypeString:
        {
            [result appendFormat:@"                                                if ([value isEqualToString:@\"NULL\"]) { \n"];
            [result appendFormat:@"                                 return nil; \n"];
            [result appendFormat:@"                             } else { \n"];
            [result appendFormat:@"                                 return value; \n"];
            [result appendFormat:@"                             } \n"];
        }
            break;
        case PropertyTypeNumber:
        {
            [result appendFormat:@"        if ([value isKindOfClass:[NSString class]]) { \n"];
            [result appendFormat:@"            return @(0); \n"];
            [result appendFormat:@"        } else { \n"];
            [result appendFormat:@"            return value; \n"];
            [result appendFormat:@"        } \n"];
        }
            break;
        case PropertyTypeArray:
        {
            [result appendFormat:@"        NSError *jsonError = nil; \n"];
            [result appendFormat:@"        id model = [MTLJSONAdapter modelOfClass:[%@ class] fromJSONArray:value error:&jsonError]; \n", propertyName];
            [result appendFormat:@"        if (jsonError) { \n"];
            [result appendFormat:@"            DLog(@\"%@字典转模型失败！error:%%@:jsonError\"); \n", propertyName];
            [result appendFormat:@"        } \n"];
        }
            break;
        case PropertyTypeObject:
        {
            [result appendFormat:@"        NSError *jsonError = nil; \n"];
            [result appendFormat:@"        id model = [MTLJSONAdapter modelOfClass:[%@ class] fromJSONDictionary:value error:&jsonError]; \n", propertyName];
            [result appendFormat:@"        if (jsonError) { \n"];
            [result appendFormat:@"            DLog(@\"%@字典转模型失败！error:%%@:jsonError\"); \n", propertyName];
            [result appendFormat:@"        } \n"];
        }
            break;
        case PropertyTypeUnknow:
        {
            
        }
            break;
        default:
            break;
    }
    
    [result appendFormat:@"    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) \n"];
    [result appendFormat:@"    { \n"];
    switch (propertyType) {
        case PropertyTypeString:
        {
            [result appendFormat:@"        return value; \n"];
        }
            break;
        case PropertyTypeNumber:
        {
             [result appendFormat:@"        return value; \n"];
        }
            break;
        case PropertyTypeArray:
        {
            [result appendFormat:@"        NSError *jsonError = nil; \n"];
            [result appendFormat:@"        id model = [MTLJSONAdapter JSONArrayFromModels:value error:&jsonError]; \n"];
            [result appendFormat:@"        if (jsonError) { \n"];
            [result appendFormat:@"            DLog(@\"%@模型转字典失败！error:%%@:jsonError\"); \n", propertyName];
            [result appendFormat:@"        } \n"];
        }
            break;
        case PropertyTypeObject:
        {
            [result appendFormat:@"        NSError *jsonError = nil; \n"];
            [result appendFormat:@"        id model = [MTLJSONAdapter JSONDictionaryFromModel:value error:&jsonError]; \n"];
            [result appendFormat:@"        if (jsonError) { \n"];
            [result appendFormat:@"            DLog(@\"%@模型转字典失败！error:%%@:jsonError\"); \n", propertyName];
            [result appendFormat:@"        } \n"];
        }
            break;
        case PropertyTypeUnknow:
        {
            
        }
            break;
        default:
            break;
    }
    [result appendFormat:@"    }]; \n"];
    [result appendFormat:@"    return valueTransformer; \n"];
    [result appendFormat:@"} \n"];
    
    return result;
}

+ (PropertyType)getPropertyTypeWithModel:(WSPropertyModel *)model
{
    id value = model.value;
    return [self getPropertyTypeWithValue:value];
}

+ (NSString *)getPropertyTypeNameWithValue:(id)value
{
    PropertyType propertyType = [self getPropertyTypeWithValue:value];
    switch (propertyType) {
        case PropertyTypeString:
        {
            return @"NSString";
        }
            break;
        case PropertyTypeNumber:
        {
            return @"NSNumber";
        }
            break;
        case PropertyTypeArray:
        {
            return @"NSArray";
        }
            break;
        case PropertyTypeObject:
        {
             return @"NSDictionary";
        }
            break;
        case PropertyTypeUnknow:
        {
            
        }
            break;
        default:
            break;
    }
    return @"NSObject";
}

+ (PropertyType)getPropertyTypeWithValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return PropertyTypeString;
    } else if ([value isKindOfClass:[NSArray class]]) {
        return PropertyTypeArray;
    } else if([value isKindOfClass:[NSNumber class]]) {
        return PropertyTypeNumber;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return PropertyTypeObject;
    } else {
        return PropertyTypeUnknow;
    }
}

@end
