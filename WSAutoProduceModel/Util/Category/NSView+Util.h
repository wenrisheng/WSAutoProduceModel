//
//  NSView+Util.h
//  WSXcodePlugin
//
//  Created by wenrisheng on 17/4/14.
//  Copyright © 2017年 wrs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Util)

- (void)expandToSuperView;
// 将subviews布局成rows行cols列
- (void)constrainSubViewsAverage:(NSArray *)subViews rows:(int)rows cols:(int)cols;

@end
