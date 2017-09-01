//
//  LXFCalculateResultModel.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalculateResultModel.h"

@implementation LXFCalculateResultModel

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (UIColor *)valueColor {
    if (!_valueColor) {
        _valueColor = [UIColor darkGrayColor];
    }
    return _valueColor;
}

@end
