//
//  AppDelegate.m
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/26.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectCWC.h"

@interface AppDelegate ()

//@property (weak) IBOutlet NSMenu *mainMenu;
//
//- (IBAction)newMentItemAction:(id)sender;
@property (nonatomic, strong) NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    ObjectCWC *wc = [ObjectCWC show];
    self.window = wc.window;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//- (IBAction)newMentItemAction:(id)sender {
//    
//}

@end
