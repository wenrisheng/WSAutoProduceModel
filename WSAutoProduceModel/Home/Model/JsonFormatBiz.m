






//
//  MTLJsonUtil.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 17/2/17.
//  Copyright © 2017年 wenrisheng. All rights reserved.
//

#import "JsonFormatBiz.h"

@implementation JsonFormatBiz

+ (void)processJsonObjWithObj:(id)obj key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack
{
    if ([obj isKindOfClass:[NSString class]]) {
       [self processJsonStrWithJsonStr:obj key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        [self processJsonDictionaryWithDictionary:obj key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        [self processJsonArrayWithArray:obj key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
    }
}

+ (void)processJsonStrWithJsonStr:(NSString *)jsonStr key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack
{
    [WSJsonUtil convertJsonStrToObjWithJsonStr:jsonStr handle:^(id obj, NSError *error) {
        if (obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) { // 字典
                [self processJsonDictionaryWithDictionary:obj key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
            } else if([obj isKindOfClass:[NSArray class]]) { // 数组
               [self processJsonArrayWithArray:obj key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
            }
        } else {
            NSLog(@"输入的json格式不对！");
        }
    }];

}

+ (void)processJsonDictionaryWithDictionary:(NSDictionary *)valueDic key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack
{
    NSString *dicStr = [WSJsonUtil convertObjToJson:valueDic];
    NSString *hFileContent = [JsonFormatBiz getHFileContentWithClassName:key classNameExpress:classNameExpress propertiesExpress:propertiesExpress dicStr:dicStr hTempleContent:hTempleContent];
    NSString *mFileContent = [JsonFormatBiz getMFileContentWithClassNameExpress:classNameExpress className:key dicStr:dicStr JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress mTempleContent:mTempleContent];
    if (callBack) {
        callBack(hFileContent, mFileContent, key);
    }
    
    NSArray *allKeys = [valueDic allKeys];
    NSInteger count = allKeys.count;
    for (int i = 0; i < count; i++) {
        NSString *subKey = [allKeys objectAtIndex:i];
        id subValue = [valueDic valueForKey:subKey];
        if ([subValue isKindOfClass:[NSDictionary class]]) {
            [self processJsonDictionaryWithDictionary:subValue key:subKey hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];

        } else if ([subValue isKindOfClass:[NSArray class]]) {
            [self processJsonArrayWithArray:subValue key:subKey hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
        }
    }
}

+ (void)processJsonArrayWithArray:(NSArray *)valueArray key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack
{
    if (valueArray.count > 0) {
        id value = [valueArray objectAtIndex:0];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self processJsonDictionaryWithDictionary:value key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
        } else if([value isKindOfClass:[NSArray class]]){
            [self processJsonArrayWithArray:value key:key hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:classNameExpress propertiesExpress:propertiesExpress JSONSerializingEXpress:JSONSerializingEXpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingEXpress callBack:callBack];
        }
    }
}


#pragma mark - 处理.h 文件
+ (NSString *)getHFileContentWithClassName:(NSString *)className classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress dicStr:(NSString *)jsonStr hTempleContent:(NSString *)hTempleContent
{
    NSMutableString *HTemplate = [NSMutableString stringWithString:hTempleContent];
    // 替换类名
    NSRange classNameRange = [HTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
    if (classNameRange.location != NSNotFound) {
        [HTemplate deleteCharactersInRange:classNameRange];
        [HTemplate insertString:[className capitalizedString] atIndex:classNameRange.location];
        NSLog(@"已经替换完.h类名");
    } else {
        NSLog(@".h模板文件没有发现类名表达式");
    }
    
    // 替换属性
    NSRange  propertiesRange = [HTemplate rangeOfString:propertiesExpress options:NSRegularExpressionSearch];
    if (propertiesRange.location != NSNotFound) {
        [self getPropertiesModelFromJsonDicStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
            if (error) {
                NSLog(@"json字符串转换模型失败:%@", error);
            } else {
                NSString *propertyConvertValue = [self getPropertiesStrFromModelArray:modelArray];
                [HTemplate deleteCharactersInRange:propertiesRange];
                [HTemplate insertString:propertyConvertValue atIndex:propertiesRange.location];
                NSLog(@"已经替换完.h属性");
            }
            
        }];
    } else {
        NSLog(@".h模板文件没有发现属性表达式");
    }
    return HTemplate;
}

#pragma mark - 处理.m 文件
+ (NSString *)getMFileContentWithClassNameExpress:(NSString *)classNameExpress className:(NSString *)className dicStr:(NSString *)jsonStr JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress mTempleContent:(NSString *)mTempleContent
{
    NSMutableString *MTemplate = [NSMutableString stringWithString:mTempleContent];
    while (YES) {
        // 替换类名
        NSRange classNameRange = [MTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
        if (classNameRange.location != NSNotFound) {
            [MTemplate deleteCharactersInRange:classNameRange];
            [MTemplate insertString:[className capitalizedString] atIndex:classNameRange.location];
        } else {
            NSLog(@"已经替换完.m的头文件引入和类名");
            break;
        }
    }
    // 替换MTLJSONSerializing协议属性字符串
    NSRange jsonSerializingRange = [MTemplate rangeOfString:JSONSerializingEXpress options:NSRegularExpressionSearch];
    if (jsonSerializingRange.location != NSNotFound) {
        [self getPropertiesModelFromJsonDicStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
            if (!error) {
                NSMutableString *JSONSerializingEXpressStr = [NSMutableString string];
                NSString *propertyConvertValueStr = [JsonFormatBiz getMTLJSONSerializingPropertiesStrFromModelArray:modelArray];
                NSString *propertyValueTransformStr = [JsonFormatBiz getMTLJSONSerializingPropertiesValueTransformerStrFromModelArray:modelArray];
                [JSONSerializingEXpressStr appendFormat:@"%@ \n", propertyConvertValueStr];
                [JSONSerializingEXpressStr appendFormat:@"%@ \n", propertyValueTransformStr];
                [MTemplate deleteCharactersInRange:jsonSerializingRange];
                [MTemplate insertString:JSONSerializingEXpressStr atIndex:jsonSerializingRange.location];
            }
        }];
    }
    
    // 替换MTLManagedObjectSerializing协议属性字符串
    NSRange managedObjectSerializingRange = [MTemplate rangeOfString:MTLManagedObjectSerializingEXpress options:NSRegularExpressionSearch];
    if (managedObjectSerializingRange.location != NSNotFound) {
        [self getPropertiesModelFromJsonDicStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
            if (!error) {
                NSMutableString *managedObjectSerializingStr = [NSMutableString string];
                NSString *managedObjectSerializing = [JsonFormatBiz getMTLManagedObjectSerializingStrFromModelArray:modelArray entityName:className];
                [managedObjectSerializingStr appendFormat:@"%@ \n", managedObjectSerializing];
                [MTemplate deleteCharactersInRange:managedObjectSerializingRange];
                [MTemplate insertString:managedObjectSerializingStr atIndex:managedObjectSerializingRange.location];
            }
        }];
    }
    return MTemplate;
}

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


#pragma mark -
+ (void)getPropertiesModelFromJsonDicStr:(NSString *)jsonStr handle:(void (^)(NSArray<WSPropertyModel *> *modelArray, NSError *error))handle
{
    [WSJsonUtil convertJsonStrToObjWithJsonStr:jsonStr handle:^(id obj, NSError *error) {
        if (error) {
            NSLog(@"json字符串转换错误！：%@", error);
            if (handle) {
                handle(nil, error);
            }
        } else {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDic = obj;
                NSMutableArray<WSPropertyModel *> *resultArray = [NSMutableArray array];
                NSArray *keys = [jsonDic allKeys];
                NSInteger count = keys.count;
                for (int i = 0; i < count; i++) {
                    id key = [keys objectAtIndex:i];
                    id value = [jsonDic valueForKey:key];
                    NSString *propertyName = key;
                    NSString *propertyType = [JsonFormatBiz getPropertyTypeNameWithValue:value];
                    WSPropertyModel *model = [[WSPropertyModel alloc] init];
                    model.name = propertyName;
                    model.type = propertyType;
                    model.value = value;
                    [resultArray addObject:model];
                }
                if (handle) {
                    handle(resultArray, error);
                }
            } else {
                if (handle) {
                    handle(nil, [NSError errorWithDomain:@"json字符串格式错误！" code:100 userInfo:nil]);
                }
            }
        }
    }];
}

+ (NSString *)getPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray
{
    NSMutableString *result = [NSMutableString string];
    NSInteger count = modelArray.count;
    for (int i = 0; i < count; i++) {
        WSPropertyModel *model = [modelArray objectAtIndex:i];
        NSString *propertyName = model.name;
        propertyName = [self converPropertyName:propertyName];
        NSString *propertyType = model.type;
        NSString *propertyExpress = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;", propertyType, propertyName];
        [result appendString:propertyExpress];
        if (i != count - 1) {
            [result appendString:@"\n"];
        }
    }
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
