//
//  AppDelegate.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSMenu *mainMenu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSApplication *application = [NSApplication sharedApplication];
    NSWindow *mainWindow = application.mainWindow;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
