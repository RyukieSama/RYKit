//
//  ViewController.m
//  RYKitDemo
//
//  Created by RongqingWang on 16/12/1.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "ViewController.h"
#import "RYFoundationController.h"
#import "RYUIController.h"
#import "RYFunctionController.h"

static NSString *cellId = @"cellId";

@interface ViewController ()

@property (nonatomic, strong) UITableView *tvTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RYKit";
    self.arrList = @[
                     @"UI_UI库",
                     @"Foundation_基础库",
                     @"Function_功能组件"
                     ];
    
    [self.view addSubview:self.tvTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = self.arrList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            RYUIController *vc = [[RYUIController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            RYFoundationController *vc = [[RYFoundationController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            RYFunctionController *vc = [[RYFunctionController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazyInit
- (UITableView *)tvTableView {
    if (!_tvTableView) {
        _tvTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tvTableView.delegate = self;
        _tvTableView.dataSource = self;
        [_tvTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    return _tvTableView;
}

@end
