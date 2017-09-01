//
//  LXFPopResultCell.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFPopResultCell.h"
#import "LXFCalculateResultModel.h"

@interface LXFPopResultCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation LXFPopResultCell

- (void)setModel:(LXFCalculateResultModel *)model {
    _model = model;
    self.title.text = model.title;
    self.value.text = model.value;
    self.title.textColor = model.titleColor;
    self.value.textColor = model.valueColor;
}

@end
