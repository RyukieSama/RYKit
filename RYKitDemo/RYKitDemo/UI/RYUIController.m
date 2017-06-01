//
//  RYUIController.m
//  RYKitDemo
//
//  Created by RongqingWang on 16/12/1.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYUIController.h"

@interface RYUIController ()

@end

@implementation RYUIController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI";
    self.arrList = @[
                     @"UITextField"
                     ];
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
