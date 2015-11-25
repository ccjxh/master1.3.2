//
//  MyCaseSelectedViewController.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "MyCaseSelectedViewController.h"
#import "StarCaseViewController.h"
#import "projectCaseAddViewController.h"
@interface MyCaseSelectedViewController ()

@end

@implementation MyCaseSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableview.backgroundColor=COLOR(229, 230, 231, 1);
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=self.tableview.backgroundColor;
    self.tableview.tableFooterView=view;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray*array=@[@"明星工程",@"普通工程"];
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=array[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        
        StarCaseViewController*svc=[[StarCaseViewController alloc]initWithNibName:@"StarCaseViewController" bundle:nil];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backButtonItem;
        svc.Editable=YES;
        [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
        cell.selectionStyle=0;
        return;
    }else{
    
     projectCaseAddViewController*pvc=[[projectCaseAddViewController alloc]init];
     pvc.caseType=2;
     UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
     backButtonItem.title = @"返回";
     self.navigationItem.backBarButtonItem = backButtonItem;
     [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
     cell.selectionStyle=0;
    
    }


}
@end
