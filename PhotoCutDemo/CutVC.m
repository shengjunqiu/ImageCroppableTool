//
//  CutVC.m
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2017/1/3.
//  Copyright © 2017年 邱圣军. All rights reserved.
//

#import "CutVC.h"
#import "QSJCroppableView.h"
#import "DoneVC.h"

@interface CutVC ()
{
    QSJCroppableView *qsjCroppableView;
    UIImageView *cuttingImage;
}

@end

@implementation CutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"PhotoCutDemo";
    
    UIBarButtonItem *cutBtn = [[UIBarButtonItem alloc] initWithTitle:@"CUT" style:UIBarButtonItemStylePlain target:self action:@selector(btnCut)];
    self.navigationItem.rightBarButtonItem = cutBtn;
    
    UIBarButtonItem *resetBtn = [[UIBarButtonItem alloc] initWithTitle:@"RESET" style:UIBarButtonItemStylePlain target:self action:@selector(btnReset)];
    self.navigationItem.leftBarButtonItem = resetBtn;
    
    cuttingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [cuttingImage setImage:[UIImage imageNamed:@"cat"]];
    [self.view addSubview:cuttingImage];
    
    CGRect rect1 = CGRectMake(0, 0, cuttingImage.image.size.width, cuttingImage.image.size.height);
    CGRect rect2 = cuttingImage.frame;
    [cuttingImage setFrame:[QSJCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
    
    [self setUpQSJCroppableView];
    
}

- (void)setUpQSJCroppableView
{
    [qsjCroppableView removeFromSuperview];
    qsjCroppableView = [[QSJCroppableView alloc] initWithImageView:cuttingImage];
    [self.view addSubview:qsjCroppableView];
}

- (void)btnCut
{
    UIImage *croppedImage = [qsjCroppableView deleteBackgroundOfImage:cuttingImage];
    DoneVC *doneVC = [[DoneVC alloc] init];
    [doneVC setCutImage:croppedImage];
    [self.navigationController pushViewController:doneVC animated:YES];
}

- (void)btnReset
{
    [self setUpQSJCroppableView];
}

- (void)didReceiveMemoryWarning {
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
