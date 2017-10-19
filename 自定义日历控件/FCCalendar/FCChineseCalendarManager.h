//
//  FCChineseCalendarManager.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCCalendarModel.h"

@interface FCChineseCalendarManager : NSObject

- (void)getChineseCalendarWithDate:(NSDate *)date calendarItem:(FCCalendarModel *)calendarItem;

- (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
