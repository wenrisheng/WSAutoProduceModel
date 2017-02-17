






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
    [result appendFormat:@"            };"];
    [result appendFormat:@"}"];
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

+ (NSString *)getMTLPropertyJSONTransformerWithPropertyName:(NSString *)propertyName propertyType:(PropertyType)propertyType
{
    NSMutableString *result = [NSMutableString string];
    [result appendFormat:@"+ (NSValueTransformer *)%@JSONTransformer \n", propertyName];
    [result appendFormat:@"{ \n"];
    [result appendFormat:@"    NSValueTransformer *valueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) \n"];
    [result appendFormat:@"    { \n"];
    switch (propertyType) {
        case PropertyTypeString:
        {
            [result appendFormat:@"        return value;"];
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
            [result appendFormat:@"        return value;"];
        }
            break;
        case PropertyTypeNumber:
        {
             [result appendFormat:@"        return value;"];
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

@end
