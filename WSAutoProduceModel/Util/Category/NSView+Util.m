//
//  NSView+Util.m
//  WSXcodePlugin
//
//  Created by wenrisheng on 17/4/14.
//  Copyright © 2017年 wrs. All rights reserved.
//

#import "NSView+Util.h"

@implementation NSView (Util)

- (void)expandToSuperView
{
    if (!self.superview) {
        return;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSView *superView = self.superview;
    NSView *view = self;
    NSDictionary *dic = NSDictionaryOfVariableBindings(view);
    NSArray *hcon=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:dic];
    NSArray *vcon=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:dic];
    [superView addConstraints:hcon];
    [superView addConstraints:vcon];
    
}

- (void)constrainSubViewsAverage:(NSArray *)subViews rows:(int)rows cols:(int)cols
{
    CGFloat rowNum = rows;
    CGFloat colNum = cols;
    
    NSInteger count = subViews.count;
    CGFloat widthMultiplier = 1 / colNum;
    CGFloat heithMultiplier = 1 / rowNum;
    for (int i = 0; i < count; i++) {
        int row = i / cols;
        int col = i % cols;
        NSView *view = [subViews objectAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:0.0];
        NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:heithMultiplier constant:0.0];
        NSLayoutConstraint *leftCon ;
        if (col == 0) {
            leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        } else {
            leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:col * widthMultiplier constant:0.0];
        }
        NSLayoutConstraint *topCon;
        if (row == 0) {
            topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        } else {
            topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:row * heithMultiplier constant:0.0];
        }
        [self addSubview:view];
        [self addConstraints:@[widthCon, heightCon, leftCon, topCon]];
    }
}

@end
