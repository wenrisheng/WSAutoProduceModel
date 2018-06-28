//
//  SwiftJsonToCodeBiz.m
//  WSAutoProduceModel
//
//  Created by wrs on 2018/6/28.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import "SwiftJsonToCodeBiz.h"
#import "JsonToCodeBiz.h"

@implementation SwiftJsonToCodeBiz

+ (void)processJsonObjWithObj:(id)obj key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express callBack:(void(^)(NSString *fileContent, NSString *key))callBack
{
    if ([obj isKindOfClass:[NSString class]]) {
        [self processJsonStrWithStr:obj key:key templeContent:templeContent express:express callBack:callBack];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        [self processJsonDictionaryWithDic:obj key:key templeContent:templeContent express:express callBack:callBack];
    } else if([obj isKindOfClass:[NSArray class]]) {
        [self processJsonArrayWithArray:obj key:key templeContent:templeContent express:express callBack:callBack];
    }
}

+ (void)processJsonStrWithStr:(NSString *)str key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express callBack:(void(^)(NSString *fileContent, NSString *key))callBack
{
    
}

+ (void)processJsonDictionaryWithDic:(NSDictionary *)dic key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express callBack:(void(^)(NSString *fileContent, NSString *key))callBack
{
    NSString *swiftFileContent = [self getSwiftFileContentWithDictionary:dic key:key templeContent:templeContent express:express];
    if (callBack) {
        callBack(swiftFileContent, key);
    }
}

+ (void)processJsonArrayWithArray:(NSArray *)Array key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express callBack:(void(^)(NSString *fileContent, NSString *key))callBack
{
    
}

#pragma mark -
+ (NSString *)getSwiftFileContentWithDictionary:(NSDictionary *)dic key:(NSString *)key templeContent:(NSString *)templeContent express:(NSString *)express
{
    NSMutableString *fileContent = [NSMutableString string];
    [fileContent appendFormat:@"class %@: HandyJSON {\n", [key capitalizedStringOnyFirstCharacter]];
    [self getVarStrWithDictionary:dic callBack:^(NSString *varStr, NSError *error) {
        if (varStr) {
            [fileContent appendFormat:@"%@\n", varStr];
        }
    }];
    
    return @"";
}

+ (void)getVarStrWithDictionary:(NSDictionary *)dictionary callBack:(void(^)(NSString *varStr, NSError *error))callBack
{
    
    NSString *dicStr = [WSJsonUtil convertObjToJson:dictionary];
    [JsonToCodeBiz getPropertiesModelFromJsonDicStr:dicStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
        if (error) {
            if (callBack) {
                callBack(nil, error);
            }
        } else {
            NSMutableString *allVarStr = [NSMutableString string];
            NSInteger count = modelArray.count;
            for (int i = 0; i < count; i++) {
                WSPropertyModel *model = [modelArray objectAtIndex:i];
                NSString *varStr = [self getVarStrinWithModel:model];
                [allVarStr appendString:varStr];
                if (i != count - 1) {
                    [allVarStr appendString:@"\n"];
                }
            }
            if (callBack) {
                callBack(allVarStr, nil);
            }
        }
       
    }];
}

+ (NSString *)getVarStrinWithModel:(WSPropertyModel *)model
{
    PropertyType propertyType = [JsonToCodeBiz getPropertyTypeWithModel:model];
    switch (propertyType) {
        case PropertyTypeNumber:
        {
            return [NSString stringWithFormat:@"    var %@: NSNumber?", model.name];
        }
            break;
        case PropertyTypeString:
        {
            return [NSString stringWithFormat:@"    var %@: String?", model.name];
        }
            break;
        case PropertyTypeObject:
        {
            return [NSString stringWithFormat:@"    var %@: NSNumber?", model.name];
        }
            break;
        case PropertyTypeArray:
        {
            return [NSString stringWithFormat:@"    var %@: Array<%@>?", model.name, [model.name capitalizedStringOnyFirstCharacter]];
        }
            break;
        default:
            break;
    }
   return @"";
}


@end
