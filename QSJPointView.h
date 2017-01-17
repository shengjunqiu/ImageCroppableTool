//
//  QSJPointView.h
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2017/1/15.
//  Copyright © 2017年 邱圣军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSJPointView : UIControl

+ (QSJPointView *)aInstance;

@property (nonatomic,copy) void (^dragCallBack)(QSJPointView * pointView);

@end
