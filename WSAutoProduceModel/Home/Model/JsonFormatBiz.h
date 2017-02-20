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

@interface JsonFormatBiz : NSObject

+ (void)processJsonObjWithObj:(id)obj key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack;

+ (void)processJsonDictionaryWithDictionary:(NSDictionary *)valueDic key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack;

+ (void)processJsonArrayWithArray:(NSArray *)valueArray key:(NSString *)key hTempleContent:(NSString *)hTempleContent mTempleContent:(NSString *)mTempleContent classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress callBack:(void(^)(NSString *hFileContent, NSString *mFileContent, NSString *key))callBack;

// 获取.h 文件内容
+ (NSString *)getHFileContentWithClassName:(NSString *)className classNameExpress:(NSString *)classNameExpress propertiesExpress:(NSString *)propertiesExpress dicStr:(NSString *)jsonStr hTempleContent:(NSString *)hTempleContent;

// 获取.m 文件内容
+ (NSString *)getMFileContentWithClassNameExpress:(NSString *)classNameExpress className:(NSString *)className dicStr:(NSString *)jsonStr JSONSerializingEXpress:(NSString *)JSONSerializingEXpress MTLManagedObjectSerializingEXpress:(NSString *)MTLManagedObjectSerializingEXpress mTempleContent:(NSString *)mTempleContent;

// 获取.m MTLJSONSerializing需要转换的属性字典的字符串
+ (NSString *)getMTLJSONSerializingPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

// 获取.m MTLJSONSerializing的属性转换方法字符串
+ (NSString *)getMTLJSONSerializingPropertiesValueTransformerStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

// 获取.m MTLManagedObjectSerializing需要转换方法字符串
+ (NSString *)getMTLManagedObjectSerializingStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray entityName:(NSString *)entityName;

// 获取.h文件的属性替换字符串
+ (NSString *)getPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray;

+ (NSString *)getMTLPropertyJSONTransformerWithModel:(WSPropertyModel *)model;
+ (NSString *)getPropertyTypeNameWithValue:(id)value;
+ (PropertyType)getPropertyTypeWithModel:(WSPropertyModel *)model;

@end
