//
//  guideViewController.m
//  master
//
//  Created by jin on 15/8/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "guideViewController.h"
#import "AppDelegate.h"
#import "appInitManager.h"
#define kScreenBounds [UIScreen mainScreen].bounds

@interface guideViewController ()

@end

@implementation guideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setGuide];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setGuide{
    UIScrollView*scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.bounces=NO;
    scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT);
    NSArray*picArray=@[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
     NSArray*sliderArray=@[@"进度条1",@"进度条2",@"进度条3",@"进度条4"];
    for (NSInteger i=0; i<picArray.count; i++) {
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageview.image=[UIImage imageNamed:picArray[i]];
        imageview.userInteractionEnabled=YES;
        UIImageView*sliderImageview=[[UIImageView alloc]initWithFrame:CGRectMake(imageview.frame.size.width/2-30, SCREEN_HEIGHT-40, 60, 8)];
        sliderImageview.image=[UIImage imageNamed:sliderArray[i]];
        [imageview addSubview:sliderImageview];
        if (i==3) {
            
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(imageview.frame.size.width/2-60, SCREEN_HEIGHT-110, 120, 35)];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:COLOR(155, 232, 255, 1) forState:UIControlStateNormal];
            button.layer.borderColor=COLOR(155, 232, 255, 1).CGColor;
            button.layer.borderWidth=2;
            button.layer.cornerRadius=15;
            button.titleLabel.font=[UIFont systemFontOfSize:18];
            [button addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:button];
        }
        scrollview.userInteractionEnabled=YES;
        [scrollview addSubview:imageview];
    }
    scrollview.pagingEnabled=YES;
    [self.view addSubview:scrollview];
   
}


-(void)open{

    [[appInitManager share]setupLoginView];

}


@end
