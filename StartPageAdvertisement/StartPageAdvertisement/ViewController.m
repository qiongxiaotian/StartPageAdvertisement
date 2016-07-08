//
//  ViewController.m
//  StartPageAdvertisement
//
//  Created by heivr.mxy on 16/7/8.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import "ViewController.h"
#import "AdvertiseViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    self.view.backgroundColor = [UIColor redColor];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
}

- (void)pushToAd {
    
    AdvertiseViewController *adVc = [[AdvertiseViewController alloc] init];
    [self.navigationController pushViewController:adVc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
