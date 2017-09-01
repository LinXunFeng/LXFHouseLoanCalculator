//
//  LXFCalculateResultModel.h
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXFCalculateResultModel : NSObject

/** title */
@property (nonatomic, copy) NSString *title;
/** value */
@property (nonatomic, copy) NSString *value;
/** titleColor */
@property (nonatomic, strong) UIColor *titleColor;
/** valueColor */
@property (nonatomic, strong) UIColor *valueColor;

@end
