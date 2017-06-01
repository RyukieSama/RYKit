//
//  RYImageScrollView.h
//  RYimagePickerDemo
//
//  Created by RongqingWang on 16/5/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "RYGridCellModel.h"

extern NSString * const RYAssetScrollViewDidTapNotification;
extern NSString * const RYAssetScrollViewPlayerWillPlayNotification;
extern NSString * const RYAssetScrollViewPlayerWillPauseNotification;

@interface RYImageScrollView : UIScrollView

@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) RYGridCellModel *cellModel;

- (void)bind:(PHAsset *)asset image:(UIImage *)image requestInfo:(NSDictionary *)info;

@end
