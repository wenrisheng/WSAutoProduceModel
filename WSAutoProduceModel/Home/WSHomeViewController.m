//
//  WSHomeViewController.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "WSHomeViewController.h"
#import "WSPreviewWindowController.h"
#import "WSPreviewViewController.h"
#import "MTLJsonUtil.h"

#define WSFileSavePath                      @"WSFileSavePath"
#define WSClassName                         @"WSClassName"
#define WSJsonStr                           @"WSJsonStr"

#define ClassNameExpress                    @"#className#"
#define PropertiesExpress                   @"#properties#"
#define MTLJSONSerializingExpress           @"#MTLJSONSerializing#"
#define MTLManagedObjectSerializingExpress  @"#MTLManagedObjectSerializing#"

@interface WSHomeViewController ()

@property (strong, nonatomic) WSPreviewWindowController *previewWC;
@property (strong, nonatomic) NSString *HFilePath;
@property (strong, nonatomic) NSString *HFileName;
@property (strong, nonatomic) NSString *HFileContent;

@property (strong, nonatomic) NSString *MFilePath;
@property (strong, nonatomic) NSString *MFileName;
@property (strong, nonatomic) NSString *MFileContent;

@property (weak) IBOutlet NSTextField *classNameTextField;
@property (weak) IBOutlet NSTextField *savePathTextField;
@property (unsafe_unretained) IBOutlet NSTextView *jsonStrTextView;
- (IBAction)savePathButAction:(id)sender;
- (IBAction)hTemplateButAction:(id)sender;
@property (weak) IBOutlet NSTextField *hTemplateTexld;
- (IBAction)mTemplateButAction:(id)sender;
@property (weak) IBOutlet NSTextField *mTemplateTextField;

- (IBAction)productButAction:(NSButton *)sender;
- (IBAction)previewButAction:(id)sender;

@end

@implementation WSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.window.title = @"ios模型生成软件";
    
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

- (IBAction)previewButAction:(id)sender {
    
//    NSString *className = self.classNameTextField.stringValue;
//    NSString *savePath = self.savePathTextField.stringValue;
//    NSString *jsonStr = self.jsonStrTextView.string;
    
    [self processHFile:^{
        [self processMFile:^{
            self.previewWC = [[WSPreviewWindowController alloc] initWithWindowNibName:@"WSPreviewWindowController"];
            WSPreviewViewController *previewVC = [[WSPreviewViewController alloc] init];
            self.previewWC.contentViewController = previewVC;
            previewVC.hFilePath = self.HFilePath;
            previewVC.hFileContent = self.HFileContent;
            previewVC.hFileName = self.HFileName;
            previewVC.mFileContent = self.MFileContent;
            previewVC.mFilePath = self.MFilePath;
            previewVC.mFileName = self.MFileName;
            
            [self.previewWC.window orderFront:nil];
            
        }];
    }];
}

- (IBAction)savePathButAction:(id)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
//    [oPanel setDirectory:NSHomeDirectory()]; //起始目录为Home
    if ([oPanel runModal] == NSOKButton) {  //如果用户点OK
        NSURL *saveUrl = [[oPanel URLs] objectAtIndex:0];
        NSString *savePath = [saveUrl relativePath];
        self.savePathTextField.stringValue = savePath;
        //我在console输出这个目录的地址
    }
}

- (IBAction)hTemplateButAction:(id)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:NO]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
//    [oPanel setDirectory:NSHomeDirectory()]; //起始目录为Home
    if ([oPanel runModal] == NSOKButton) {  //如果用户点OK
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        NSString *hTemplatePath = [url relativePath];
        self.hTemplateTexld.stringValue = hTemplatePath;
        //我在console输出这个目录的地址
    }
}

- (IBAction)mTemplateButAction:(id)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:NO]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    if ([oPanel runModal] == NSOKButton) {  //如果用户点OK
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        NSString *mTemplatePath = [url relativePath];
        self.mTemplateTextField.stringValue = mTemplatePath;
        //我在console输出这个目录的地址
    }

}

- (IBAction)productButAction:(NSButton *)sender {
    
    NSString *className = self.classNameTextField.stringValue;
    NSString *savePath = self.savePathTextField.stringValue;
    NSString *jsonStr = self.jsonStrTextView.string;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:savePath forKey:WSFileSavePath];
    [userDefaults setValue:className forKey:WSClassName];
    [userDefaults setValue:jsonStr forKey:WSJsonStr];
    
    self.HFileName = [NSString stringWithFormat:@"%@.h", className];
    self.MFileName = [NSString stringWithFormat:@"%@.m", className];
    
    self.HFilePath = [savePath stringByAppendingPathComponent:self.HFileName];
    self.MFilePath = [savePath stringByAppendingPathComponent:self.MFileName];
    
    
    /*****************生成.h文件*********************/
    
    [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateH" ofType:@"txt" handle:^(NSString *fileContent, NSError *error) {
        if (error) {
            NSLog(@"读取.h模板文件错误:%@", error);
        } else {
            NSMutableString *HTemplate = [NSMutableString stringWithString:fileContent];
            // 替换类名
            NSString *classNameExpress = ClassNameExpress;
            NSRange classNameRange = [HTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
            if (classNameRange.location != NSNotFound) {
                [HTemplate deleteCharactersInRange:classNameRange];
                [HTemplate insertString:className atIndex:classNameRange.location];
                NSLog(@"已经替换完.h类名");
            } else {
                NSLog(@".h模板文件没有发现类名表达式");
            }
            
            // 替换属性
            NSString *propertiesExpress = PropertiesExpress;
            NSRange  propertiesRange = [HTemplate rangeOfString:propertiesExpress options:NSRegularExpressionSearch];
            if (propertiesRange.location != NSNotFound) {
                [self getPropertiesModelFromJsonStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
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
            
            self.HFileContent = [NSString stringWithString:HTemplate];
            // 创建写入.h文件
            BOOL HFileCreate = [WSFileUtil createFileAtFilePath:self.HFilePath contents:[self.HFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            if (HFileCreate) {
                NSLog(@".h写入成功");
            } else {
                NSLog(@".h文件写入失败");
            }
        }
    }];
    
    
    /*****************生成.m文件*********************/
    [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateM" ofType:@"txt" handle:^(NSString *fileContent, NSError *error) {
        if (error) {
            NSLog(@"读取.m模板文件错误:%@", error);
        } else {
            NSMutableString *MTemplate = [NSMutableString stringWithString:fileContent];
            while (YES) {
                // 替换类名
                NSString *classNameExpress = ClassNameExpress;
                NSRange classNameRange = [MTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
                if (classNameRange.location != NSNotFound) {
                    [MTemplate deleteCharactersInRange:classNameRange];
                    [MTemplate insertString:className atIndex:classNameRange.location];
                } else {
                    NSLog(@"已经替换完.m的头文件引入和类名");
                    break;
                }
            }
            // 创建写入.m文件
            self.MFileContent = [NSString stringWithString:MTemplate];
            BOOL MFileCreate = [WSFileUtil createFileAtFilePath:self.MFilePath contents:[self.MFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            if (MFileCreate) {
                NSLog(@".m写入成功");
            } else {
                NSLog(@".m文件写入失败");
            }
            
        }
    }];
}

- (void)processJsonStr:(void(^)(void))handle
{
    [self processHFile:^{
        [self produceHFile];
    }];
    
    [self processMFile:^{
        [self produceMFile];
    }];
}

- (void)produceHFile
{
    // 创建写入.h文件
    BOOL HFileCreate = [WSFileUtil createFileAtFilePath:self.HFilePath contents:[self.HFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (HFileCreate) {
        NSLog(@".h写入成功");
    } else {
        NSLog(@".h文件写入失败");
    }
}

- (void)produceMFile
{
    // 创建写入.m文件
    BOOL MFileCreate = [WSFileUtil createFileAtFilePath:self.MFilePath contents:[self.MFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (MFileCreate) {
        NSLog(@".m写入成功");
    } else {
        NSLog(@".m文件写入失败");
    }

}

- (void)processHFile:(void(^)(void))handle
{
    NSString *className = self.classNameTextField.stringValue;
    NSString *savePath = self.savePathTextField.stringValue;
    NSString *jsonStr = self.jsonStrTextView.string;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:savePath forKey:WSFileSavePath];
    [userDefaults setValue:className forKey:WSClassName];
    [userDefaults setValue:jsonStr forKey:WSJsonStr];
    
    self.HFileName = [NSString stringWithFormat:@"%@.h", className];
    self.HFilePath = [savePath stringByAppendingPathComponent:self.HFileName];
    
    /*****************生成.h文件*********************/
    if (self.hTemplateTexld.stringValue.length > 0) {
        [WSFileUtil getFileContentWithFilePath:self.hTemplateTexld.stringValue handle:^(NSString *fileContent, NSError *error) {
            
        }];
    }
    [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateH" ofType:@"txt" handle:^(NSString *fileContent, NSError *error) {
        if (error) {
            NSLog(@"读取.h模板文件错误:%@", error);
            return;
           
        } else {
            NSMutableString *HTemplate = [NSMutableString stringWithString:fileContent];
            // 替换类名
            NSString *classNameExpress = ClassNameExpress;
            NSRange classNameRange = [HTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
            if (classNameRange.location != NSNotFound) {
                [HTemplate deleteCharactersInRange:classNameRange];
                [HTemplate insertString:className atIndex:classNameRange.location];
                NSLog(@"已经替换完.h类名");
            } else {
                NSLog(@".h模板文件没有发现类名表达式");
                return;
            }
            
            // 替换属性
            NSString *propertiesExpress = PropertiesExpress;
            NSRange  propertiesRange = [HTemplate rangeOfString:propertiesExpress options:NSRegularExpressionSearch];
            if (propertiesRange.location != NSNotFound) {
                [self getPropertiesModelFromJsonStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
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
            
            self.HFileContent = [NSString stringWithString:HTemplate];
            if (handle) {
                handle();
            }
        }
    }];
}

- (void)proceHFileContent:(NSString *)fileContent
{
    
}

- (void)processMFile:(void(^)(void))handle
{
    
    NSString *className = self.classNameTextField.stringValue;
    NSString *savePath = self.savePathTextField.stringValue;
    NSString *jsonStr = self.jsonStrTextView.string;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:savePath forKey:WSFileSavePath];
    [userDefaults setValue:className forKey:WSClassName];
    [userDefaults setValue:jsonStr forKey:WSJsonStr];
    
    self.MFileName = [NSString stringWithFormat:@"%@.m", className];
    self.MFilePath = [savePath stringByAppendingPathComponent:self.MFileName];
    
    /*****************生成.m文件*********************/
    [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateM" ofType:@"txt" handle:^(NSString *fileContent, NSError *error) {
        if (error) {
            NSLog(@"读取.m模板文件错误:%@", error);
        } else {
            NSMutableString *MTemplate = [NSMutableString stringWithString:fileContent];
            while (YES) {
                // 替换类名
                NSString *classNameExpress = ClassNameExpress;
                NSRange classNameRange = [MTemplate rangeOfString:classNameExpress options:NSRegularExpressionSearch];
                if (classNameRange.location != NSNotFound) {
                    [MTemplate deleteCharactersInRange:classNameRange];
                    [MTemplate insertString:className atIndex:classNameRange.location];
                } else {
                    NSLog(@"已经替换完.m的头文件引入和类名");
                    break;
                }
            }
            // 替换MTLJSONSerializing协议属性字符串
            NSString *JSONSerializingEXpress =  MTLJSONSerializingExpress;
            NSRange jsonSerializingRange = [MTemplate rangeOfString:JSONSerializingEXpress options:NSRegularExpressionSearch];
            if (jsonSerializingRange.location != NSNotFound) {
                [self getPropertiesModelFromJsonStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
                    if (!error) {
                        NSMutableString *JSONSerializingEXpressStr = [NSMutableString string];
                        NSString *propertyConvertValueStr = [MTLJsonUtil getMTLJSONSerializingPropertiesStrFromModelArray:modelArray];
                        NSString *propertyValueTransformStr = [MTLJsonUtil getMTLJSONSerializingPropertiesValueTransformerStrFromModelArray:modelArray];
                        [JSONSerializingEXpressStr appendFormat:@"%@ \n", propertyConvertValueStr];
                        [JSONSerializingEXpressStr appendFormat:@"%@ \n", propertyValueTransformStr];
                        [MTemplate deleteCharactersInRange:jsonSerializingRange];
                        [MTemplate insertString:JSONSerializingEXpressStr atIndex:jsonSerializingRange.location];
                    }
                }];
            }

            // 替换MTLManagedObjectSerializing协议属性字符串
            NSString *MTLManagedObjectSerializingEXpress =  MTLManagedObjectSerializingExpress;
            NSRange managedObjectSerializingRange = [MTemplate rangeOfString:MTLManagedObjectSerializingEXpress options:NSRegularExpressionSearch];
            if (managedObjectSerializingRange.location != NSNotFound) {
                [self getPropertiesModelFromJsonStr:jsonStr handle:^(NSArray<WSPropertyModel *> *modelArray, NSError *error) {
                    if (!error) {
                        NSMutableString *managedObjectSerializingStr = [NSMutableString string];
                        NSString *managedObjectSerializing = [MTLJsonUtil getMTLManagedObjectSerializingStrFromModelArray:modelArray entityName:className];
                        [managedObjectSerializingStr appendFormat:@"%@ \n", managedObjectSerializing];
                        [MTemplate deleteCharactersInRange:managedObjectSerializingRange];
                        [MTemplate insertString:managedObjectSerializingStr atIndex:managedObjectSerializingRange.location];
                    }
                }];
            }

            
            // 创建写入.m文件
            self.MFileContent = [NSString stringWithString:MTemplate];
            if (handle) {
                handle();
            }
        }
    }];

}

#pragma mark - json字符转转换成属性模型数组
- (void)getPropertiesModelFromJsonStr:(NSString *)jsonStr handle:(void (^)(NSArray<WSPropertyModel *> *modelArray, NSError *error))handle
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
                    NSString *propertyType = [MTLJsonUtil getPropertyTypeNameWithValue:value];
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

#pragma mark 属性模型数组拼接成字符串
- (NSString *)getPropertiesStrFromModelArray:(NSArray<WSPropertyModel *> *)modelArray
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

- (NSString *)converPropertyName:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"id"]) {
        return @"_id";
    } else {
        return propertyName;
    }
}

@end
