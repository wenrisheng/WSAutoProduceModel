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
#import "JsonFormatBiz.h"

#define WSFileSavePath                      @"WSFileSavePath"
#define WSClassName                         @"WSClassName"
#define WSJsonStr                           @"WSJsonStr"

#define ClassNameExpress                    @"#className#"
#define PropertiesExpress                   @"#properties#"
#define MTLJSONSerializingExpress           @"#MTLJSONSerializing#"
#define MTLManagedObjectSerializingExpress  @"#MTLManagedObjectSerializing#"

@interface WSHomeViewController ()

@property (strong, nonatomic) NSMutableArray *allWindowArray;
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
@property (weak) IBOutlet NSTextField *hTemplateTexld;
@property (weak) IBOutlet NSTextField *mTemplateTextField;

- (IBAction)productButAction:(NSButton *)sender;
- (IBAction)previewButAction:(id)sender;
- (IBAction)savePathButAction:(id)sender;
- (IBAction)hTemplateButAction:(id)sender;
- (IBAction)mTemplateButAction:(id)sender;

@end

@implementation WSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.allWindowArray = [NSMutableArray array];
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

#pragma mark - 预览按钮事件
- (IBAction)previewButAction:(id)sender {

    NSString *className = self.classNameTextField.stringValue;
    NSString *savePath = self.savePathTextField.stringValue;
    NSString *jsonStr = self.jsonStrTextView.string;
    NSString *hTempleContent = [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateH" ofType:@"txt"];
    NSString *mTempleContent = [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateM" ofType:@"txt"];
    [JsonFormatBiz processJsonObjWithObj:jsonStr key:className hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:ClassNameExpress propertiesExpress:PropertiesExpress JSONSerializingEXpress:MTLJSONSerializingExpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingExpress callBack:^(NSString *hFileContent, NSString *mFileContent, NSString *key) {
        NSString *HFileName = [NSString stringWithFormat:@"%@.h", key];
        NSString *MFileName = [NSString stringWithFormat:@"%@.m", key];
        HFileName = [HFileName capitalizedString];
        MFileName = [MFileName capitalizedString];
        
        NSString *HFilePath = [savePath stringByAppendingPathComponent:HFileName];
        NSString *MFilePath = [savePath stringByAppendingPathComponent:MFileName];
        WSPreviewWindowController *previewWC = [[WSPreviewWindowController alloc] initWithWindowNibName:@"WSPreviewWindowController"];
        WSPreviewViewController *previewVC = [[WSPreviewViewController alloc] init];
        previewWC.contentViewController = previewVC;
        previewVC.hFilePath = HFilePath;
        previewVC.hFileContent = hFileContent;
        previewVC.hFileName = HFileName;
        previewVC.mFileContent = mFileContent;
        previewVC.mFilePath = MFilePath;
        previewVC.mFileName = MFileName;
        previewWC.window.title = [key capitalizedString];
        [previewWC.window orderFront:nil];
        
        [self.allWindowArray removeAllObjects];
        [self.allWindowArray addObject:previewWC];

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
    
    NSString *hTempleContent = [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateH" ofType:@"txt"];
    NSString *mTempleContent = [WSFileUtil getFileContentInBundleWithResource:@"WSNormalTemplateM" ofType:@"txt"];
    [JsonFormatBiz processJsonObjWithObj:jsonStr key:className hTempleContent:hTempleContent mTempleContent:mTempleContent classNameExpress:ClassNameExpress propertiesExpress:PropertiesExpress JSONSerializingEXpress:MTLJSONSerializingExpress MTLManagedObjectSerializingEXpress:MTLManagedObjectSerializingExpress callBack:^(NSString *hFileContent, NSString *mFileContent, NSString *key) {
        NSString *HFileName = [NSString stringWithFormat:@"%@.h", key];
        NSString *MFileName = [NSString stringWithFormat:@"%@.m", key];
        HFileName = [HFileName capitalizedString];
        MFileName = [MFileName capitalizedString];
        
        NSString *HFilePath = [savePath stringByAppendingPathComponent:HFileName];
        NSString *MFilePath = [savePath stringByAppendingPathComponent:MFileName];
        // 创建写入.h文件
        BOOL HFileCreate = [WSFileUtil createFileAtFilePath:HFilePath contents:[hFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (HFileCreate) {
            NSLog(@".h写入成功");
        } else {
            NSLog(@".h文件写入失败");
        }
        BOOL MFileCreate = [WSFileUtil createFileAtFilePath:MFilePath contents:[mFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (MFileCreate) {
            NSLog(@".m写入成功");
        } else {
            NSLog(@".m文件写入失败");
        }
    }];

}

@end
