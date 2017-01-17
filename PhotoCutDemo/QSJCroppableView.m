//
//  QSJCroppableView.m
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2016/12/30.
//  Copyright © 2016年 邱圣军. All rights reserved.
//

#import "QSJCroppableView.h"
#import "UIBezierPath+QSJPoint.h"
#import "UIBezierPath+QSJ3DPoint.h"
#import "QSJPointView.h"


@implementation QSJCroppableView
{
    UIBezierPath *curve;
    NSMutableArray *pointViewArray;
    CAShapeLayer *shapeLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self) {
        self.lineWidth = 13.0;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.croppingPath = [[UIBezierPath alloc] init];
        [self.croppingPath setLineWidth:self.lineWidth];
        self.lineColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    }
    return self;
}

+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    float y = (rect2.size.height - scaledSize.height)/2;
    
    return CGRectMake(0, y, scaledSize.width, scaledSize.height);
}

+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x * rect2.width) / rect1.width, (point1.y * rect2.height) / rect1.height);
    return result;
}

+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x * rect2.width) / rect1.width, (point1.y * rect2.height) / rect1.height);
    return result;
}

- (void)drawRect:(CGRect)rect
{
    [self.lineColor setStroke];
    [self.croppingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0f];
}

- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image
{
    NSArray *points = [self.croppingPath points];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    UIBezierPath *aPath;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        aPath = [UIBezierPath bezierPath];
        
        //Set the starting point of the shape.
        CGPoint p1 = [QSJCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
//        for (uint i = 1; i<points.count; i++)
//        {
//            CGPoint p = [QSJCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//        }
        
        NSMutableArray *croppablePointArray = [[NSMutableArray alloc] init];
        
        for (uint i = 1; i<points.count; i++)
        {
            CGPoint p = [QSJCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
            
            [croppablePointArray addObject:[NSValue valueWithCGPoint:p]];
        }
        
        NSLog(@"%@",croppablePointArray);
        
        [aPath addBezierThroughPoints:croppablePointArray];
        
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect croppedRect = aPath.bounds;
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);
    
    CGFloat screentScale = [UIScreen mainScreen].scale;
    
    croppedRect.origin.x = croppedRect.origin.x*screentScale;
    croppedRect.origin.y = croppedRect.origin.y*screentScale;
    croppedRect.size.width = croppedRect.size.width*screentScale;
    croppedRect.size.height = croppedRect.size.height*screentScale;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    imageRef = NULL;
    
    return maskedImage;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath moveToPoint:[mytouch locationInView:self]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    curve = [[UIBezierPath alloc] init];
    shapeLayer = [CAShapeLayer layer];

    UIBezierPath *plusCurve = [[UIBezierPath alloc] init];
    CAShapeLayer *plusShapeLayer = [CAShapeLayer layer];
    
    NSValue *firstPointValue = [self pointInBezierPath].firstObject;
    NSValue *lastPointValue = [self pointInBezierPath].lastObject;
    
    NSArray *plusPointArray = [NSArray arrayWithObjects:firstPointValue,lastPointValue,nil];
    NSLog(@"%@",plusPointArray);
    
    [curve moveToPoint:firstPointValue.CGPointValue];
    [curve addBezierThroughPoints:[self pointInBezierPath]];
    
    [plusCurve moveToPoint:lastPointValue.CGPointValue];
    [plusCurve addBezierThroughPoints:plusPointArray];
    
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 9.0;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    
    plusShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    plusShapeLayer.fillColor = nil;
    plusShapeLayer.lineWidth = 9.0;
    plusShapeLayer.path = plusCurve.CGPath;
    plusShapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:plusShapeLayer];
    
    [self setUserInteractionEnabled:NO];
}

- (NSArray *)pointInBezierPath
{
    self.pointArray = self.croppingPath.points;
    self.keepPointArray = [NSMutableArray arrayWithArray:self.pointArray];
    NSMutableArray *finalPointArray = [NSMutableArray array];
    
    for(int i = 0;i<self.keepPointArray.count;i++)
    {
        if(i%2 == 0)
        {
            [finalPointArray addObject:[self.keepPointArray objectAtIndex:i]];
        }
    }
    
    return finalPointArray;
}

@end
