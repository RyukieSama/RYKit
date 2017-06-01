//
//  RYTextUnit.h
//  Ryuk
//
//  Created by RongqingWang on 2017/5/12.
//  Copyright © 2017年 RyukieSama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RYTextUnitType) {
    RYTextUnitTypeURL = 11,
    RYTextUnitTypeAt = 12,
    RYTextUnitTypeEmoji = 13,
    RYTextUnitTypeSharp = 14
};

@interface RYTextUnit : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) RYTextUnitType type;

@end
