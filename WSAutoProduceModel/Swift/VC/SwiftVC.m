//
//  SwiftVC.m
//  WSAutoProduceModel
//
//  Created by wrs on 2018/6/28.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import "SwiftVC.h"
#import "ObjectCWC.h"

@interface SwiftVC ()

@property (weak) IBOutlet NSTextField *classNameTxtField;
@property (weak) IBOutlet NSTextField *savePathTxtField;
@property (unsafe_unretained) IBOutlet NSTextView *jsonTxtView;

- (IBAction)savePathBtnAction:(id)sender;
- (IBAction)OCBtnAction:(id)sender;
- (IBAction)produceBtnAction:(id)sender;
- (IBAction)previewBtnAction:(id)sender;

@end

@implementation SwiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark -
- (IBAction)savePathBtnAction:(id)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
    //    [oPanel setDirectory:NSHomeDirectory()]; //起始目录为Home
    if ([oPanel runModal] == NSModalResponseOK) {  //如果用户点OK
        NSURL *saveUrl = [[oPanel URLs] objectAtIndex:0];
        NSString *savePath = [saveUrl relativePath];
        self.savePathTxtField.stringValue = savePath;
        //我在console输出这个目录的地址
    }
}

- (IBAction)OCBtnAction:(id)sender {

    [ObjectCWC show];
}

- (IBAction)produceBtnAction:(id)sender {
    
}

- (IBAction)previewBtnAction:(id)sender {
}
@end
