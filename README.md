# LXFHouseLoanCalculator
iOS - 房贷计算器



## Usage

商业贷款

```objective-c
#pragma mark 按商业贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;

#pragma mark 按商业贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;

#pragma mark 按商业贷款等额本息单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;

#pragma mark 按商业贷款等额本金单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
```



公积金贷款

```objective-c
#pragma mark 按公积金贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
#pragma mark 按公积金贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
#pragma mark 按公积金贷款等额本息单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
#pragma mark 按公积金贷款等额本金单价计算(单价和面积)
+ (LXFHouseLoanResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
```



组合型贷款

```objective-c
#pragma mark 按组合型贷款等额本息总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
#pragma mark 按组合型贷款等额本金总价计算(总价)
+ (LXFHouseLoanResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(LXFHouseLoanCalcModel *)calcModel;
```



## Exhibition



![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/1.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/2.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/3.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/4.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/5.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/6.png)

![image](https://github.com/LinXunFeng/LXFHouseLoanCalculator/raw/master/Screenshots/7.png)

