//
//  ViewController.m
//  自定义日历控件
//
//  Created by FrankChung on 17/10/16.
//  Copyright © 2017年 VMC. All rights reserved.
//

#import "ViewController.h"
#import "FCCalendarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"选择日期" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnDidClick1 {
    
    FCCalendarViewController *ccv = [[FCCalendarViewController alloc] init];
    ccv.selectDateCallback = ^(NSString *selectDate){
        NSLog(@"您选中的日期是:%@", selectDate);
    };
    [self.navigationController pushViewController:ccv animated:YES];
}

@end
