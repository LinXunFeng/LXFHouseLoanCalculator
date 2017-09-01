//
//  LXFCalculatorCalcBtnView.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalculatorCalcBtnView.h"

@implementation LXFCalculatorCalcBtnView
- (IBAction)startCalc {
    NSLog(@"开始计算");
    if (self.startCalcBlock) {
        self.startCalcBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (CGFloat)viewHeight {
    return 100;
}

@end
