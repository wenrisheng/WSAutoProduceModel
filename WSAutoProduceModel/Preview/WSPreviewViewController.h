//
//  WSPreviewViewController.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WSPreviewViewController : NSViewController

@property (strong, nonatomic) NSString *hFilePath;
@property (strong, nonatomic) NSString *hFileName;
@property (strong, nonatomic) NSString *hFileContent;

@property (strong, nonatomic) NSString *mFilePath;
@property (strong, nonatomic) NSString *mFileName;
@property (strong, nonatomic) NSString *mFileContent;

@end
