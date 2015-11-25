//
//  ExampleViewController.m
//  master
//
//  Created by jin on 15/11/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type==8) {
        self.imageHeight.constant=75;
    }
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.photosImage.image=[UIImage imageNamed:self.imageName];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
