//
//  LXFPopResultView.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFPopResultView.h"
#import "LXFPopResultCell.h"
#import "LXFCalculateResultModel.h"

#import "UITableViewCell+LXF.h"

#define kRowHeight 40
#define kHeaderHeight 40
#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static NSString * const LXFTableViewCellID = @"LXFPopResultCell";

@interface LXFPopResultView() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
/** dataArr */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation LXFPopResultView

- (void)setModel:(LXFHouseLoanResultModel *)model {
    _model = model;
    [self.dataArr removeAllObjects];
    
    if (!self.isCalcMethodTotalPrice) {
        // 房屋总价
        LXFCalculateResultModel *modelx = [LXFCalculateResultModel new];
        modelx.title = @"房屋总价";
        modelx.value = [NSString stringWithFormat:@"%.2f元", model.houseTotalPrice];
        [self.dataArr addObject:modelx];
    }
    
    // 贷款总额
    LXFCalculateResultModel *model1 = [LXFCalculateResultModel new];
    model1.title = @"贷款总额";
    model1.value = [NSString stringWithFormat:@"%.2f元", model.loanTotalPrice];
    model1.valueColor = [UIColor redColor];
    [self.dataArr addObject:model1];
    
    // 还款总额
    LXFCalculateResultModel *model2 = [LXFCalculateResultModel new];
    model2.title = @"还款总额";
    model2.value = [NSString stringWithFormat:@"%.2f元", model.repayTotalPrice];
    [self.dataArr addObject:model2];
    
    // 支付利息
    LXFCalculateResultModel *model3 = [LXFCalculateResultModel new];
    model3.title = @"支付利息";
    model3.value = [NSString stringWithFormat:@"%.2f元", model.interestPayment];
    [self.dataArr addObject:model3];
    
    if (!self.isCalcMethodTotalPrice) {
        // 首期付款
        LXFCalculateResultModel *modelx = [LXFCalculateResultModel new];
        modelx.title = @"首期付款";
        modelx.value = [NSString stringWithFormat:@"%.2f元", model.houseTotalPrice];
        [self.dataArr addObject:modelx];
    }
    
    // 按揭年数
    LXFCalculateResultModel *model4 = [LXFCalculateResultModel new];
    model4.title = @"按揭年数";
    model4.value = [NSString stringWithFormat:@"%d年(%d个月)",(int)model.mortgageYear ,(int)model.mortgageMonth];
    //    model4.value = [NSString stringWithFormat:@"%.2f", model.mortgageYear];r
    [self.dataArr addObject:model4];
    
    // 月均还款
    LXFCalculateResultModel *model5 = [LXFCalculateResultModel new];
    model5.title = @"月均还款";
    model5.value = [NSString stringWithFormat:@"%.2f元", model.avgMonthRepayment];
    [self.dataArr addObject:model5];
    
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.4];
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXFPopResultCell *cell = [LXFPopResultCell loadCellFromNib:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH - 70, kHeaderHeight)];
    view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH - 70, kHeaderHeight)];
    label.text = @"计算结果";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    CGRect frame = CGRectMake(35, 0, KSCREEN_WIDTH - 70, self.dataArr.count * kRowHeight + kHeaderHeight);
    self.tableView.frame = frame;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.tableView.frame = CGRectMake(35, (KSCREEN_HEIGHT - self.dataArr.count * kRowHeight) * 0.5 - kHeaderHeight, KSCREEN_WIDTH - 70, self.dataArr.count * kRowHeight + kHeaderHeight);
    }];
}

- (void)dismiss {
    //动画效果淡出
    [UIView animateWithDuration:.25 animations:^{
        
        CGRect frame = CGRectMake(35, 0, KSCREEN_WIDTH - 70, self.dataArr.count * kRowHeight + kHeaderHeight);
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self dismiss];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, KSCREEN_WIDTH - 70, self.dataArr.count * kRowHeight + kHeaderHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.sectionHeaderHeight = 40;
        tableView.scrollEnabled = NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
