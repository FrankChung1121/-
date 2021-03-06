//
//  FCChineseCalendarManager.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "FCChineseCalendarManager.h"

@interface FCChineseCalendarManager ()

@property (nonatomic,strong)NSCalendar *chineseCalendar;
@property (nonatomic,strong)NSArray *chineseYearArray;
@property (nonatomic,strong)NSArray *chineseMonthArray;
@property (nonatomic,strong)NSArray *chineseDayArray;

@end

@implementation FCChineseCalendarManager

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _chineseCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _chineseMonthArray = [NSArray arrayWithObjects:
                              @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                              @"九月", @"十月", @"冬月", @"腊月", nil];
        _chineseDayArray = [NSArray arrayWithObjects:
                            @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                            @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                            @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return self;
}

- (void)getChineseCalendarWithDate:(NSDate *)date calendarItem:(FCCalendarModel *)calendarItem {
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [_chineseCalendar components:unitFlags fromDate:date];
    NSInteger tempDay = localeComp.day;
    // 系统日历类在2057-09-28计算有bug结果为0（应该为30）
    if(tempDay == 0)
    {
        tempDay = 30;
    }
    
    NSString *chineseMonth = [_chineseMonthArray objectAtIndex:localeComp.month - 1];
    NSString *chineseDay = [_chineseDayArray objectAtIndex:tempDay - 1];
    
    calendarItem.chineseCalendar = chineseDay;
    
    if([@"正月" isEqualToString:chineseMonth] &&
       [@"初一" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"春节";
    }
    else if([@"正月" isEqualToString:chineseMonth] &&
            [@"十五" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"元宵节";
    }
    else if([@"二月" isEqualToString:chineseMonth] &&
            [@"初二" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"龙抬头";
    }
    else if([@"五月" isEqualToString:chineseMonth] &&
            [@"初五" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"端午节";
    }
    else if([@"七月" isEqualToString:chineseMonth] &&
            [@"初七" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"七夕";
    }
    else if([@"八月" isEqualToString:chineseMonth] &&
            [@"十五" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"中秋节";
        //        calendarItem.chineseCalendar = @"中秋节";
    }
    else if([@"九月" isEqualToString:chineseMonth] &&
            [@"初九" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"重阳节";
    }
    else if([@"腊月" isEqualToString:chineseMonth] &&
            [@"初八" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"腊八";
    }
    else if([@"腊月" isEqualToString:chineseMonth] &&
            [@"二四" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"小年";
    }
    else if([@"腊月" isEqualToString:chineseMonth] &&
            [@"三十" isEqualToString:chineseDay])
    {
        calendarItem.holiday = @"除夕";
    }
}

/*
 清明节日期的计算 [Y*D+C]-L
 公式解读：Y=年数后2位，D=0.2422，L=闰年数，21世纪C=4.81，20世纪=5.59。
 */
- (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    if(month == 4) {
        NSInteger pre = year / 100;
        float c = 4.81;
        if(pre == 19) {
            c = 5.59;
        }
        NSInteger y = year % 100;
        NSInteger qingMingDay = (y * 0.2422 + c) - y / 4;
        if(day == qingMingDay) {
            return YES;
        }
    }
    return NO;
}

@end
