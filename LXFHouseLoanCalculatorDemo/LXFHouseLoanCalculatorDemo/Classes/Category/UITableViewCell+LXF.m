//
//  UITableViewCell+LXF.m
//  LXFHouseLoanCalculatorDemo
//
//  Created by 林洵锋 on 2017/9/2.
//  Copyright © 2017年 LinXunFeng. All rights reserved.
//

#import "UITableViewCell+LXF.h"
#import "UIView+LXF.h"

@implementation UITableViewCell (LXF)

+ (instancetype)loadCellFromNib:(UITableView *)tableView{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell) {
        cell = [self viewFromXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
