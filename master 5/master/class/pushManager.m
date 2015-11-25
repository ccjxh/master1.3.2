//
//  pushManager.m
//  master
//
//  Created by jin on 15/10/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "pushManager.h"
#import "XGPush.h"
#import "CustomDialogView.h"
#import "loginManager.h"
#import "appInitManager.h"
@implementation pushManager
{
    NSDictionary*_userDict;

}


+(pushManager*)share{

    static dispatch_once_t once;
    static pushManager*manager;
    dispatch_once(&once, ^{
       
        if (!manager) {
            manager=[[pushManager alloc]init];
        }
    });
    return manager;

}


/**
 *  根据推送的字典做出相应的相应
 *
 *
 */
-(void)actionWithDict:(NSDictionary*)userDict{

    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userDict];
    NSString*str=[userDict objectForKey:PUSHKEY];
    NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
    NSString*type=[array[1] componentsSeparatedByString:@"\"}"][0];
    if (type) {
        [self handleWithType:type];
        }else{
           
            CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"" message:[[userDict objectForKey:@"aps"] objectForKey:@"alert"] buttonTitles:@"确定", nil];
            [dialog showWithCompletion:^(NSInteger selectIndex) {
    
                [[loginManager share]loginOut];
        }];
    }
}


/**
 *  根据推送的类型做出相应的操作
 *
 *  @param type 推送的类型
 */
-(void)handleWithType:(NSString*)type{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if ([type isEqualToString:@"personalPass"]==YES) {
        [delegate.window.viewController.view makeToast:@"身份认证通过" duration:1 position:@"center"];
        
        model.personal=1;
        model.personalState=2;
        [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
        
    }else if ([type isEqualToString:@"personalFail"]==YES){
        
        [delegate.window.viewController.view makeToast:@"身份认证通过" duration:1 position:@"center"];
        PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
        model.personal=0;
        model.personalState=3;
        [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
        
    }else if ([type isEqualToString:@"masterPostPass"]==YES)
    {
        //师傅认证通
        logModel.userPost=@"2";
        [[loginManager share]requestPersonalInformation];
    }else if ([type isEqualToString:@"masterPostFail"]==YES){
        
        logModel.userPost=@"1";
        [[loginManager share]requestPersonalInformation];
        
    }else if ([type isEqualToString:@"foremanPostPass"]==YES){
        
        logModel.userPost=@"3";
        [[loginManager share]requestPersonalInformation];

        
        
    }else if ([type isEqualToString:@"foremanPostFail"]==YES){
        logModel.userPost=@"3";
        [[loginManager share]requestPersonalInformation];
        
    }else if ([type isEqualToString:@"projectAuditPass"]==YES){
        
        [self findIntrgalWithType:@"11"];
    }else if ([type isEqualToString:@"projectAuditFail"]==YES){
        
        [delegate.window.rootViewController.view makeToast:@"很抱歉,您的招工信息未能通过" duration:1 position:@"center"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"public" object:nil userInfo:nil];
        
    }else if ([type isEqualToString:@"projectAccept"]==YES){
        
        [self findIntrgalWithType:@"8"];
        
        
        }else if ([type isEqualToString:@"noticeRelease"]==YES){
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
    
}



/**
 *  根据类型弹出相应的加积分动画
 *
 *
 */
-(void)findIntrgalWithType:(NSString*)type{

    NSString*urlString=[self interfaceFromString:interface_myTotal];
    NSDictionary*dict=@{@"type":type};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
    
                        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                        loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
                        logModel.integral=[[dict objectForKey:@"properties"] objectForKey:@"totalIntegral"];
                        if ([[[dict objectForKey:@"entity"] objectForKey:@"userIntegral"] objectForKey:@"value"]) {
                            NSDictionary*parent=@{@"value":[[[dict objectForKey:@"entity"] objectForKey:@"userIntegral"] objectForKey:@"value"]};
                            NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                            [[NSNotificationCenter defaultCenter]postNotification:noction];
                        }
    
                    }
    
                } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"public" object:nil userInfo:nil];
}

@end
