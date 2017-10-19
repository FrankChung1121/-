//
//  FCCoverView.m
//  PopViewDemo
//
//  Created by FrankChung on 16/12/1.
//  Copyright © 2016年 VMC. All rights reserved.
//

#import "FCCoverView.h"

@implementation FCCoverView

- (void)show:(FCCoverView *)coverView
{
    coverView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.2f;
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
}

- (void)hide
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[FCCoverView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

@end
