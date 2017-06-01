//
//  RYLabel.h
//  Ryuk
//
//  Created by RongqingWang on 2017/5/12.
//  Copyright © 2017年 RyukieSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "RYTextUnit.h"

typedef void(^textClickHandler)(RYTextUnit *unit);

@interface RYLabel : UILabel

@property (nonatomic, copy) textClickHandler textClick;

@end
