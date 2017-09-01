//
//  LXFCalculatorBaseViewController.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define WeakSelf __weak typeof(self)weakSelf = self;

#import "LXFCalculatorBaseViewController.h"
#import "LXFHouseLoanCalculator.h"
#import "LXFCalculatorCalcBtnView.h"

#import "LXFCalcSelectStrCell.h"
#import "LXFCalcInputCell.h"
#import "LXFPopResultView.h"

#import "NSArray+LXF.h"
#import "UITableViewCell+LXF.h"
#import "UIView+LXF.h"

#import "LCActionSheet.h"
#import "Masonry.h"

@interface LXFCalculatorBaseViewController () <UITableViewDelegate,UITableViewDataSource>
/** calcBtnView */
@property (nonatomic, strong) LXFCalculatorCalcBtnView *calcBtnView;
/** 当前选项数组 */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSArray *> *> *curSelectStrArr;

@end

@implementation LXFCalculatorBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.isCalcMethodTotalPrice = YES;
    self.repayMethod = 0;
    self.mortgageYear = 30;
    self.mortgageMulti = 1;
    self.bankRate = 4.1;
    self.fundRate = 4.1;
    
    [self calcTableViewHeight];
    [self.tableView reloadData];
}

- (void)dealloc {
    NSLog(@"--- HRCalculatorBaseViewController dealloc ---");
}

// 计算tableView的高度
- (void)calcTableViewHeight {
    CGFloat rowNumber = 0;
    CGFloat tableViewHieght = 0;
    CGFloat headerViewH = 0;
    if (self.isCalcMethodTotalPrice) {
        for (NSArray *arr in self.totalPriceArr) {
            rowNumber += arr.count;
            headerViewH += 10;
        }
    } else {
        for (NSArray *arr in self.unitPriceArr) {
            rowNumber += arr.count;
            headerViewH += 10;
        }
    }
    tableViewHieght = rowNumber * 44 + headerViewH;
    self.tableView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, tableViewHieght);
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isCalcMethodTotalPrice) {
        return self.totalPriceArr.count;
    }
    return self.unitPriceArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isCalcMethodTotalPrice) {
        return self.totalPriceArr[section].count;
    }
    return self.unitPriceArr[section].count;
}


- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    double value = [self getInputValueWithIndexPath:indexPath];
    NSNumber *number = [[NSNumber alloc] initWithDouble:value];
    NSString *inputValue = [number stringValue];
    
    WeakSelf
    if (self.isCalcMethodTotalPrice) {  // 总价
        HRCalculatorBaseCellType type = [[[self.tpCellTypes safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row] intValue];
        if (type == HRCalculatorBaseCellTypeSelectStr) {
            LXFCalcSelectStrCell *cell = [LXFCalcSelectStrCell loadCellFromNib:tableView];
            cell.titleLabel.text = self.totalPriceArr[indexPath.section][indexPath.row];
            cell.valueLabel.text = self.tpValueArr[indexPath.section][indexPath.row];
            return cell;
        }
        LXFCalcInputCell *cell = [LXFCalcInputCell loadCellFromNib:tableView];
        cell.titleLabel.text = self.totalPriceArr[indexPath.section][indexPath.row];
        cell.valueLabel.text = inputValue;
        cell.unitLabel.text = [[self.tpUnitArr safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
        cell.inputBlock = ^(NSString *text) {
            [weakSelf handleInputStr:text indexPath:indexPath];
        };
        return cell;
    } else {    // 单价和面积
        HRCalculatorBaseCellType type = [[[self.upCellTypes safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row] intValue];
        if (type == HRCalculatorBaseCellTypeSelectStr) {
            LXFCalcSelectStrCell *cell = [LXFCalcSelectStrCell loadCellFromNib:tableView];
            cell.valueLabel.text = self.upValueArr[indexPath.section][indexPath.row];
            cell.titleLabel.text = self.unitPriceArr[indexPath.section][indexPath.row];
            return cell;
        }
        LXFCalcInputCell *cell = [LXFCalcInputCell loadCellFromNib:tableView];
        cell.titleLabel.text = self.unitPriceArr[indexPath.section][indexPath.row];
        cell.valueLabel.text = inputValue;
        cell.unitLabel.text = [[self.upUnitArr safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
        cell.inputBlock = ^(NSString *text) {
            [weakSelf handleInputStr:text indexPath:indexPath];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HRCalculatorBaseCellType type = self.isCalcMethodTotalPrice ? [[[self.tpCellTypes safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row] intValue] : [[[self.upCellTypes safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row] intValue];
    
    if (type == HRCalculatorBaseCellTypeSelectStr) {
        [self showActionSheetWithIndexPath:indexPath selected:^(NSString *value) {
            NSLog(@"%@", value);
            if (indexPath.row == 0) {
                if (indexPath.section == 0) {
                    self.repayMethod = [value isEqualToString:@"等额本金"];
                } else if (indexPath.section == 1) {
                    self.isCalcMethodTotalPrice = [value isEqualToString:@"总价"];
                }
                [self calcTableViewHeight];
            }
            [self.tableView reloadData];
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)showActionSheetWithIndexPath:(NSIndexPath *)indexPath selected:(void(^)(NSString *value))selected {
    self.curSelectStrArr = self.isCalcMethodTotalPrice ? self.tpSelectStrArr : self.upSelectStrArr;
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) { // 取消
            return;
        }
        NSString *value = [self actionSheetSetValueWithButtonIndex:buttonIndex indexPath:indexPath];
        
        NSInteger row = indexPath.row;
        
        if (indexPath.section == 1 && self.isCalcMethodTotalPrice && row == 2) {
            self.tpValueArr[indexPath.section][row] = value;
            self.upValueArr[indexPath.section][row+1] = value;
        } else if (indexPath.section == 1 && !self.isCalcMethodTotalPrice && row == 3) {
            self.tpValueArr[indexPath.section][row-1] = value;
            self.upValueArr[indexPath.section][row] = value;
        } else {
            self.tpValueArr[indexPath.section][indexPath.row] = value;
            self.upValueArr[indexPath.section][indexPath.row] = value;
        }
        
        selected(value);
        
    } otherButtonTitleArray:self.curSelectStrArr[indexPath.section][indexPath.row]];
    actionSheet.visibleButtonCount = 7.0f;
    actionSheet.scrolling = YES;
    [actionSheet show];
}
// 如果对actionSheet 对 valueArr设置的值不满意，可以重写该方法
- (NSString *)actionSheetSetValueWithButtonIndex:(NSInteger)buttonIndex indexPath:(NSIndexPath *)indexPath {
    NSString *value = self.curSelectStrArr[indexPath.section][indexPath.row][buttonIndex - 1];
    [self handleSelectStr:value indexPath:indexPath buttonIndex:buttonIndex];
    return value;
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor lightTextColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor lightTextColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_tableView];
        
        [self.view addSubview:self.calcBtnView];
        [self.calcBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(_tableView.mas_bottom);
            make.height.mas_equalTo([LXFCalculatorCalcBtnView viewHeight]);
        }];
    }
    return _tableView;
}
- (LXFCalculatorCalcBtnView *)calcBtnView {
    if (!_calcBtnView) {
        WeakSelf
        LXFCalculatorCalcBtnView *calcBtnView = [LXFCalculatorCalcBtnView viewFromXib];
        calcBtnView.startCalcBlock = ^{
            LXFHouseLoanCalcModel *calcModel = [LXFHouseLoanCalcModel new];
            calcModel.unitPrice = self.unitPrice;
            calcModel.area = self.area;
            calcModel.businessTotalPrice = self. businessTotalPrice;
            calcModel.fundTotalPrice = self.fundTotalPrice;
            calcModel.bankRate = self.bankRate;
            calcModel.fundRate = self.fundRate;
            calcModel.mortgageYear = self.mortgageYear;
            calcModel.mortgageMulti = self.mortgageMulti;
            
            LXFHouseLoanResultModel *resultModel;
            
            switch ([weakSelf getHRCalculatorCalcType]) {
                case HRCalculatorCalcTypeBusiness:
                    NSLog(@"开始计算 -- HRCalculatorCalcTypeBusiness");
                {
                    if (self.isCalcMethodTotalPrice) {
                        if (self.repayMethod) { // 等额本金
                            resultModel = [LXFHouseLoanCalculator calculateBusinessLoanAsTotalPriceAndEqualPrincipalWithCalcModel:calcModel];
                        } else { // 等额本息
                            resultModel = [LXFHouseLoanCalculator calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:calcModel];
                        }
                    } else {
                        if (self.repayMethod) { // 等额本金
                            resultModel = [LXFHouseLoanCalculator calculateBusinessLoanAsUnitPriceAndEqualPrincipalWithCalcModel:calcModel];
                        } else { // 等额本息
                            resultModel = [LXFHouseLoanCalculator calculateBusinessLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:calcModel];
                        }
                    }
                }
                    break;
                case HRCalculatorCalcTypeFund:
                    NSLog(@"开始计算 -- HRCalculatorCalcTypeFund");
                {
                    if (self.isCalcMethodTotalPrice) {
                        if (self.repayMethod) { // 等额本金
                            resultModel = [LXFHouseLoanCalculator calculateFundLoanAsTotalPriceAndEqualPrincipalWithCalcModel:calcModel];
                        } else { // 等额本息
                            resultModel = [LXFHouseLoanCalculator calculateFundLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:calcModel];
                        }
                    } else {
                        if (self.repayMethod) { // 等额本金
                            resultModel = [LXFHouseLoanCalculator calculateFundLoanAsUnitPriceAndEqualPrincipalWithCalcModel:calcModel];
                        } else { // 等额本息
                            resultModel = [LXFHouseLoanCalculator calculateFundLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:calcModel];
                        }
                    }
                }
                    break;
                case HRCalculatorCalcTypeGroup:
                    NSLog(@"开始计算 -- HRCalculatorCalcTypeGroup");
                {
                    if (self.repayMethod) { // 等额本金
                        resultModel = [LXFHouseLoanCalculator calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:calcModel];
                    } else { // 等额本息
                        resultModel = [LXFHouseLoanCalculator calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:calcModel];
                    }
                }
                    break;
                default:
                    break;
            }
            LXFPopResultView *resultView = [[LXFPopResultView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
            resultView.isCalcMethodTotalPrice = self.isCalcMethodTotalPrice;
            resultView.model = resultModel;
            [resultView pop];
            NSLog(@"%@", resultModel);
        };
        _calcBtnView = calcBtnView;
    }
    return _calcBtnView;
}


- (NSArray *)totalPriceArr {
    if (!_totalPriceArr) {
        _totalPriceArr = [self getTotalPriceArr];
    }
    return _totalPriceArr;
}

- (NSArray *)unitPriceArr {
    if (!_unitPriceArr) {
        _unitPriceArr = [self getUnitPriceArr];
    }
    return _unitPriceArr;
}

- (NSMutableArray *)tpValueArr {
    if (!_tpValueArr) {
        _tpValueArr = [NSMutableArray array];
        for (int i = 0; i<self.totalPriceArr.count; i++) {
            [_tpValueArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.totalPriceArr[i].count; j++) {
                [_tpValueArr[i] addObject:@""];
            }
        }
    }
    return _tpValueArr;
}

- (NSMutableArray *)upValueArr {
    if (!_upValueArr) {
        _upValueArr = [NSMutableArray array];
        for (int i = 0; i<self.unitPriceArr.count; i++) {
            [_upValueArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.unitPriceArr[i].count; j++) {
                [_upValueArr[i] addObject:@""];
            }
        }
    }
    return _upValueArr;
}

- (NSMutableArray *)tpUnitArr {
    if (!_tpUnitArr) {
        _tpUnitArr = [NSMutableArray array];
        for (int i = 0; i<self.totalPriceArr.count; i++) {
            [_tpUnitArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.totalPriceArr[i].count; j++) {
                [_tpUnitArr[i] addObject:@""];
            }
        }
    }
    return _tpUnitArr;
}

- (NSMutableArray *)upUnitArr {
    if (!_upUnitArr) {
        _upUnitArr = [NSMutableArray array];
        for (int i = 0; i<self.unitPriceArr.count; i++) {
            [_upUnitArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.unitPriceArr[i].count; j++) {
                [_upUnitArr[i] addObject:@""];
            }
        }
    }
    return _upUnitArr;
}
- (NSArray<NSArray *> *)tpCellTypes {
    if (!_tpCellTypes) {
        _tpCellTypes = [NSArray arrayWithObject:[NSArray array]];
    }
    return _tpCellTypes;
}
- (NSArray<NSArray *> *)upCellTypes {
    if (!_upCellTypes) {
        _upCellTypes = [NSArray arrayWithObject:[NSArray array]];
    }
    return _upCellTypes;
}

- (NSMutableArray<NSMutableArray<NSArray *> *> *)tpSelectStrArr {
    if (!_tpSelectStrArr) {
        _tpSelectStrArr = [NSMutableArray array];
        for (int i = 0; i<self.totalPriceArr.count; i++) {
            [_tpSelectStrArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.totalPriceArr[i].count; j++) {
                [_tpSelectStrArr[i] addObject:[NSMutableArray array]];
            }
        }
    }
    return _tpSelectStrArr;
}

- (NSMutableArray<NSMutableArray<NSArray *> *> *)upSelectStrArr {
    if (!_upSelectStrArr) {
        _upSelectStrArr = [NSMutableArray array];
        for (int i = 0; i<self.unitPriceArr.count; i++) {
            [_upSelectStrArr addObject:[NSMutableArray array]];
            for (int j = 0; j<self.unitPriceArr[i].count; j++) {
                [_upSelectStrArr[i] addObject:[NSMutableArray array]];
            }
        }
    }
    return _upSelectStrArr;
}

- (NSArray<NSString *> *)repaymentMethods {
    if (!_repaymentMethods) {
        _repaymentMethods = @[@"等额本息", @"等额本金"];
    }
    return _repaymentMethods;
}

- (NSArray<NSString *> *)calculateMethods {
    if (!_calculateMethods) {
        _calculateMethods = @[@"总价", @"单价和面积"];
    }
    return _calculateMethods;
}

- (NSArray<NSString *> *)mortgageYears {
    if (!_mortgageYears) {
        NSMutableArray<NSString *> *mortgageYears = [NSMutableArray array];
        for (int i = 30; i>=1; i--) {
            NSString *year = [NSString stringWithFormat:@"%d年(%d个月)", i, i*12];
            [mortgageYears addObject:year];
        }
        _mortgageYears = mortgageYears;
    }
    return _mortgageYears;
}

- (NSArray<NSString *> *)mortgageMultis {
    if (!_mortgageMultis) {
        NSMutableArray<NSString *> *mortgageMultis = [NSMutableArray array];
        for (int i = 1; i<=9; i++) {
            NSString *multi = [NSString stringWithFormat:@"%d成", i];
            [mortgageMultis addObject:multi];
        }
        _mortgageMultis = mortgageMultis;
    }
    return _mortgageMultis;
}


#pragma mark - 待子类重写
- (NSArray<NSArray<NSString *> *> *)getTotalPriceArr {
    return @[
             @[@"还款方式"],
             @[@"计算方式",@"贷款总额",@"按揭年数",@"银行利率"]
             ];
}
- (NSArray<NSArray<NSString *> *> *)getUnitPriceArr {
    return @[
             @[@"还款方式"],
             @[@"计算方式",@"单价",@"面积",@"按揭年数",@"按揭成数",@"银行利率"]
             ];
}
- (NSInteger)getHRCalculatorCalcType {
    return HRCalculatorCalcTypeBusiness;
}
// 处理选项数组数据专用
- (void)handleSelectStr:(NSString *)selectStr indexPath:(NSIndexPath *)indexPath buttonIndex:(NSInteger)buttonIndex {
}
// 处理输入数据专用
- (void)handleInputStr:(NSString *)inputStr indexPath:(NSIndexPath *)indexPath {
}

// 防止reloadData后textField变空
- (double)getInputValueWithIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
@end
