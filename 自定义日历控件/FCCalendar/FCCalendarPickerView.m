//
//  FCCalendarPickerView.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/17.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "FCCalendarPickerView.h"
#import "FCCoverView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FCCalendarPickerView ()

@property (nonatomic, strong) FCCoverView *coverView;
@property (nonatomic, weak) UIDatePicker *pickerView;

@end

@implementation FCCalendarPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:150.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:cancelBtn];
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderWidth = 0.5;
        cancelBtn.layer.borderColor = cancelBtn.titleLabel.textColor.CGColor;
        cancelBtn.frame = CGRectMake(15, 15, 60, 30);
        
        // 完成按钮
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [completeBtn setTitle:@"确定" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(pickerViewCompleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [completeBtn setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:150.0/255.0 blue:252.0/255.0 alpha:1]];
        [self addSubview:completeBtn];
        completeBtn.layer.cornerRadius = 5;
        completeBtn.layer.masksToBounds = YES;
        completeBtn.layer.borderWidth = 0.5;
        completeBtn.layer.borderColor = completeBtn.backgroundColor.CGColor;
        completeBtn.frame = CGRectMake(self.frame.size.width - 75, 15, 60, 30);
        
        // pickerView
        UIDatePicker *pickerView = [[UIDatePicker alloc] init];
        self.pickerView = pickerView;
        // 设置所在区域日期
        pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        // 设置日期模式(月，日，年)
        pickerView.datePickerMode = UIDatePickerModeDate;
        [self addSubview:pickerView];
        pickerView.frame = CGRectMake(0, CGRectGetMaxY(completeBtn.frame), self.frame.size.width, 216);
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, frame.size.height);
        FCCoverView *coverView = [[FCCoverView alloc] init];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnDidClick)]];
        self.coverView = coverView;
        [coverView show:coverView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)closeBtnDidClick {
    [self hide];
}

- (void)pickerViewCompleteBtnDidClick {
    
    // 格式化日期
//    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *startDate = [dateformatter stringFromDate:_pickerView.date];
    
    // 将选中的会议时间传递出去
    if (self.selectDate) {
        self.selectDate(_pickerView.date);
    }
    [self hide];
}

- (void)show {
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = SCREEN_HEIGHT - rect.size.height;
        self.frame = rect;
    }];
}

- (void)hide {
    
    if (!self) return;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.coverView hide];
    }];
}

@end
