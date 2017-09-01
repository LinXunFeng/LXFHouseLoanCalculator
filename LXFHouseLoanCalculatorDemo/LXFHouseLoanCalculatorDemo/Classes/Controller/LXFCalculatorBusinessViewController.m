//
//  LXFCalculatorBusinessViewController.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalculatorBusinessViewController.h"

@interface LXFCalculatorBusinessViewController ()

@end

@implementation LXFCalculatorBusinessViewController

- (void)viewDidLoad {
    self.tpCellTypes = @[
                         @[@(HRCalculatorBaseCellTypeSelectStr)],
                         @[
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeInput)
                             ]
                         ];
    
    self.upCellTypes = @[
                         @[@(HRCalculatorBaseCellTypeSelectStr)],
                         @[
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeInput),
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeSelectStr),
                             @(HRCalculatorBaseCellTypeInput)
                             ]
                         ];
    self.tpSelectStrArr[0][0] = kRepaymentMethods;
    self.tpSelectStrArr[1][0] = kCalculateMethods;
    self.tpSelectStrArr[1][2] = kMortgageYears;
    
    self.upSelectStrArr[0][0] = kRepaymentMethods;
    self.upSelectStrArr[1][0] = kCalculateMethods;
    self.upSelectStrArr[1][3] = kMortgageYears;
    self.upSelectStrArr[1][4] = kMortgageMultis;
    
    self.tpUnitArr[1][1] = @"元";
    self.tpUnitArr[1][3] = @"%";
    
    self.upUnitArr[1][1] = @"元";
    self.upUnitArr[1][2] = @"㎡";
    self.upUnitArr[1][5] = @"%";
    
    self.tpValueArr[0][0] = kRepaymentMethods.firstObject;
    self.tpValueArr[1][0] = kCalculateMethods.firstObject;
    self.tpValueArr[1][2] = kMortgageYears.firstObject;
    
    self.upValueArr[0][0] = kRepaymentMethods.firstObject;
    self.upValueArr[1][0] = kCalculateMethods.firstObject;
    self.upValueArr[1][3] = kMortgageYears.firstObject;
    self.upValueArr[1][4] = kMortgageMultis.firstObject;
    
    [super viewDidLoad];
}

- (NSInteger)getHRCalculatorCalcType {
    return HRCalculatorCalcTypeBusiness;
}

// 处理选项数组数据专用
- (void)handleSelectStr:(NSString *)selectStr indexPath:(NSIndexPath *)indexPath buttonIndex:(NSInteger)buttonIndex {
    if (self.isCalcMethodTotalPrice) {
        if (indexPath.row == 2) { // 按揭年数
            self.mortgageYear = (int)(self.mortgageYears.count - buttonIndex + 1);
        }
    } else {
        if (indexPath.row == 3) {   // 按揭年数
            self.mortgageYear = (int)(self.mortgageYears.count - buttonIndex + 1);
        } else if (indexPath.row == 4) {    // 按揭成数
            self.mortgageMulti = (int)buttonIndex;
        }
    }
}
// 处理输入数据专用
- (void)handleInputStr:(NSString *)inputStr indexPath:(NSIndexPath *)indexPath {
    double inputValue = [inputStr doubleValue];
    if (self.isCalcMethodTotalPrice) {
        if (indexPath.row == 1) { // 商业贷款总额
            self.businessTotalPrice = inputValue;
        } else if (indexPath.row == 3) {    // 银行利率
            self.bankRate = inputValue;
        }
    } else {
        if (indexPath.row == 1) {   // 单价
            self.unitPrice = inputValue;
        } else if (indexPath.row == 2) {    // 面积
            self.area = inputValue;
        } else if (indexPath.row == 5) {    // 银行利率
            self.bankRate = inputValue;
        }
    }
}

// 防止reloadData后textField变空
- (double)getInputValueWithIndexPath:(NSIndexPath *)indexPath {
    if (self.isCalcMethodTotalPrice) {
        if (indexPath.row == 1) {   // 商业贷款总额
            return self.businessTotalPrice;
        } else if (indexPath.row == 3) {    // 银行利率
            return self.bankRate;
        }
    } else {
        if (indexPath.row == 1) {   // 单价
            return self.unitPrice;
        } else if (indexPath.row == 2) {    // 面积
            return self.area;
        } else if (indexPath.row == 5) {    // 银行利率
            return self.bankRate;
        }
    }
    return 0;
}

@end
