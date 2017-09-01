//
//  LXFCalcInputCell.h
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXFCalcInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

/** 输入回调 */
@property (nonatomic, copy) void (^inputBlock)(NSString *text);

@end
