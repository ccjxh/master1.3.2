//
//  logoViewController.m
//  master
//
//  Created by jin on 15/10/26.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "logoViewController.h"

@interface logoViewController ()

@end

@implementation logoViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha=0;

}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
}



-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha=1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
