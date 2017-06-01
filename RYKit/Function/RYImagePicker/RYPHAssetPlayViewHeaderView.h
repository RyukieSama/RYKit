//
//  RYPHAssetPlayViewHeaderView.h
//  RYimagePickerDemo
//
//  Created by RongqingWang on 16/5/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYImagePicker.h"

typedef void(^RYPlayHeaderHandler)(id obj);

@interface RYPHAssetPlayViewHeaderView : UIView

/**
 序号/总数
 */
@property (nonatomic, strong) UILabel *lbIndex;
@property (nonatomic, copy) RYPlayHeaderHandler handlerBack;
@property (nonatomic, copy) RYPlayHeaderHandler handlerSelect;

- (void)setIndex:(NSInteger)index countAll:(NSInteger)countAll countSelected:(NSInteger)countSelected;

@end
