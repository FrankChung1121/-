//
//  FCCalendarDefine.h
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#define FC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define FC_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define FC_UTILS_COLORRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define FC_Iphone6Scale(x) ((x) * FC_SCREEN_WIDTH / 375.0f)
#define FC_ONE_PIXEL (1.0f / [[UIScreen mainScreen] scale])

// cell被选中时的背景颜色
#define FC_CellBgColor [UIColor greenColor]
// DateLabel默认文字颜色
#define FC_TextColor [UIColor blackColor]
// DateLabel选中时的背景色
#define FC_SelectBackgroundColor FC_UTILS_COLORRGB(29, 154, 72)
// DateLabel选中后文字颜色
#define FC_SelectTextColor [UIColor whiteColor]
// SubLabel文字颜色
#define FC_SelectSubLabelTextColor FC_UTILS_COLORRGB(29, 154, 180);
// 节日颜色
#define FC_HolidayTextColor [UIColor purpleColor]
// 周末颜色
#define FC_WeekEndTextColor [UIColor redColor]
// 周视图高度
#define FC_WeekViewHeight 40
// headerView背景颜色
#define FC_HeaderViewColor FC_UTILS_COLORRGB(248, 248, 248)
// headerView文字颜色
#define FC_HeaderViewTextColor [UIColor blackColor]
// headerView高度
#define FC_HeaderViewHeight 44
// cell下划线颜色
#define FC_LineColor [UIColor purpleColor]
// 遮盖view的背景颜色
#define FC_coverViewBgColor FC_UTILS_COLORRGB(0, 0, 0)
// 弹框popView的背景颜色
#define FC_popViewBgColor FC_UTILS_COLORRGB(255, 255, 255)
// popView上部分背景颜色
#define FC_popViewUpBgColor FC_UTILS_COLORRGB(220, 244, 255)
// popView中间部分背景颜色
#define FC_popViewMiddleBgColor FC_UTILS_COLORRGB(255, 255, 255)
// popView下面部分背景颜色
#define FC_popViewDownBgColor FC_UTILS_COLORRGB(220, 244, 255)



