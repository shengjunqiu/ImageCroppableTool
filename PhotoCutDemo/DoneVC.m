//
//  DoneVC.m
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2017/1/3.
//  Copyright © 2017年 邱圣军. All rights reserved.
//

#import "DoneVC.h"
#import "QSJCroppableView.h"

@interface DoneVC ()

@end

@implementation DoneVC
{
    UIImageView *imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, self.view.frame.size.height-50)];
    imageView.center = self.view.center;
    [imageView setImage:self.cutImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //开启交互
    imageView.userInteractionEnabled = YES;
    
    [self addGesture];
    [self.view addSubview:imageView];

}

//添加手势
- (void)addGesture
{
    //添加捏合手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    //添加旋转手势
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    //添加拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [imageView addGestureRecognizer:panGesture];
    
    
}

//捏合手势操作
- (void)pinchImage:(UIPinchGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged)
    {
        imageView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    }
//    else if (gesture.state == UIGestureRecognizerStateEnded)
//    {
//        [UIView animateWithDuration:.5 animations:^{
//            imageView.transform = CGAffineTransformIdentity;
//        }];
//    }
}

//旋转手势操作
- (void)rotateImage:(UIRotationGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged)
    {
        imageView.transform = CGAffineTransformMakeRotation(gesture.rotation);
    }
//    else if (gesture.state == UIGestureRecognizerStateEnded)
//    {
//        [UIView animateWithDuration:.8 animations:^{
//            imageView.transform = CGAffineTransformIdentity;
//        }];
//    }

}

//拖动手势操作
- (void)panImage:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint traslation = [gesture translationInView:self.view];
        imageView.transform = CGAffineTransformMakeTranslation(traslation.x, traslation.y);
    }
//    else if (gesture.state == UIGestureRecognizerStateEnded)
//    {
//        imageView.transform = CGAffineTransformIdentity;
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
