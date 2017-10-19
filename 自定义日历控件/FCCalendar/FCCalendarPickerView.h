//
//  FCCalendarPickerView.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCCalendarPickerView : UIView

- (void)show;
- (void)hide;

/** 将修改后的时间数据回调 */
@property (nonatomic, strong) void (^selectDate)(NSDate *);

@end
