//
//  LXFPopResultView.h
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFHouseLoanCalculator.h"

@interface LXFPopResultView : UIView
//弹出
- (void)pop;
//消失
- (void)dismiss;

/** resultModel */
@property (nonatomic, strong) LXFHouseLoanResultModel *model;
/** 计算方式是否为总价 */
@property (nonatomic, assign) BOOL isCalcMethodTotalPrice;

@end
