//
//  FCCalendarManager.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "FCCalendarManager.h"
#import "FCChineseCalendarManager.h"

@interface FCCalendarManager ()

@property (nonatomic,strong)NSDate *todayDate;
@property (nonatomic,strong)NSDateComponents *todayCompontents;
@property (nonatomic,strong)NSCalendar *greCalendar; // 获取阳历(公历)
@property (nonatomic,strong)NSDateFormatter *dateFormatter;
@property (nonatomic,strong)FCChineseCalendarManager *chineseCalendarManager;
@property (nonatomic,assign)BOOL showChineseHoliday; // 是否展示农历节日
@property (nonatomic,assign)BOOL showChineseCalendar;// 是否展示农历

@end

@implementation FCCalendarManager

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar {
    
    self = [super init];
    if (self) {
        _greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _todayDate = [self worldDateToLocalDate:[NSDate date]];
        _todayCompontents = [self dateToComponents:_todayDate];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"YYYY-MM-dd";
        _chineseCalendarManager = [[FCChineseCalendarManager alloc] init];
        _showChineseCalendar = showChineseCalendar;
        _showChineseHoliday = showChineseHoliday;
    }
    return self;
}

#pragma mark - 世界时间转换为本地时间
- (NSDate *)worldDateToLocalDate:(NSDate *)date {
    
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [date dateByAddingTimeInterval:offset];
    
    return localDate;
}

#pragma mark - 得到每一天的数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date {
    
    // 如果日期为空直接返回
    if (!date) return nil;
    
    date = [self worldDateToLocalDate:date];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    NSLog(@"本月总共有%zd天", tatalDay);
    NSLog(@"本月第一天是星期%zd", firstDay-1); // 注:日历里面1-7分别对应周日-周六
    
    NSDateComponents *components = [self dateToComponents:date];
    
    // 计算总共有多少个格子(cell),包括空出来的星期,比如当前月是从星期三开始的,则前面的星期日,星期一,星期二空出来
    NSInteger tempDay = tatalDay + (firstDay - 1);
    NSInteger column = 0;
    // 判断日历有多少行,按照每行7列来计算需要多少行
    if(tempDay % 7 == 0) {
        column = tempDay / 7;
    } else {
        column = tempDay / 7 + 1;
    }
    
    NSInteger i = 0;
    NSInteger j = 0;
    components.day = 0;
    
    for (i = 0; i < column; i++) { // 行
        for (j = 0; j < 7; j++) {  // 列
            if (i == 0 && j < firstDay - 1) { // 第一行,空白cell的个数
                FCCalendarModel *calendarItem = [[FCCalendarModel alloc] init];
                calendarItem.year = 0;
                calendarItem.month = 0;
                calendarItem.day = 0;
                calendarItem.chineseCalendar = @"";
                calendarItem.holiday = @"";
                calendarItem.week = -1;
                calendarItem.dateInterval = -1;
                calendarItem.selectCell = NO;
                [resultArray addObject:calendarItem];
                continue;
            }
            // 空白cell对应的模型添加完以后,再添加每一天的具体的模型数据
            components.day += 1;
            // 当添加完当月所有的天数后结束外层循环
            if (components.day == tatalDay + 1) {
                i = column;
                break;
            }
            FCCalendarModel *calendarItem = [[FCCalendarModel alloc] init];
            calendarItem.year = components.year;
            calendarItem.month = components.month;
            calendarItem.day = components.day;
            calendarItem.week = j;
            calendarItem.selectCell = NO;
            if (calendarItem.day / 12) {  // 是否能弹窗
                calendarItem.canPop = YES;
            }
            NSDate *date = [self componentsToDate:components];
            // 时间戳
            calendarItem.dateInterval = [self dateToInterval:date];
            // 设置农历以及节假日
            [self setChineseCalendarAndHolidayWithDate:components date:date calendarItem:calendarItem];
            [resultArray addObject:calendarItem];
        }
    }
    return resultArray;
}

#pragma mark - 一个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth:(NSDate *)date {
    return [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

#pragma mark - 确定这个月的第一天是星期几
- (NSUInteger)startDayOfWeek:(NSDate *)date {
    NSDate *startDate = nil;
    BOOL result = [_greCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:date];
    if(result)
    {
        return [_greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate];
    }
    return 0;
}

#pragma mark - 日期转时间戳
- (NSInteger)dateToInterval:(NSDate *)date {
    return (long)[date timeIntervalSince1970];
}

#pragma mark - 农历和节假日
- (void)setChineseCalendarAndHolidayWithDate:(NSDateComponents *)components date:(NSDate *)date calendarItem:(FCCalendarModel *)calendarItem {
    
    if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day) {
        
        calendarItem.type = FCCalendarTodayType;
        calendarItem.holiday = @"今天";
        calendarItem.selectCell = YES;
        
    } else {
        
        if([date compare:_todayDate] == 1) {
            calendarItem.type = FCCalendarNextType;
        } else {
            calendarItem.type = FCCalendarLastType;
        }
    }
//        if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day - 1)
//        {
//            calendarItem.holiday = @"昨天";
//        }
//        else if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day + 1)
//        {
//            calendarItem.holiday = @"明天";
//        }
    
    if(components.month == 1 && components.day == 1)
    {
        calendarItem.holiday = @"元旦";
    }
    else if(components.month == 2 && components.day == 14)
    {
        calendarItem.holiday = @"情人节";
    }
    else if(components.month == 3 && components.day == 8)
    {
        calendarItem.holiday = @"妇女节";
    }
    else if(components.month == 4 && components.day == 1)
    {
        calendarItem.holiday = @"愚人节";
    }
    else if(components.month == 4 && (components.day == 4 || components.day == 5 || components.day == 6))
    {
        if([_chineseCalendarManager isQingMingholidayWithYear:components.year month:components.month day:components.day])
        {
            calendarItem.holiday = @"清明节";
        }
    }
    else if(components.month == 5 && components.day == 1)
    {
        calendarItem.holiday = @"劳动节";
    }
    else if(components.month == 5 && components.day == 4)
    {
        calendarItem.holiday = @"青年节";
    }
    else if(components.month == 6 && components.day == 1)
    {
        calendarItem.holiday = @"儿童节";
    }
    else if(components.month == 8 && components.day == 1)
    {
        calendarItem.holiday = @"建军节";
    }
    else if(components.month == 9 && components.day == 10)
    {
        calendarItem.holiday = @"教师节";
    }
    else if(components.month == 10 && components.day == 1)
    {
        calendarItem.holiday = @"国庆节";
    }
    else if(components.month == 1 && components.day == 1)
    {
        calendarItem.holiday = @"元旦";
    }
    else if(components.month == 11 && components.day == 11)
    {
        calendarItem.holiday = @"光棍节";
    }
    else if(components.month == 12 && components.day == 25)
    {
        calendarItem.holiday = @"圣诞节";
    }
    // 计算农历耗性能
    if(_showChineseCalendar || _showChineseHoliday)
    {
        [_chineseCalendarManager getChineseCalendarWithDate:date calendarItem:calendarItem];
    }
}

#pragma mark - NSDate和NSCompontents转换
- (NSDateComponents *)dateToComponents:(NSDate *)date {
    // NSEraCalendarUnit代表一个世纪
    NSDateComponents *components = [_greCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    return components;
}

- (NSDate *)componentsToDate:(NSDateComponents *)components {
    // 不区分时分秒
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [_greCalendar dateFromComponents:components];
    return date;
}

@end
