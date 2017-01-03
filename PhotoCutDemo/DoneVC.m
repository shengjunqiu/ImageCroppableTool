//
//  DoneVC.m
//  PhotoCutDemo
//
//  Created by 邱圣军 on 2017/1/3.
//  Copyright © 2017年 邱圣军. All rights reserved.
//

#import "DoneVC.h"

@interface DoneVC ()

@end

@implementation DoneVC
{
    UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, self.view.frame.size.height-50)];
    imageView.center = self.view.center;
    [imageView setImage:self.cutImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageView];
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
