//
//  LXFCalculatorViewController.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalculatorViewController.h"

#import "LXFCalculatorBusinessViewController.h"
#import "LXFCalculatorFundViewController.h"
#import "LXFCalculatorGroupViewController.h"

@interface LXFCalculatorViewController ()<XLBasePageControllerDelegate,XLBasePageControllerDataSource>

@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LXFCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"商业贷款",@"公积金贷款",@"组合贷款"];
    self.delegate = self;
    self.dataSource = self;
    
    //self.lineWidth = 2.0;//选中下划线宽度
    self.titleFont = [UIFont systemFontOfSize:16.0];
    self.defaultColor = [UIColor blackColor];//默认字体颜色
    self.chooseColor = [UIColor redColor];//选中字体颜色
    self.selectIndex = 0;//默认选中第几页
    
    [self reloadScrollPage];
    
    self.navigationItem.title = @"房贷计算器";
}

-(NSInteger)numberViewControllersInViewPager:(XLBasePageController *)viewPager
{
    return _titleArray.count;
}

- (UIViewController *)viewPager:(XLBasePageController *)viewPager indexViewControllers:(NSInteger)index
{
    if (index == 0) {
        LXFCalculatorBusinessViewController *businessVC = [[LXFCalculatorBusinessViewController alloc] init];
        return businessVC;
    }if (index == 1) {
        LXFCalculatorFundViewController *fundVC = [[LXFCalculatorFundViewController alloc] init];
        return fundVC;
    }
    else{
        LXFCalculatorGroupViewController *groupVC = [[LXFCalculatorGroupViewController alloc] init];
        return groupVC;
    }
}

-(CGFloat)heightForTitleViewPager:(XLBasePageController *)viewPager
{
    return 50;
}

-(NSString *)viewPager:(XLBasePageController *)viewPager titleWithIndexViewControllers:(NSInteger)index
{
    return self.titleArray[index];
}

@end
