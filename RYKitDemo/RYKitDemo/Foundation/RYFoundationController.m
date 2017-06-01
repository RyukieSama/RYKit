//
//  RYFoundationController.m
//  RYKitDemo
//
//  Created by RongqingWang on 16/12/1.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYFoundationController.h"

@interface RYFoundationController ()

@end

@implementation RYFoundationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Foundation";
    self.arrList = @[
                     @"NSString"
                     ];
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
