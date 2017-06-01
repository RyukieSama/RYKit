//
//  RYFunctionController.m
//  RYKitDemo
//
//  Created by RongqingWang on 16/12/1.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYFunctionController.h"

@interface RYFunctionController ()

@end

@implementation RYFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Function";
    self.arrList = @[
                     @"RYImagePicker",
                     @"RYImageBrowser"
                     ];
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
