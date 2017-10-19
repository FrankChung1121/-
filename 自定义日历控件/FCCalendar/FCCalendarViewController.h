//
//  FCCalendarViewController.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCCalendarViewController : UIViewController

/** 是否展示农历节日 */
@property (nonatomic,assign)BOOL showChineseHoliday;
/** 是否展示农历 */
@property (nonatomic,assign)BOOL showChineseCalendar;
/** 节假日是否宣示不同的颜色 */
@property (nonatomic,assign)BOOL showHolidayDifferentColor;
/** 选中的日期 */
@property (nonatomic, copy) void(^selectDateCallback)(NSString *);

@end
