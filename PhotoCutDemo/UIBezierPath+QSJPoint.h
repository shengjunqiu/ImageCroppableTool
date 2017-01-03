//
//  UIBezierPath+QSJPoint.h
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2016/12/30.
//  Copyright © 2016年 邱圣军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (QSJPoint)

@property (nonatomic,readonly) NSArray *points;
@property (nonatomic,readonly) NSArray *bezierElements;
@property (nonatomic,readonly) CGFloat length;

- (NSArray *)pointPercentArray;
- (CGPoint)pointAtPercent:(CGFloat)percent withSlope:(CGPoint *)slope;
+ (UIBezierPath *)pathWithPoints:(NSArray *)points;
+ (UIBezierPath *)pathWithElements:(NSArray *)elements;

@end
