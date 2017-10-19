//
//  FCCalendarViewController.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "FCCalendarViewController.h"
#import "FCCalendarViewCell.h"
#import "FCCalendarDefine.h"
#import "FCCalendarManager.h"
#import "FCCalendarModel.h"
#import "FCCalendarPickerView.h"

@interface FCCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIView *_headerView;
    UIButton *_titleBtn;
    UIView *_weekView;
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    NSString *_selectDateStr;
    NSUInteger _selectWeek;
    
    // 弹框相关控件
    UIView *_popView;
    UIButton *_coverView;
    
    // 上部分
    UIView *_upView;
    UIButton *_closeBtn;
    UILabel *_yearMonthL;
    UILabel *_dayL;
    UILabel *_weekTimeL;
    
    // 中间部分
    UIView *_middleView;
    UILabel *_meetingTitle;
    UILabel *_meetingNum;
    UILabel *_meetingTheme;
    UILabel *_meetingContent;
    UILabel *_repeatL;
    UILabel *_repeatContent;
    UILabel *_meetingPwdL;
    UILabel *_meetingPwd;
    UILabel *_managePwdL;
    UILabel *_managePwd;
    
    // 下部分
    UIView *_downView;
    UIButton *_deleteBtn;
    UIButton *_editBtn;
    UIButton *_teamBtn;
}
@end

static NSString *cellID = @"FCCalendarViewCell";

@implementation FCCalendarViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        _dataArray = [[NSMutableArray alloc] init];
        _showChineseCalendar = YES;
        _showChineseHoliday = YES;
        _showHolidayDifferentColor = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionViewLayout];
    [self setupUI];
    [self getDataSource:[NSDate date]];
}

#pragma mark - 获取日历数据
- (void)getDataSource:(NSDate *)date {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FCCalendarManager *manager = [[FCCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar];
        NSArray *tempDataArray = [manager getCalendarItemArrayWithDate:date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:tempDataArray];
            [_collectionView reloadData];
        });
    });
}

#pragma mark - UI布局
- (void)setupCollectionViewLayout {
    
    NSInteger width = FC_SCREEN_WIDTH/7;
    NSInteger height = 60;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, FC_WeekViewHeight, FC_SCREEN_WIDTH, FC_SCREEN_HEIGHT - FC_WeekViewHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[FCCalendarViewCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark - 创建UI
- (void)setupUI {
    
    // 标题视图
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = FC_HeaderViewColor;
    [self.view addSubview:_headerView];
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    [_titleBtn setTitle:[NSString stringWithFormat:@"%zd年%zd月", comps.year, comps.month] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:FC_HeaderViewTextColor forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_titleBtn];
    
    // 星期视图
    _weekView = [[UIView alloc] init];
    _weekView.backgroundColor = FC_SelectBackgroundColor;
    [self.view addSubview:_weekView];
    
    // 弹窗视图
    _popView = [[UIView alloc] init];
    _popView.backgroundColor = FC_popViewBgColor;
    _popView.layer.cornerRadius = 5;
    _popView.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0.01, 0.01);
}

#pragma mark - 选择日期
- (void)selectDate {
    
    FCCalendarPickerView *pickerView = [[FCCalendarPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 261)];
    [pickerView show];
    pickerView.selectDate = ^(NSDate *date){
        NSLog(@"选中的日期:%@", date);
        [_dataArray removeAllObjects];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
        [_titleBtn setTitle:[NSString stringWithFormat:@"%zd年%zd月", comps.year, comps.month]forState:UIControlStateNormal];
        [self getDataSource:date];
    };
}

#pragma mark - 控件布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // headerView
    _headerView.frame = CGRectMake(0, 64, FC_SCREEN_WIDTH, FC_HeaderViewHeight);
    _titleBtn.frame = _headerView.bounds;
    
    // 星期的view
    _weekView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), FC_SCREEN_WIDTH, FC_WeekViewHeight);
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSInteger i = 0;
    NSInteger width = FC_SCREEN_WIDTH/7;
    for(i = 0; i < 7; i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, FC_WeekViewHeight)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.text = weekArray[i];
        weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if(i == 0 || i == 6) {
            weekLabel.textColor = FC_WeekEndTextColor;
        } else {
            weekLabel.textColor = FC_SelectTextColor;
        }
        [_weekView addSubview:weekLabel];
    }
    
    // collectionView
    _collectionView.frame = CGRectMake(0, FC_HeaderViewHeight + FC_WeekViewHeight, FC_SCREEN_WIDTH, FC_SCREEN_HEIGHT - FC_HeaderViewHeight - FC_WeekViewHeight);
}

#pragma mark - collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FCCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    selectView.backgroundColor = FC_CellBgColor;
    cell.selectedBackgroundView = selectView;
    
    FCCalendarModel *calendarItem = _dataArray[indexPath.row];
    cell.dateLabel.text = @"";
    cell.dateLabel.textColor = FC_TextColor;
    cell.subLabel.text = @"";
    cell.subLabel.textColor = FC_SelectSubLabelTextColor;
    cell.userInteractionEnabled = NO;
    
    // 天数大于1才设置
    if(calendarItem.day > 0) {
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarItem.day];
        cell.userInteractionEnabled = YES;
    }
    // 是否显示中国节日
    if(_showChineseCalendar) {
        cell.subLabel.text = calendarItem.chineseCalendar;
    }
    // 周末的颜色改变
    if(calendarItem.week == 0 || calendarItem.week == 6) {
        cell.dateLabel.textColor = FC_WeekEndTextColor;
        cell.subLabel.textColor = FC_WeekEndTextColor;
    }
    // 如果当天是节日,就显示节日
    if(calendarItem.holiday.length > 0) {
        cell.subLabel.text = calendarItem.holiday;
        if(_showHolidayDifferentColor)
        {
            cell.dateLabel.textColor = FC_HolidayTextColor;
            cell.subLabel.textColor = FC_HolidayTextColor;
        }
    }
    // 每一行的下划线
    CGFloat y = cell.frame.size.height;
    for (NSInteger i = 1; i < 5; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = FC_LineColor;
        [_collectionView addSubview:lineView];
        lineView.frame = CGRectMake(0, y*i, FC_SCREEN_WIDTH, 1);
    }
    // 让今天被选中
    if (calendarItem.isSelectCell) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    // 是否设置能弹框的标记
    if (calendarItem.isCanPop) {
        cell.imageView.image = [UIImage imageNamed:@"popMark"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@""];
    }
    return cell;
}

#pragma mark - collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消之前选中的cell
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        FCCalendarModel *item = _dataArray[i];
        item.selectCell = NO;
    }
    FCCalendarModel *calendaItem = _dataArray[indexPath.row];
    calendaItem.selectCell = YES;
    [_collectionView reloadData];
    
    NSDate *selectDate = [self intervalToDate:calendaItem.dateInterval];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    _selectDateStr = [fmt stringFromDate:selectDate];
    // 将选中的日期传递出去
    if (self.selectDateCallback) {
        self.selectDateCallback(_selectDateStr);
    }
    
    // 1-7分别对应周日-周六
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _selectWeek = [greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:selectDate];
    
    // 判断是否能弹窗
    if (calendaItem.isCanPop) {
        // 添加遮盖和popview
        [self.view addSubview:[self addCoverView]];
        [self.view addSubview:_popView];
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat x = 20;
            CGFloat w = self.view.frame.size.width - 2*x;
            CGFloat h = 437;
            CGFloat y = (self.view.frame.size.height - h)/2;
            _popView.frame = CGRectMake(x, y, w, h);
            // 添加弹框内子控件
            [self addChildOfPopView];
        }];
    }
}

#pragma mark - 布局弹框内的子控件
- (void)addChildOfPopView {
    
    // 上部分
    _upView = [[UIView alloc] init];
    _upView.backgroundColor = FC_popViewUpBgColor;
    _upView.frame = CGRectMake(0, 0, _popView.frame.size.width, 153);
    [_popView addSubview:_upView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.frame = CGRectMake(_upView.frame.size.width - 34, 10, 24, 24);
    [_upView addSubview:_closeBtn];
    
    _yearMonthL = [[UILabel alloc] init];
    NSArray *dateArr = [_selectDateStr componentsSeparatedByString:@"-"];
    _yearMonthL.text = [NSString stringWithFormat:@"%@年%@月", dateArr[0], dateArr[1]];
    _yearMonthL.textColor = [UIColor darkGrayColor];
    _yearMonthL.font = [UIFont systemFontOfSize:16];
    _yearMonthL.textAlignment = NSTextAlignmentCenter;
    _yearMonthL.frame = CGRectMake(0, CGRectGetMaxY(_closeBtn.frame)+10, _upView.frame.size.width, 21);
    [_upView addSubview:_yearMonthL];
    
    _dayL = [[UILabel alloc] init];
    _dayL.text = [NSString stringWithFormat:@"%@", dateArr[2]];
    _dayL.textColor = [UIColor blackColor];
    _dayL.font = [UIFont systemFontOfSize:20];
    _dayL.textAlignment = NSTextAlignmentCenter;
    _dayL.frame = CGRectMake(0, CGRectGetMaxY(_yearMonthL.frame)+10, _upView.frame.size.width, 21);
    [_upView addSubview:_dayL];
    
    _weekTimeL = [[UILabel alloc] init];
    switch (_selectWeek) {
        case 1:
            _weekTimeL.text = @"星期日  10:00-11:00";
            break;
        case 2:
            _weekTimeL.text = @"星期一  10:00-11:00";
            break;
        case 3:
            _weekTimeL.text = @"星期二  10:00-11:00";
            break;
        case 4:
            _weekTimeL.text = @"星期三  10:00-11:00";
            break;
        case 5:
            _weekTimeL.text = @"星期四  10:00-11:00";
            break;
        case 6:
            _weekTimeL.text = @"星期五  10:00-11:00";
            break;
        case 7:
            _weekTimeL.text = @"星期六  10:00-11:00";
            break;
    }
    _weekTimeL.textColor = [UIColor darkGrayColor];
    _weekTimeL.font = [UIFont systemFontOfSize:17];
    _weekTimeL.textAlignment = NSTextAlignmentCenter;
    _weekTimeL.frame = CGRectMake(0, CGRectGetMaxY(_dayL.frame)+10, _upView.frame.size.width, 21);
    [_upView addSubview:_weekTimeL];
    
    // 中部分
    _middleView = [[UIView alloc] init];
    _middleView.backgroundColor = FC_popViewMiddleBgColor;
    _middleView.frame = CGRectMake(0, CGRectGetMaxY(_upView.frame), _popView.frame.size.width, 244);
    [_popView addSubview:_middleView];
    
    _meetingTitle = [[UILabel alloc] init];
    _meetingTitle.text = @"会议号";
    _meetingTitle.textColor = [UIColor darkGrayColor];
    _meetingTitle.font = [UIFont systemFontOfSize:17];
    _meetingTitle.textAlignment = NSTextAlignmentLeft;
    _meetingTitle.frame = CGRectMake(20, 0, 100, 48);
    [_middleView addSubview:_meetingTitle];
    
    _meetingNum = [[UILabel alloc] init];
    _meetingNum.text = @"VMC0000001";
    _meetingNum.textColor = [UIColor blackColor];
    _meetingNum.font = [UIFont systemFontOfSize:17];
    _meetingNum.textAlignment = NSTextAlignmentRight;
    _meetingNum.frame = CGRectMake(CGRectGetMaxX(_meetingTitle.frame), 0, _middleView.frame.size.width - CGRectGetMaxX(_meetingTitle.frame)-20, 48);
    [_middleView addSubview:_meetingNum];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor brownColor];
    lineOne.frame = CGRectMake(20, CGRectGetMaxY(_meetingNum.frame), _middleView.frame.size.width-40, 1);
    [_middleView addSubview:lineOne];
    
    _meetingTheme = [[UILabel alloc] init];
    _meetingTheme.text = @"会议主题";
    _meetingTheme.textColor = [UIColor darkGrayColor];
    _meetingTheme.font = [UIFont systemFontOfSize:17];
    _meetingTheme.textAlignment = NSTextAlignmentLeft;
    _meetingTheme.frame = CGRectMake(20, CGRectGetMaxY(lineOne.frame), 100, 48);
    [_middleView addSubview:_meetingTheme];
    
    _meetingContent = [[UILabel alloc] init];
    _meetingContent.text = @"关于糖尿病的深入研究";
    _meetingContent.textColor = [UIColor blackColor];
    _meetingContent.font = [UIFont systemFontOfSize:17];
    _meetingContent.textAlignment = NSTextAlignmentRight;
    _meetingContent.frame = CGRectMake(CGRectGetMaxX(_meetingTheme.frame), CGRectGetMaxY(lineOne.frame), _middleView.frame.size.width - CGRectGetMaxX(_meetingTheme.frame)-20, 48);
    [_middleView addSubview:_meetingContent];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor brownColor];
    lineTwo.frame = CGRectMake(20, CGRectGetMaxY(_meetingContent.frame), _middleView.frame.size.width-40, 1);
    [_middleView addSubview:lineTwo];
    
    _repeatL = [[UILabel alloc] init];
    _repeatL.text = @"重复";
    _repeatL.textColor = [UIColor darkGrayColor];
    _repeatL.font = [UIFont systemFontOfSize:17];
    _repeatL.textAlignment = NSTextAlignmentLeft;
    _repeatL.frame = CGRectMake(20, CGRectGetMaxY(lineTwo.frame), 100, 48);
    [_middleView addSubview:_repeatL];
    
    _repeatContent = [[UILabel alloc] init];
    switch (_selectWeek) {
        case 1:
            _repeatContent.text = @"每周日";
            break;
        case 2:
            _repeatContent.text = @"每周一";
            break;
        case 3:
            _repeatContent.text = @"每周二";
            break;
        case 4:
            _repeatContent.text = @"每周三";
            break;
        case 5:
            _repeatContent.text = @"每周四";
            break;
        case 6:
            _repeatContent.text = @"每周五";
            break;
        case 7:
            _repeatContent.text = @"每周六";
            break;
    }
    _repeatContent.textColor = [UIColor blackColor];
    _repeatContent.font = [UIFont systemFontOfSize:17];
    _repeatContent.textAlignment = NSTextAlignmentRight;
    _repeatContent.frame = CGRectMake(CGRectGetMaxX(_repeatL.frame), CGRectGetMaxY(lineTwo.frame), _middleView.frame.size.width - CGRectGetMaxX(_repeatL.frame)-20, 48);
    [_middleView addSubview:_repeatContent];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor brownColor];
    lineThree.frame = CGRectMake(20, CGRectGetMaxY(_repeatContent.frame), _middleView.frame.size.width-40, 1);
    [_middleView addSubview:lineThree];
    
    _meetingPwdL = [[UILabel alloc] init];
    _meetingPwdL.text = @"会议密码";
    _meetingPwdL.textColor = [UIColor darkGrayColor];
    _meetingPwdL.font = [UIFont systemFontOfSize:17];
    _meetingPwdL.textAlignment = NSTextAlignmentLeft;
    _meetingPwdL.frame = CGRectMake(20, CGRectGetMaxY(lineThree.frame), 100, 48);
    [_middleView addSubview:_meetingPwdL];
    
    _meetingPwd = [[UILabel alloc] init];
    _meetingPwd.text = @"123456";
    _meetingPwd.textColor = [UIColor blackColor];
    _meetingPwd.font = [UIFont systemFontOfSize:17];
    _meetingPwd.textAlignment = NSTextAlignmentRight;
    _meetingPwd.frame = CGRectMake(CGRectGetMaxX(_meetingPwdL.frame), CGRectGetMaxY(lineThree.frame), _middleView.frame.size.width - CGRectGetMaxX(_meetingPwdL.frame)-20, 48);
    [_middleView addSubview:_meetingPwd];
    
    UIView *lineFour = [[UIView alloc] init];
    lineFour.backgroundColor = [UIColor brownColor];
    lineFour.frame = CGRectMake(20, CGRectGetMaxY(_meetingPwd.frame), _middleView.frame.size.width-40, 1);
    [_middleView addSubview:lineFour];
    
    _managePwdL = [[UILabel alloc] init];
    _managePwdL.text = @"管理密码";
    _managePwdL.textColor = [UIColor darkGrayColor];
    _managePwdL.font = [UIFont systemFontOfSize:17];
    _managePwdL.textAlignment = NSTextAlignmentLeft;
    _managePwdL.frame = CGRectMake(20, CGRectGetMaxY(lineFour.frame), 100, 48);
    [_middleView addSubview:_managePwdL];
    
    _managePwd = [[UILabel alloc] init];
    _managePwd.text = @"654321";
    _managePwd.textColor = [UIColor blackColor];
    _managePwd.font = [UIFont systemFontOfSize:17];
    _managePwd.textAlignment = NSTextAlignmentRight;
    _managePwd.frame = CGRectMake(CGRectGetMaxX(_managePwdL.frame), CGRectGetMaxY(lineFour.frame), _middleView.frame.size.width - CGRectGetMaxX(_managePwdL.frame)-20, 48);
    [_middleView addSubview:_managePwd];
    
    // 下部分
    _downView = [[UIView alloc] init];
    _downView.backgroundColor = FC_popViewDownBgColor;
    _downView.frame = CGRectMake(0, CGRectGetMaxY(_middleView.frame), _popView.frame.size.width, 60);
    [_popView addSubview:_downView];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.frame = CGRectMake(30, (_downView.frame.size.height-24)*0.5, 24, 24);
    [_downView addSubview:_deleteBtn];
    
    _teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_teamBtn setImage:[UIImage imageNamed:@"team"] forState:UIControlStateNormal];
    [_teamBtn addTarget:self action:@selector(teamBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _teamBtn.frame = CGRectMake(_downView.frame.size.width-54, (_downView.frame.size.height-24)*0.5, 24, 24);
    [_downView addSubview:_teamBtn];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.frame = CGRectMake(_teamBtn.frame.origin.x-60, (_downView.frame.size.height-24)*0.5, 24, 24);
    [_downView addSubview:_editBtn];
}

#pragma mark - 关闭弹框
- (void)closePopView {

    [UIView animateWithDuration:0.25 animations:^{
        _upView.frame = CGRectMake(_popView.frame.size.width*0.5, _popView.frame.size.height*0.5, 0.01, 0.01);
        _middleView.frame = CGRectMake(_popView.frame.size.width*0.5, _popView.frame.size.height*0.5, 0.01, 0.01);
        _downView.frame = CGRectMake(_popView.frame.size.width*0.5, _popView.frame.size.height*0.5, 0.01, 0.01);
        _popView.frame = CGRectMake(_coverView.frame.size.width*0.5, _coverView.frame.size.height*0.5, 0.01, 0.01);
    } completion:^(BOOL finished) {
        [_upView removeFromSuperview];
        [_middleView removeFromSuperview];
        [_downView removeFromSuperview];
        [_popView removeFromSuperview];
        [_coverView removeFromSuperview];
    }];
}

#pragma mark - 删除按钮的点击
- (void)deleteBtnDidClick {
    
}

#pragma mark - 编辑按钮的点击
- (void)editBtnDidClick {
    
}

#pragma mark - 团队按钮的点击
- (void)teamBtnDidClick {
    
}

#pragma mark - 移除遮盖
- (void)removeCoverView {
    [self closePopView];
}

#pragma mark - 遮盖的view
- (UIButton *)addCoverView {
    if (_coverView == nil) {
        _coverView = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverView.frame = CGRectMake(0, 0, FC_SCREEN_WIDTH, FC_SCREEN_HEIGHT);
        _coverView.backgroundColor = FC_coverViewBgColor;
        _coverView.alpha = 0.6;
        [_coverView addTarget:self action:@selector(removeCoverView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}

#pragma mark - 时间戳转日期
- (NSDate *)intervalToDate:(NSInteger)interval {
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
