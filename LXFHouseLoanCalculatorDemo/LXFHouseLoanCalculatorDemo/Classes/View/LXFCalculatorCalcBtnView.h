//
//  LXFCalculatorCalcBtnView.h
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXFCalculatorCalcBtnView : UIView

/** 开始计算Block */
@property (nonatomic, copy) void (^startCalcBlock)();

+ (CGFloat)viewHeight;

@end
