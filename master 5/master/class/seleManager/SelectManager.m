//
//  SelectManager.m
//  master
//
//  Created by jin on 15/10/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "SelectManager.h"
#import "MyserviceViewController.h"
#import "BasicInfoViewController.h"
#import "myServiceSelectedViewController.h"
#import "myPublicViewController.h"
#import "myPublicViewController.h"
#import "myRecommendPeopleViewController.h"
#import "SetViewController.h"
#import "myIntegralListViewController.h"
#import "myCaseViewController.h"
#import "CollectViewController.h"
#import "MyShareViewController.h"
#import "MyViewController.h"
#import "introlduceChangeViewController.h"
#import "workStatusViewController.h"
#import "recommendViewController.h"
#import "TableViewCell.h"
#import "projectCaseAddViewController.h"
#import "PayViewController.h"
#import "projectCastDetailViewController.h"
#import "myServiceSelectedViewController.h"
#import "ChangeDateViewController.h"
#import "certainViewController.h"
#import "cityViewController.h"
#import "provinceViewController.h"
#import "proviceSelectedViewController.h"
#import "CommonAdressController.h"
@implementation SelectManager
+(SelectManager*)share{
    static dispatch_once_t once;
    static SelectManager*manager;
    if (!manager) {
        dispatch_once(&once, ^{
            manager=[[SelectManager alloc]init];
        });
    }
    return manager;
}


-(void)tableviewDidSelectWithKindOfClass:(NSString* )classString IndexPath:(NSIndexPath *)indexPath Navigatingation:(UINavigationController *)navigationController Tableview:(UITableView *)tableview{
    if ([classString isEqualToString:@"MyViewController"]==YES) {
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
       PersonalDetailModel*model =[[dataBase share]findPersonInformation:delegate.id];
        loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
            switch (indexPath.section) {
                case 0:
                {
                    //个人基本信息
                    BasicInfoViewController *ctl = [[BasicInfoViewController alloc] init];
                    ctl.hidesBottomBarWhenPushed=YES;
                    ctl.block=^(NSString*realName,NSString*corve){
                        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                        PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                        model.icon=corve;
                        [[dataBase share]addInformationWithModel:model];
                        [tableview reloadData];
                    };
                    
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                }
                    break;
                case 1:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            //我的服务
                           
                            if ([logModel.userPost intValue]==3||[logModel.userPost intValue]==4||[logModel.userPost intValue]==2||model.skillState==1) {
                                MyserviceViewController*mvc=[[MyserviceViewController alloc]initWithNibName:@"MyserviceViewController" bundle:nil];
                                mvc.title=@"我的服务";
                                mvc.hidesBottomBarWhenPushed=YES;
                                [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                                return;
                            }
                            
                            
                            myServiceSelectedViewController*svc=[[myServiceSelectedViewController alloc]initWithNibName:@"myServiceSelectedViewController" bundle:nil];
                            svc.hidesBottomBarWhenPushed=YES;
                            [self pushWinthAnimation:navigationController  Viewcontroller:svc];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 2:{
                    if ([logModel.userPost intValue]==1) {
                        myPublicViewController*mvc=[[myPublicViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                        return;
                    }
                   
                    myCaseViewController *ctl = [[myCaseViewController alloc] initWithNibName:@"myCaseViewController" bundle:nil];
                    ctl.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                }
                    
                    break;
                    
                case 3:
                {
                    if ([logModel.userPost intValue]!=1) {
                       
                        myPublicViewController*mvc=[[myPublicViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                    }else{
                        
                        CommonAdressController*cvc=[[CommonAdressController alloc]initWithNibName:@"CommonAdressController" bundle:nil];
                        [self pushWinthAnimation:navigationController Viewcontroller:cvc];
                        
//                        myIntegralListViewController*mvc=[[myIntegralListViewController alloc]init];
//                        mvc.hidesBottomBarWhenPushed=YES;
//                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                    }
                    
                }
                    break;
                case 4:
                {
                    if ([logModel.userPost intValue]!=1){
                        switch (indexPath.row) {
                            case 0:
                            {
                               
                                CommonAdressController*cvc=[[CommonAdressController alloc]initWithNibName:@"CommonAdressController" bundle:nil];
                                [self pushWinthAnimation:navigationController Viewcontroller:cvc];
                                
                            }
                                break;
                            default:
                                break;
                        }
                    }else{
                        
                        myIntegralListViewController*mvc=[[myIntegralListViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                        
//                        CollectViewController *cVC = [[CollectViewController alloc] init];
//                        cVC.hidesBottomBarWhenPushed=YES;
//                        [self pushWinthAnimation:navigationController Viewcontroller:cVC];
                    }
                }
                    break;
                case 5:
                {
                    
                    if ([logModel.userPost intValue]!=1) {
                        
                        
                        myIntegralListViewController*mvc=[[myIntegralListViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                        
                        
                    }else{
                        
                        CollectViewController *cVC = [[CollectViewController alloc] init];
                        cVC.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:cVC];
                        
//                        MyShareViewController*svc=[[MyShareViewController alloc]init];
//                        svc.hidesBottomBarWhenPushed=YES;
//                        [self pushWinthAnimation:navigationController Viewcontroller:svc];
                    }
                    
                }
                    break;
                case 6:
                {
                    if ([logModel.userPost intValue]!=1) {
                       
                        CollectViewController *cVC = [[CollectViewController alloc] init];
                        cVC.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:cVC];
                        
                                                          }else{
                        
                        MyShareViewController*svc=[[MyShareViewController alloc]init];
                        svc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:svc];
                        
//                        SetViewController *ctl = [[SetViewController alloc] init];
//                        ctl.hidesBottomBarWhenPushed=YES;
//                        [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                    }
                }
                    break;
                case 7:
                {
                    if ([logModel.userPost integerValue]!=1) {
                        
                        MyShareViewController*svc=[[MyShareViewController alloc]init];
                        svc.hidesBottomBarWhenPushed=YES;
                        [navigationController pushViewController:svc animated:YES];
                        
                        return;
                    }
                    SetViewController *ctl = [[SetViewController alloc] init];
                    ctl.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                    
//                    CommonAdressController*cvc=[[CommonAdressController alloc]initWithNibName:@"CommonAdressController" bundle:nil];
//                    [self pushWinthAnimation:navigationController Viewcontroller:cvc];
                    
                }
                    break;
                    case 8:
                {
                    SetViewController *ctl = [[SetViewController alloc] init];
                    ctl.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                    
                }
                    break;
                default:
                    break;
        }
    }else if ([classString isEqualToString:@"MyserviceViewController"]==YES){
    
        
    
    }
}
@end
