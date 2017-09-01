//
//  LXFCalculatorBaseViewController.h
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HRCalculatorCalcTypeBusiness = 0,   // 商业贷款
    HRCalculatorCalcTypeFund,   // 公积金贷款
    HRCalculatorCalcTypeGroup,  // 组合贷款
} HRCalculatorCalcType;

typedef enum : NSUInteger {
    HRCalculatorBaseCellTypeInput = 0,
    HRCalculatorBaseCellTypeSelectStr
} HRCalculatorBaseCellType;

// 还款方式
#define kRepaymentMethods self.repaymentMethods
// 计算方式
#define kCalculateMethods self.calculateMethods
// 按揭年数
#define kMortgageYears    self.mortgageYears
// 按揭成数
#define kMortgageMultis   self.mortgageMultis

@interface LXFCalculatorBaseViewController : UIViewController

/** 计算方式是否为总价 */
@property (nonatomic, assign) BOOL isCalcMethodTotalPrice;
/** 总价【TP】 */
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *totalPriceArr;
/** 单人和面积【UP】 */
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *unitPriceArr;
/** tpCellTypes */
@property (nonatomic, strong) NSArray<NSArray *> *tpCellTypes;
/** upCellTypes */
@property (nonatomic, strong) NSArray<NSArray *> *upCellTypes;
/** cell选项 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSArray *> *> *tpSelectStrArr;
/** cell选项 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSArray *> *> *upSelectStrArr;
/** 需要提交的值 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *tpValueArr;
/** 需要提交的值 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *upValueArr;
/** 单位数组 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *tpUnitArr;
/** 单位数组 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *upUnitArr;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 还款方式 */
@property (nonatomic, strong) NSArray<NSString *> *repaymentMethods;
/** 计算方式 */
@property (nonatomic, strong) NSArray<NSString *> *calculateMethods;
/** 按揭年数 */
@property (nonatomic, strong) NSArray<NSString *> *mortgageYears;
/** 按揭成数 */
@property (nonatomic, strong) NSArray<NSString *> *mortgageMultis;

#pragma mark 提交所需变量
/** 还款方式 （0:等额本息 1:等额本金） */
@property (nonatomic, assign) int repayMethod;
/** 单价 */
@property (nonatomic, assign) double unitPrice;
/** 面积 */
@property (nonatomic, assign) double area;
/** 商业贷款总额 */
@property (nonatomic, assign) double businessTotalPrice;
/** 公积金贷款总额 */
@property (nonatomic, assign) double fundTotalPrice;
/** 按揭年数 */
@property (nonatomic, assign) int mortgageYear;
/** 按揭成数 */
@property (nonatomic, assign) int mortgageMulti;
/** 银行利率 */
@property (nonatomic, assign) double bankRate;
/** 公积金利率 */
@property (nonatomic, assign) double fundRate;

#pragma mark - 待子类重写
- (NSArray<NSArray<NSString *> *> *)getTotalPriceArr;
- (NSArray<NSArray<NSString *> *> *)getUnitPriceArr;
- (NSInteger)getHRCalculatorCalcType;
// 处理选项数组数据专用
- (void)handleSelectStr:(NSString *)selectStr indexPath:(NSIndexPath *)indexPath buttonIndex:(NSInteger)buttonIndex;
// 处理输入数据专用
- (void)handleInputStr:(NSString *)inputStr indexPath:(NSIndexPath *)indexPath;
// 防止reloadData后textField变空
- (double)getInputValueWithIndexPath:(NSIndexPath *)indexPath;

@end
