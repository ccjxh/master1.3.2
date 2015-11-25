//
//  SetViewController.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "SetViewController.h"
#import "HelpAndFeedbackViewController.h" //帮助与反馈界面
#import "AboutViewController.h" //关于界面
#import "XGPush.h"
#import "logoViewController.h"
#import "passwordViewController.h"
@interface SetViewController ()<UIAlertViewDelegate>
{
    NSArray *setArr;
    CGFloat _memberSize;//缓存大小
}
@end

@implementation SetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    self.setTableView.scrollEnabled = NO; //设置tableview不被滑动
    setArr = @[@"帮助",@"密码修改",@"反馈",@"清除缓存",@"为宝师傅评分",@"宝师傅封面",@"关于"];
    CGFloat size=[[SDImageCache sharedImageCache] getSize];
    _memberSize = size / 1024.0 / 1024.0;
    [self CreateFlow];
}

- (IBAction)logoutButton:(id)sender
{
    [self flowShow];
    
    NSString *urlString = [self interfaceFromString:interface_loginout];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        
        NSDictionary *dict = (NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200)
        {
            [self.view makeToast:@"恭喜!退出成功。" duration:2.0f position:@"center"];
            [XGPush unRegisterDevice];
            [[loginManager share] loginOut];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return setArr.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"111"];
    }
    cell.textLabel.text = setArr[indexPath.row];
    if (indexPath.row==3) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1fM",_memberSize];
        cell.detailTextLabel.textColor=[UIColor blackColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    }
        //设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            HelpAndFeedbackViewController *ctl = [[HelpAndFeedbackViewController alloc] init];
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        case 1:{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证原密码" message:@"为保障数据安全，修改前请输入原密码." delegate:nil cancelButtonTitle:@"验证" otherButtonTitles:@"取消", nil];
            alert.tag = 2;
            [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            alert.delegate = self;
            [alert show];
        }
            break;
            case 2:
        {
        //反馈
            opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
            ovc.title=@"反馈";
            ovc.type=3;
            ovc.limitCount=500;
            [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
            
        }
            break;
            case 3:
        {
             [[SDImageCache sharedImageCache] clearDisk];
            CGFloat size=[[SDImageCache sharedImageCache] getSize];
            [self.view makeToast:[NSString stringWithFormat:@"已清除%.1fM缓存",_memberSize] duration:1.5f position:@"center"];
             _memberSize = size / 1024.0 / 1024.0;
            [_setTableView reloadData];
            
        }
            break;
            case 4:
        {
        
            //
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1031874136" ];
            if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
                str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1031874136"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        }
            break;
            case 5:
        {
            logoViewController*lvc=[[logoViewController alloc]initWithNibName:@"logoViewController" bundle:nil];
            [self pushWinthAnimation:self.navigationController Viewcontroller:lvc];
            
        }
            break;
        case 6:
        {
            AboutViewController *ctl = [[AboutViewController alloc] init];
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        NSString*password=[user objectForKey:@"password"];
        if ([[alertView textFieldAtIndex:0].text isEqualToString:password] ) {
            
            passwordViewController *ctl = [[passwordViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
        }
        else
        {
            [self.view makeToast:@"与原密码不一致" duration:2.0 position:@"center"];
        }

    }

}

@end
