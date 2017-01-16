//
//  QSJCroppableView.h
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2016/12/30.
//  Copyright © 2016年 邱圣军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSJCroppableView : UIView

@property (nonatomic,strong) UIBezierPath *croppingPath;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) float lineWidth;

@property (nonatomic,copy) NSArray *pointArray;
@property (nonatomic,copy) NSMutableArray *keepPointArray;

- (id)initWithImageView:(UIImageView *)imageView;
+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2: (CGSize)rect2;
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2;
- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image;

@end
