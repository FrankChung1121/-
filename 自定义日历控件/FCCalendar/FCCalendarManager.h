//
//  FCCalendarManager.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCCalendarManager : NSObject

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar;
// 获取数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date;

@end
