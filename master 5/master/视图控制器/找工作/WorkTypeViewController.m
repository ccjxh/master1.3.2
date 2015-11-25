//
//  WorkTypeViewController.m
//  master
//
//  Created by jin on 15/11/2.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "WorkTypeViewController.h"

@interface WorkTypeViewController ()

@end

@implementation WorkTypeViewController
{
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor=[UIColor whiteColor];
    self.tableview.tableFooterView=view;
    
}
@end
