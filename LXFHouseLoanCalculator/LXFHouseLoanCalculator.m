//
//  LXFHouseLoanCalculator.m
//
//  Created by LinXunFeng on 2017/8/25.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

#pragma mark - 宏定义
//根据版本控制是否打印log
#ifdef DEBUG
#define LXFLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define LXFLog( s, ... )
#endif

#import "LXFHouseLoanCalculator.h"

@implementation LXFHouseLoanCalculator

// 按揭成数要除以10 (即值的范围：0.0~1.0)
// 利率要除以100 (即值的范围：0.0~1.0)

/** =================================== 商业贷款 =================================== */
#pragma mark - 商业贷款
#pragma mark 按商业贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按商业贷款等额本息总价计算(总价)");
    // 贷款总额
    double loanTotalPrice = calcModel.businessTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    double monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 每月还款
    double avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按商业贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按商业贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款总额
    double loanTotalPrice = calcModel.businessTotalPrice;
    // 月利率
    double monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    double avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount;
    // 还款总额
    double repayTotalPrice = 0;
    for (int i             = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        double monthRepayment = avgMonthPrincipalRepayment
        + (loanTotalPrice - avgMonthPrincipalRepayment * i)
        * monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    double interestPayment = repayTotalPrice - calcModel.businessTotalPrice;
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.firstMonthRepayment      = avgMonthPrincipalRepayment;
    return resultModel;
}
#pragma mark 按商业贷款等额本息单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按商业贷款等额本息单价计算(单价和面积)");
    // 房屋总价
    double houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 首月还款
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    double monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 每月还款
    double avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按商业贷款等额本金单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按商业贷款等额本金单价计算(单价和面积)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    double avgMonthPrincipalRepayment = calcModel.unitPrice * calcModel.area * calcModel
    .mortgageMulti / 10.0 / loanMonthCount;
    // 房屋总价
    double houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 还款总额
    double repayTotalPrice = 0;
    for (int i             = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (单价*面积*按揭成数-每月还款*i) * 月利率
        double monthRepayment = avgMonthPrincipalRepayment
        +(calcModel.unitPrice * calcModel.area * calcModel.mortgageMulti / 10.0 - avgMonthPrincipalRepayment * i)
        *(calcModel.bankRate / 100 / 12.0);
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    // 首月还款
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    return resultModel;
}


/** =================================== 公积金贷款 =================================== */
#pragma mark - 公积金贷款
#pragma mark 按公积金贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按公积金贷款等额本息总价计算(总价)");
    // 贷款总额
    double loanTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    double monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 每月还款
    double avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按公积金贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款总额
    double loanTotalPrice = calcModel.fundTotalPrice;
    // 月利率
    double monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    double avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount;
    // 还款总额
    double repayTotalPrice = 0;
    for (int i             = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        double monthRepayment = avgMonthPrincipalRepayment
        + (loanTotalPrice - avgMonthPrincipalRepayment * i)
        * monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    double interestPayment = repayTotalPrice - calcModel.fundTotalPrice;
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本息单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按公积金贷款等额本息单价计算(单价和面积)");
    // 房屋总价
    double houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 首月还款
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    double monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 每月还款
    double avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本金单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按公积金贷款等额本金单价计算(单价和面积)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    double avgMonthPrincipalRepayment = calcModel.unitPrice * calcModel.area * calcModel
    .mortgageMulti / 10.0 / loanMonthCount;
    // 房屋总价
    double houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 月利率
    double monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 还款总额
    double repayTotalPrice = 0;
    for (int i             = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (单价*面积*按揭成数-每月还款*i) * 月利率
        double monthRepayment = avgMonthPrincipalRepayment
        +(calcModel.unitPrice * calcModel.area * calcModel.mortgageMulti / 10.0 - avgMonthPrincipalRepayment * i)
        *monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    // 首月还款
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}

/** =================================== 组合型贷款 =================================== */
#pragma mark - 组合型贷款
#pragma mark 按组合型贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按组合型贷款等额本息总价计算(总价)");
    // 商业贷款
    double businessTotalPrice = calcModel.businessTotalPrice;
    // 公积金贷款
    double fundTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 银行月利率
    double bankMonthRate = calcModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款总额
    double loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 每月还款
    double avgMonthRepayment =
    businessTotalPrice*bankMonthRate*powf(1+bankMonthRate, loanMonthCount)/(powf(1+bankMonthRate, loanMonthCount)-1)
    +
    fundTotalPrice*fundMonthRate*powf(1+fundMonthRate, loanMonthCount)/(powf(1+fundMonthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按组合型贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel {
    LXFLog(@"按组合型贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 商业贷款
    double businessTotalPrice = calcModel.businessTotalPrice;
    // 公积金贷款
    double fundTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    int loanMonthCount = calcModel.mortgageYear * 12;
    // 银行月利率
    double bankMonthRate = calcModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款总额
    double loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 商业每月所还本金（每月还款）
    double businessAvgMonthPrincipalRepayment = businessTotalPrice / loanMonthCount;
    // 公积金每月所还本金（每月还款）
    double fundAvgMonthPrincipalRepayment = fundTotalPrice / loanMonthCount;
    // 还款总额
    double repayTotalPrice = 0;
    for (int i = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        double monthRepayment = businessAvgMonthPrincipalRepayment
        +(businessTotalPrice - businessAvgMonthPrincipalRepayment * i)
        *bankMonthRate
        +
        fundAvgMonthPrincipalRepayment
        +(fundTotalPrice - fundAvgMonthPrincipalRepayment * i)
        *fundMonthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice +=monthRepayment;
    }
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    LXFHouseLoanResultModel *resultModel = [LXFHouseLoanResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}

@end

@implementation LXFHouseLoanCalcModel

@end

@implementation LXFHouseLoanResultModel

- (NSString *)description {
    return [NSString stringWithFormat:@"贷款总额: %f \n 还款总额: %f \n 支付利息: %f \n 按揭年数: %f \n 月均还款: %f \n 首月还款: %f \n ", self.loanTotalPrice, self.repayTotalPrice, self.interestPayment, self.mortgageYear, self.avgMonthRepayment, self.firstMonthRepayment];
}

@end
