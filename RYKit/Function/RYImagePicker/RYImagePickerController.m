//
//  RYImagePickerController.m
//  RYimagePickerDemo
//
//  Created by RongqingWang on 16/5/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYImagePickerController.h"
#import "RYImagePicker.h"

@interface RYImagePickerController ()

@end

@implementation RYImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.168  green:0.177  blue:0.215 alpha:1];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
}

- (void)dealloc {
    NSLog(@"- [%@ dealloc]",[self class]);
}

@end
