//
//  RYLabel.m
//  Ryuk
//
//  Created by RongqingWang on 2017/5/12.
//  Copyright © 2017年 RyukieSama. All rights reserved.
//

#import "RYLabel.h"
#import "RYTextUnit.h"

/**
 首先是这些非英文字符的编码范围：
 
 这里是几个主要非英文语系字符范围
 
 2E80～33FFh：中日韩符号区。收容康熙字典部首、中日韩辅助部首、注音符号、日本假名、韩文音符，中日韩的符号、标点、带圈或带括符文数字、月份，以及日本的假名组合、单位、年号、月份、日期、时间等。
 
 3400～4DFFh：中日韩认同表意文字扩充A区，总计收容6,582个中日韩汉字。
 
 4E00～9FFFh：中日韩认同表意文字区，总计收容20,902个中日韩汉字。
 
 A000～A4FFh：彝族文字区，收容中国南方彝族文字和字根。
 
 AC00～D7FFh：韩文拼音组合字区，收容以韩文音符拼成的文字。
 
 F900～FAFFh：中日韩兼容表意文字区，总计收容302个中日韩汉字。
 
 FB00～FFFDh：文字表现形式区，收容组合拉丁文字、希伯来文、阿拉伯文、中日韩直式标点、小符号、半角符号、全角符号等。
 
 比如需要匹配所有中日韩非符号字符,那么正则表达式应该是^[\u3400-\u9FFF]+$
 理论上没错, 可是我到msn.co.ko随便复制了个韩文下来, 发现根本不对, 诡异
 再到msn.co.jp复制了个'お', 也不得行..
 
 然后把范围扩大到^[\u2E80-\u9FFF]+$, 这样倒是都通过了, 这个应该就是匹配中日韩文字的正则表达式了, 包括我們臺灣省還在盲目使用的繁體中文
 
 而关于中文的正则表达式, 应该是^[\u4E00-\u9FFF]+$, 和论坛里常被人提起的^[\u4E00-\u9FA5]+$很接近
 
 需要注意的是论坛里说的^[\u4E00-\u9FA5]+$这是专门用于匹配简体中文的正则表达式, 实际上繁体字也在里面, 我用测试器测试了下'中華人民共和國', 也通过了, 当然, ^[\u4E00-\u9FFF]+$也是一样的结果
 
 然后上面的^[\u4E00-\u9FA5]+$形式的正则表达式php是不支持的。在stackoverflow上可以找到如下解决方案：
 
 
 2. UTF-8 (Unicode)
 /u4e00-/u9fa5 (中文)
 /x3130-/x318F (韩文
 /xAC00-/xD7A3 (韩文)
 /u0800-/u4e00 (日文)
 ps: 韩文是大于[/u9fa5]的字符
 
 
 正则例子:
 preg_replace("/([/x80-/xff])/","",$str);
 preg_replace("/([u4e00-u9fa5])/","",$str);
 */

static NSString *urlPre = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%=]*)?";
static NSString *atPre = @"@[0-9a-zA-Z\\u2E80-\\u9FFF-_]+";
static NSString *sharpPre = @"#[0-9a-zA-Z\\u2E80-\\u9FFF-_/]+#";
static NSString *emojiPre = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";

@interface RYLabel ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <RYTextUnit *>*arrUnints;

@end

@implementation RYLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizers];
    return self;
}

- (void)addEvent {

}

- (void)setText:(NSString *)text {
    NSMutableString *muStr = text.mutableCopy;
//    [muStr appendString:@"\n"];
    [super setText:muStr];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:muStr];
    self.attributedText = attStr;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self clearText];
    NSMutableAttributedString *muAtt = attributedText.mutableCopy;
    
    [muAtt setAttributes:@{
                           NSFontAttributeName : self.font
                           }
                   range:NSMakeRange(0, attributedText.length)];
    
    //遍历文本中的元素
    for (RYTextUnit *unit in self.arrUnints) {
        if (unit.type == RYTextUnitTypeEmoji) {
            continue;
        }
        [muAtt setAttributes:@{
                               NSForegroundColorAttributeName:[UIColor cyanColor],
                               NSFontAttributeName : self.font
                               }
                       range:unit.range];
    }
    
    [super setAttributedText:muAtt];
}

- (void)clearText {
    self.arrUnints = nil;
}

#pragma mark - function
- (void)atClick {
    
}

- (void)webClick {
    
}

#pragma mark - lazy
- (NSMutableArray<RYTextUnit *> *)arrUnints {
    if (!_arrUnints) {
        _arrUnints = @[].mutableCopy;
        [_arrUnints addObjectsFromArray:[self validateLink:self.text]];
        [_arrUnints addObjectsFromArray:[self validateAt:self.text]];
        [_arrUnints addObjectsFromArray:[self validateSharp:self.text]];
        [_arrUnints addObjectsFromArray:[self validateEmoji:self.text]];
    }
    return _arrUnints;
}

//华丽丽的手动正则...TAT
//- (NSMutableArray *)arrAts {
//    if (!_arrAts) {
//        _arrAts = [self validateAt:self.text].mutableCopy;
//        
//        //先看有没有 @
////        if ([self.text containsString:@"@"]) {
////            NSString *newStr = self.text;
////            NSString *temp = nil;
////            NSMutableString *muStr = [[NSMutableString alloc] init];
////            BOOL appendSwitch = NO; //拼接开关
////            NSInteger startRange = 0;
////            NSInteger endRange = 0;
////            
////            for(int i =0; i < [newStr length]; i++) {
////                temp = [newStr substringWithRange:NSMakeRange(i, 1)];
////                if (appendSwitch && ![temp isEqualToString:@" "] && ![temp isEqualToString:@":"] && ![temp isEqualToString:@"："] && ((i+1) != [newStr length])) {
////                    [muStr appendString:temp];
////                } else {
////                    if ([temp isEqualToString:@"@"]) {
////                        appendSwitch = YES;
////                        [muStr appendString:temp];
////                        startRange = i;
////                    } else if (appendSwitch && ([temp isEqualToString:@" "] || ((i+1) == [newStr length]) || [temp isEqualToString:@":"] || [temp isEqualToString:@"："])) {
////                        endRange = i;
////                        
////                        if ((i+1) == [newStr length]) {
////                            [muStr appendString:temp];
////                            endRange = i+1;
////                        }
////                        
////                        RYTextUnit *unit = [[RYTextUnit alloc] init];
////                        unit.content = muStr;
////                        unit.range = NSMakeRange(startRange, endRange - startRange);
////                        unit.type = RYTextUnitTypeAt;
////                        [_arrAts addObject:unit];
////                        
////                        //还原
////                        muStr = [[NSMutableString alloc] init];
////                        appendSwitch = NO;
////                        startRange = 0;
////                        endRange = 0;
////                    }
////                }
////            }
////        }
//        
////        NSArray *arr = [self validateAt:self.text];
////        if (arr.count > 0) {
////            for (NSString *str in arr) {
////                RYTextUnit *unit = [[RYTextUnit alloc] init];
////                unit.content = str;
////                unit.range = [self.text rangeOfString:str];
////                unit.type = RYTextUnitTypeAt;
////                [_arrAts addObject:unit];
////            }
////        }
//        
//    }
//    return _arrAts;
//}

#pragma mark - touch
// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
- (CFIndex)touchContentOffsetInViewAtPoint:(CGPoint)point {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.text length]), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }

    NSInteger length = self.text.length;
    
    if (idx < length) {
        NSLog(@"点击位置:%ld ```````````````    字符为:%@",idx,[self.text substringWithRange:NSMakeRange(idx, 1)]);
    } else {
        NSLog(@"越界了");
    }
    
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(path);
    return idx;
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

- (void)touchEventAtIndex:(CFIndex)index {
    //找出在这个额位置的Unit
    for (RYTextUnit *unit in self.arrUnints) {
        if ((index >= unit.range.location) && (index <= unit.range.location + unit.range.length)) {
            if (self.textClick) {
                self.textClick(unit);
            }
        }
    }
}

#pragma mark - Gesture recognizers
- (void)addGestureRecognizers {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapping:)];
    [singleTap setDelegate:self];
    [self addGestureRecognizer:singleTap];
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - Handle tappings
- (void)handleTapping:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    [self touchEventAtIndex:[self touchContentOffsetInViewAtPoint:point]];
}

#pragma mark - predicate
- (NSArray <RYTextUnit *>*)validateLink:(NSString *)link {
    NSMutableArray *arr = @[].mutableCopy;
    // | 匹配多个条件,相当于or\或
    NSString *pattern = [NSString stringWithFormat:@"%@",urlPre];
    // 使用系统的正则类来遍历
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:link options:0 range:NSMakeRange(0, link.length)];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        RYTextUnit *unit = [[RYTextUnit alloc] init];
        unit.content = [link substringWithRange:result.range];
        unit.range = result.range;
        unit.type = RYTextUnitTypeURL;
        [arr addObject:unit];
    }
    return arr.copy;
}

- (NSArray <RYTextUnit *>*)validateAt:(NSString *)at {
    NSMutableArray *arr = @[].mutableCopy;
    // | 匹配多个条件,相当于or\或
    NSString *pattern = [NSString stringWithFormat:@"%@",atPre];
    // 使用系统的正则类来遍历
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:at options:0 range:NSMakeRange(0, at.length)];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        RYTextUnit *unit = [[RYTextUnit alloc] init];
        unit.content = [at substringWithRange:result.range];
        unit.range = result.range;
        unit.type = RYTextUnitTypeAt;
        [arr addObject:unit];
    }
    return arr.copy;
}

- (NSArray <RYTextUnit *>*)validateSharp:(NSString *)sharp {
    NSMutableArray *arr = @[].mutableCopy;
    // | 匹配多个条件,相当于or\或
    NSString *pattern = [NSString stringWithFormat:@"%@",sharpPre];
    // 使用系统的正则类来遍历
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:sharp options:0 range:NSMakeRange(0, sharp.length)];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        RYTextUnit *unit = [[RYTextUnit alloc] init];
        unit.content = [sharp substringWithRange:result.range];
        unit.range = result.range;
        unit.type = RYTextUnitTypeSharp;
        [arr addObject:unit];
    }
    return arr.copy;
}

- (NSArray <RYTextUnit *>*)validateEmoji:(NSString *)emoji {
    NSMutableArray *arr = @[].mutableCopy;
    // | 匹配多个条件,相当于or\或
    NSString *pattern = [NSString stringWithFormat:@"%@",emojiPre];
    // 使用系统的正则类来遍历
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:emoji options:0 range:NSMakeRange(0, emoji.length)];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        RYTextUnit *unit = [[RYTextUnit alloc] init];
        unit.content = [emoji substringWithRange:result.range];
        unit.range = result.range;
        unit.type = RYTextUnitTypeEmoji;
        [arr addObject:unit];
    }
    return arr.copy;
}

@end
