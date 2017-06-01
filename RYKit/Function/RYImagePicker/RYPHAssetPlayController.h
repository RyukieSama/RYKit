//
//  RYPHAssetPlayController.h
//  RYimagePickerDemo
//
//  Created by RongqingWang on 16/5/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "RYImageScrollView.h"
#import "RYGridCellModel.h"

@interface RYPHAssetPlayController : UIViewController

@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) RYGridCellModel *cellModel;

+ (RYPHAssetPlayController *)assetItemViewControllerForCellModel:(RYGridCellModel *)cellModel;

@end
