//
//  QSJPointView.m
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2017/1/15.
//  Copyright © 2017年 邱圣军. All rights reserved.
//

#import "QSJPointView.h"

static CGFloat const RADIUS = 10;

@implementation QSJPointView

+ (QSJPointView *)aInstance
{
    QSJPointView *aInstance = [[self alloc]initWithFrame:(CGRect){CGPointZero,CGSizeMake(RADIUS * 2, RADIUS * 2)}];
    aInstance.layer.cornerRadius = RADIUS;
    aInstance.layer.masksToBounds = YES;
    aInstance.backgroundColor = [UIColor blueColor];
    
    return aInstance;
}

- (void)touchDragInside:(QSJPointView *)pointView withEvent:(UIEvent *)event
{
    pointView.center = [[[event allTouches]anyObject] locationInView:self.superview];
    
    if (self.dragCallBack) {
        self.dragCallBack(self);
    }
}



@end
