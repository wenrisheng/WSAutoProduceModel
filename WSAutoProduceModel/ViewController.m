//
//  ViewController.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+WSClass.h"
#import "WSPreviewWindowController.h"
#import "WSPreviewViewController.h"

#define WSFileSavePath    @"WSFileSavePath"
#define WSClassName       @"WSClassName"
#define WSJsonStr         @"WSJsonStr"

#define ClassNameExpress  @"#className#"
#define PropertiesExpress @"#properties#"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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

            // 创建写入.h文件
            BOOL HFileCreate = [WSFileUtil createFileAtFilePath:HFilePath contents:[HTemplate dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
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
            // 创建写入.h文件
            BOOL MFileCreate = [WSFileUtil createFileAtFilePath:MFilePath contents:[MTemplate dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            if (MFileCreate) {
                NSLog(@".m写入成功");
            } else {
                NSLog(@".m文件写入失败");
            }

        }
    }];
}

- (IBAction)previewButAction:(id)sender {
//    WSPreviewViewController *previewVC = [[WSPreviewViewController alloc] init];
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    WSPreviewWindowController *previewWC = [storyboard instantiateControllerWithIdentifier:@"WSPreviewWindowController"];
//    previewWindow.contentView = previewVC.view;
    NSWindow *suberWindow = previewWC.window;
    NSWindow *superWindow = self.view.window;
    [previewWC.window makeKeyWindow];
[previewWC.window beginSheet:self.view.window completionHandler:^(NSModalResponse returnCode) {
    NSLog(@"resp:%d", returnCode);
}];
    
//    [previewWindow makeKeyAndOrderFront:nil];
//    [previewWC.window makeKeyAndOrderFront:nil];
   
//    [self.view.window beginSheet:previewWC.window completionHandler:^(NSModalResponse returnCode) {
//        
//    }];
//     [NSApp runModalForWindow:previewWC.window];
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
                    NSString *propertyType = [self getPropertyTypeWithValue:value];
                    WSPropertyModel *model = [[WSPropertyModel alloc] init];
                    model.name = propertyName;
                    model.type = propertyType;
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
        NSString *propertyType = model.type;
        NSString *propertyExpress = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;", propertyType, propertyName];
        [result appendString:propertyExpress];
        if (i != count - 1) {
            [result appendString:@"\n"];
        }
    }
    return result;
}

#pragma mark 获取属性值的类型
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
