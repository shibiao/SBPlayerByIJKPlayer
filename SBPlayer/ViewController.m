//
//  ViewController.m
//  SBPlayer
//
//  Created by sycf_ios on 2017/8/21.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "ViewController.h"
#import "SBPlayerViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SBPlayerViewController *sbVC = [[SBPlayerViewController alloc]init];
    sbVC.view.frame = CGRectMake(0, 20, kScreenWidth, 250);
    [self.view addSubview:sbVC.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
