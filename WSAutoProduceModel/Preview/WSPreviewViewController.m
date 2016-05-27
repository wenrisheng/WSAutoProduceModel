//
//  WSPreviewViewController.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "WSPreviewViewController.h"

@interface WSPreviewViewController ()

@property (weak) IBOutlet NSTextField *hLabel;
@property (unsafe_unretained) IBOutlet NSTextView *hTextView;
@property (weak) IBOutlet NSTextField *mLabel;
@property (unsafe_unretained) IBOutlet NSTextView *mTextView;
- (IBAction)productButAction:(id)sender;
@end

@implementation WSPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _hLabel.stringValue = _hFileName;
    _hTextView.string = _hFileContent;
    _mLabel.stringValue = _mFileName;
    _mTextView.string = _mFileContent;
}

- (IBAction)productButAction:(id)sender {
    // 创建写入.h文件
    BOOL HFileCreate = [WSFileUtil createFileAtFilePath:self.hFilePath contents:[self.hFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (HFileCreate) {
        NSLog(@".h写入成功");
    } else {
        NSLog(@".h文件写入失败");
    }
    
    // 创建写入.m文件
    BOOL MFileCreate = [WSFileUtil createFileAtFilePath:self.mFilePath contents:[self.mFileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (MFileCreate) {
        NSLog(@".m写入成功");
    } else {
        NSLog(@".m文件写入失败");
    }


}
@end
