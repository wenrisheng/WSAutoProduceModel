//
//  ViewController.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *classNameTextField;
@property (weak) IBOutlet NSTextField *savePathTextField;

@property (unsafe_unretained) IBOutlet NSTextView *jsonStrTextView;

- (IBAction)productButAction:(NSButton *)sender;

@end

