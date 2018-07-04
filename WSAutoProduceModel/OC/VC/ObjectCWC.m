//
//  WSHomeWindowController.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "ObjectCWC.h"
#import "ObjectCVC.h"

@interface ObjectCWC ()

@end

@implementation ObjectCWC

+ (instancetype)show
{
    ObjectCWC *WC = [[ObjectCWC alloc] initWithWindowNibName:@"ObjectCWC"];
    ObjectCVC *VC = [[ObjectCVC alloc] init];
    [WC.window center];
    WC.contentViewController = VC;
    [WC.window center];
    [WC.window orderFront:nil];
    [WC showWindow:nil];
    return WC;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
