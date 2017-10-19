//
//  FCCalendarViewCell.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "FCCalendarViewCell.h"
#import "FCCalendarDefine.h"

@implementation FCCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    {
        [self createCell];
    }
    return self;
}

- (void)createCell {

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 24)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:_dateLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateLabel.frame), self.contentView.frame.size.width, 24)];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_subLabel];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 12)/2, CGRectGetMaxY(_subLabel.frame), 12, 12)];
    [self.contentView addSubview:_imageView];
}

@end
