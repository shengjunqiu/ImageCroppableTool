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

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

@implementation QSJCroppableView
{
    UIBezierPath *curve;
    CAShapeLayer *shapeLayer;
    NSValue *firstPointValue;
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
        self.lineWidth = 5.0;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.croppingPath = [[UIBezierPath alloc] init];
        [self.croppingPath setLineWidth:self.lineWidth];
        self.lineColor = [UIColor clearColor];
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
        
        CGPoint p1 = [QSJCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
        NSMutableArray *croppablePointArray = [[NSMutableArray alloc] init];
        
        for (uint i = 1; i<points.count; i++)
        {
            if(i%2 == 0)
            {
                CGPoint p = [QSJCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
                
                [croppablePointArray addObject:[NSValue valueWithCGPoint:p]];
            }
        }
        
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


#pragma mark----------TouchEvent----------
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
    
    curve = [[UIBezierPath alloc] init];
    shapeLayer = [CAShapeLayer layer];
    firstPointValue = [self pointInBezierPath].firstObject;
    [curve moveToPoint:firstPointValue.CGPointValue];
    [curve addBezierThroughPoints:[self pointInBezierPath]];
    shapeLayer.strokeColor = RGBColorC(0x0093ff).CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 5.0;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //图片蒙层
    CAShapeLayer *coverShapeLayer = [CAShapeLayer layer];
    coverShapeLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    UIBezierPath *otherPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    coverShapeLayer.path = otherPath.CGPath;
    [otherPath appendPath:curve];
    coverShapeLayer.path = otherPath.CGPath;
    coverShapeLayer.fillRule = kCAFillRuleEvenOdd;
    
    [self.layer addSublayer:coverShapeLayer];
    
    //最终路径
    [self.layer addSublayer:shapeLayer];
    
    //最终补全路径
    UIBezierPath *finalPlusCurve = [[UIBezierPath alloc] init];
    CAShapeLayer *finalPlusLayer = [CAShapeLayer layer];
    NSValue *lastPointValue = [self pointInBezierPath].lastObject;
    NSMutableArray *plusPointArray = [NSMutableArray arrayWithObjects:firstPointValue,lastPointValue,nil];
    [finalPlusCurve moveToPoint:lastPointValue.CGPointValue];
    [finalPlusCurve addBezierThroughPoints:plusPointArray];
    
    finalPlusLayer.strokeColor = RGBColorC(0x0093ff).CGColor;
    finalPlusLayer.fillColor = nil;
    finalPlusLayer.lineWidth = 5.0;
    finalPlusLayer.path = finalPlusCurve.CGPath;
    finalPlusLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:finalPlusLayer];

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
