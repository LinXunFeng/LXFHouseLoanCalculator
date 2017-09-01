//
//  LXFCalculatorGroupViewController.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalculatorGroupViewController.h"

@interface LXFCalculatorGroupViewController ()

@end

@implementation LXFCalculatorGroupViewController

- (void)viewDidLoad {
    self.tpCellTypes = @[
                         @[@(HRCalculatorBaseCellTypeSelectStr)],
                         @[
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeInput)
                             ]
                         ];
    
    self.tpSelectStrArr[0][0] = kRepaymentMethods;
    self.tpSelectStrArr[1][2] = kMortgageYears;
    
    self.tpUnitArr[1][0] = @"元";
    self.tpUnitArr[1][1] = @"元";
    self.tpUnitArr[1][3] = @"%";
    self.tpUnitArr[1][4] = @"%";
    
    
    self.tpValueArr[0][0] = kRepaymentMethods.firstObject;
    self.tpValueArr[1][2] = kMortgageYears.firstObject;
    
    [super viewDidLoad];
}

- (NSArray<NSArray<NSString *> *> *)getTotalPriceArr {
    return @[
             @[@"还款方式"],
             @[@"商业贷款总额",@"公积金贷款总额",@"按揭年数",@"银行利率", @"公积金利率"]
             ];
}
- (NSInteger)getHRCalculatorCalcType {
    return HRCalculatorCalcTypeGroup;
}

// 处理选项数组数据专用
- (void)handleSelectStr:(NSString *)selectStr indexPath:(NSIndexPath *)indexPath buttonIndex:(NSInteger)buttonIndex {
    if (indexPath.row == 2) { // 按揭年数
        self.mortgageYear = (int)(self.mortgageYears.count - buttonIndex + 1);
    }
}
// 处理输入数据专用
- (void)handleInputStr:(NSString *)inputStr indexPath:(NSIndexPath *)indexPath {
    double inputValue = [inputStr doubleValue];
    
    if (indexPath.row == 0) { // 商业贷款总额
        self.businessTotalPrice = inputValue;
    } else if (indexPath.row == 1) {    // 公积金贷款总额
        self.fundTotalPrice = inputValue;
    } else if (indexPath.row == 3) {    // 银行利率
        self.bankRate = inputValue;
    } else if (indexPath.row == 4) {    // 公积金利率
        self.fundRate = inputValue;
    }
}

// 防止reloadData后textField变空
- (double)getInputValueWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {   // 商业贷款总额
        return self.businessTotalPrice;
    } else if (indexPath.row == 1) {    // 公积金贷款总额
        return self.fundTotalPrice;
    } else if (indexPath.row == 3) {    // 银行利率
        return self.bankRate;
    } else if (indexPath.row == 4) {    // 公积金利率
        return self.fundRate;
    }
    return 0;
}

@end
