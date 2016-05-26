//
//  ViewController.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+WSClass.h"

#define WSFileSavePath    @"WSFileSavePath"
#define WSClassName       @"WSClassName"
#define WSJsonStr         @"WSJsonStr"

#define WSPropertyValue   @"WSPropertyValue"
#define WSPropertyName    @"WSPropertyName"
#define WSPropertyType    @"WSPropertyType"

#define ClassNameExpress  @"#className#"
#define PropertiesExpress @"#properties#"
#define HImportExpress    @"#className.h#"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *savePath = [userDefaults objectForKey:WSFileSavePath];
    NSString *className = [userDefaults objectForKey:WSClassName];
    NSString *jsonStr = [userDefaults objectForKey:WSJsonStr];
    if (savePath.length > 0) {
        self.savePathTextField.stringValue = savePath;
    }
    if (className.length > 0) {
        self.classNameTextField.stringValue = className;
    }
    if (jsonStr.length > 0) {
        self.jsonStrTextView.string = jsonStr;
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)productButAction:(NSButton *)sender {
    
    NSString *className = self.classNameTextField.stringValue;
    NSString *savePath = self.savePathTextField.stringValue;
    NSString *jsonStr = self.jsonStrTextView.string;
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:savePath forKey:WSFileSavePath];
    [userDefaults setValue:className forKey:WSClassName];
    [userDefaults setValue:jsonStr forKey:WSJsonStr];
    
    NSString *HFileName = [NSString stringWithFormat:@"%@.h", className];
    NSString *MFileName = [NSString stringWithFormat:@"%@.m", className];

    NSString *HFilePath = [savePath stringByAppendingPathComponent:HFileName];
    NSString *MFilePath = [savePath stringByAppendingPathComponent:MFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL HisDir = NO;
    BOOL HFileExit = [fileManager fileExistsAtPath:HFilePath isDirectory:(&HisDir)];
    if (HFileExit) {
        NSLog(@"已经存在%@文件", HFileName);
    }
    
    /*****************生成.h文件*********************/
    BOOL HFileCreate = [fileManager createFileAtPath:HFilePath contents:nil attributes:nil];
    if (HFileCreate) {
        NSLog(@".h文件创建成功");
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSError *readHFileError = nil;
        NSString *HTemplatePath = [mainBundle pathForResource:@"WSNormalTemplateH" ofType:@"txt"];
        NSString *HTemplate = [NSString stringWithContentsOfFile:HTemplatePath encoding:NSUTF8StringEncoding error:&readHFileError];
        if (readHFileError) {
            NSLog(@"读取.h模板文件错误:%@", readHFileError);
        } else {
            NSMutableString *HResultStr = [NSMutableString stringWithString:HTemplate];
            
            // 替换类名
            NSString *classNameExpress = ClassNameExpress;
            NSRange classNameRange = [HTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
            if (classNameRange.location != NSNotFound) {
                [HResultStr deleteCharactersInRange:classNameRange];
                [HResultStr insertString:className atIndex:classNameRange.location];
            } else {
                NSLog(@".h模板文件没有发现类名表达式");
            }
            
            // 替换属性
            NSString *propertiesExpress = PropertiesExpress;
            NSRange  propertiesRange = [HResultStr rangeOfString:propertiesExpress options:NSRegularExpressionSearch];
            if (propertiesRange.location != NSNotFound) {
                NSArray *dataArray = [self getPropertiesFromJson:jsonStr];
                NSString *propertyConvertValue = [self getPropertiesStrFromDataArray:dataArray];
                [HResultStr deleteCharactersInRange:propertiesRange];
                [HResultStr insertString:propertyConvertValue atIndex:propertiesRange.location];
            } else {
                NSLog(@".h模板文件没有发现属性表达式");
            }

            // .h文件数据写入
            BOOL HWrite=[HResultStr writeToFile:HFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (HWrite) {
                NSLog(@".h写入成功");
            } else {
                NSLog(@".h文件写入失败");
            }
        }
    } else {
        NSLog(@".h文件创建失败");
    }
    
    
   /*****************生成.m文件*********************/
    BOOL MisDir = NO;
    BOOL MFileExit = [fileManager fileExistsAtPath:HFilePath isDirectory:(&MisDir)];
    if (MFileExit) {
        NSLog(@"已经存在%@文件", MFileName);
    }
    BOOL MFileCreate = [fileManager createFileAtPath:MFilePath contents:nil attributes:nil];
    if (MFileCreate) {
        NSLog(@".m文件创建成功");
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSError *readMFileError = nil;
        NSString *MTemplatePath = [mainBundle pathForResource:@"WSNormalTemplateM" ofType:@"txt"];
        NSString *MTemplate = [NSString stringWithContentsOfFile:MTemplatePath encoding:NSUTF8StringEncoding error:&readMFileError];
        if (readMFileError) {
            NSLog(@"读取.m模板文件错误:%@", readMFileError);
        } else {
             NSMutableString *MResultStr = [NSMutableString stringWithString:MTemplate];
            
            // 替换头文件import
            NSString *hImportExpress = HImportExpress;
            NSRange hImportRange = [MTemplate rangeOfString:hImportExpress options:NSRegularExpressionSearch];
            if (hImportRange.location != NSNotFound) {
                NSString *importStr = HFileName;
                [MResultStr deleteCharactersInRange:hImportRange];
                [MResultStr insertString:importStr atIndex:hImportRange.location];
            }
            
//            e行宝
            // 替换类名
            NSString *classNameExpress = ClassNameExpress;
            NSRange classNameRange = [MTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
            if (classNameRange.location != NSNotFound) {
                [MResultStr deleteCharactersInRange:classNameRange];
                [MResultStr insertString:className atIndex:classNameRange.location];
            } else {
                NSLog(@".m模板文件没有发现类名表达式");
            }
            
            // .m文件数据写入
            BOOL MWrite=[MResultStr writeToFile:MFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (MWrite) {
                NSLog(@".m写入成功");
            } else {
                NSLog(@".m文件写入失败");
            }
        }
    } else {
        NSLog(@".m文件创建失败");
    }

}

- (NSString *)getPropertyConvertValueWithJsonStr:(NSString *)jsonStr
{
    return nil;
}

- (NSArray *)getPropertiesFromJson:(NSString *)jsonStr
{
    NSError *jsonError = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
    if (jsonStr) {
        NSLog(@"json字符串转换错误！");
    }
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *keys = [jsonDic allKeys];
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *model = [NSMutableDictionary dictionary];
        id key = [keys objectAtIndex:i];
        id value = [jsonDic valueForKey:key];
        NSString *propertyName = key;
        NSString *propertyType = [self getPropertyTypeWithValue:value];
        [model setValue:propertyName forKey:WSPropertyName];
        [model setValue:propertyType forKey:WSPropertyType];
        [resultArray addObject:model];
    }
    return resultArray;
}

- (NSString *)getPropertiesStrFromDataArray:(NSArray *)dataArray
{
    NSMutableString *result = [NSMutableString string];
    NSInteger count = dataArray.count;
    for (int i = 0; i < count; i++) {
        NSDictionary *model = [dataArray objectAtIndex:i];
        NSString *propertyName = [model objectForKey:WSPropertyName];
        NSString *propertyType = [model objectForKey:WSPropertyType];
        NSString *propertyExpress = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;", propertyType, propertyName];
        [result appendString:propertyExpress];
        if (i != count - 1) {
            [result appendString:@"\n"];
        }
    }
    return result;
}

- (NSString *)getPropertyTypeWithValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return @"NSString";
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return @"NSNumber";
    } else if ([value isKindOfClass:[NSArray class]]) {
        return @"NSArray";
    }
    return @"NSObject";
}

@end
