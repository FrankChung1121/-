//
//  FCCalendarModel.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FCCalendarType)
{
    FCCalendarTodayType = 0, // 今天
    FCCalendarLastType,      // 昨天
    FCCalendarNextType       // 明天
};

@interface FCCalendarModel : NSObject

/** 年 */
@property (nonatomic,assign)NSInteger year;
/** 月 */
@property (nonatomic,assign)NSInteger month;
/** 日 */
@property (nonatomic,assign)NSInteger day;
/** 农历 */
@property (nonatomic,copy)NSString *chineseCalendar;
/** 节假日 */
@property (nonatomic,copy)NSString *holiday;
/** 类型 */
@property (nonatomic,assign)FCCalendarType type;
/** 当前选中日期的时间戳 */
@property (nonatomic,assign)NSInteger dateInterval;
/** 星期 */
@property (nonatomic,assign)NSInteger week;
/** cell是否被选中 */
@property (nonatomic, assign, getter=isSelectCell)BOOL selectCell;
/** cell点击后是否有弹框 */
@property (nonatomic, assign, getter=isCanPop)BOOL canPop;

@end
