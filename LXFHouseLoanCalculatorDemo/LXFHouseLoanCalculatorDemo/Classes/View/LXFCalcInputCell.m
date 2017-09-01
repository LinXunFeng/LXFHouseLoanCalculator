//
//  LXFCalcInputCell.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "LXFCalcInputCell.h"

@implementation LXFCalcInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.valueLabel addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textField1TextChange:(UITextField *)textField{
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

@end
