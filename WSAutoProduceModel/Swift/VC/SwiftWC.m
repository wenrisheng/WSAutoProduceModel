//
//  SwiftWC.m
//  WSAutoProduceModel
//
//  Created by wrs on 2018/6/28.
//  Copyright © 2018年 wenrisheng. All rights reserved.
//

#import "SwiftWC.h"
#import "SwiftVC.h"

@interface SwiftWC ()

@end

@implementation SwiftWC

+ (void)show
{
    SwiftWC *swiftWC = [[SwiftWC alloc] initWithWindowNibName:@"SwiftWC"];
    SwiftVC *swiftVC = [[SwiftVC alloc] init];
    swiftWC.contentViewController = swiftVC;
    [swiftWC.window center];
    [swiftWC.window orderFront:nil];
    [swiftWC showWindow:nil];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
