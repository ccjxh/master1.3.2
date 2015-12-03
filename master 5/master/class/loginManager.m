//
//  loginManager.m
//  master
//
//  Created by jin on 15/9/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "loginManager.h"
#import "XGPush.h"
#import "LoginViewController.h"
#import "findMasterViewController.h"
#import "MyViewController.h"
#import "findWorkViewController.h"
#import "myRecommendPeopleViewController.h"
#import "myPublicViewController.h"
#import "CustomDialogView.h"
#import "appInitManager.h"

@implementation loginManager
+(loginManager*)share{

    static dispatch_once_t once;
    static loginManager*manager;
    dispatch_once(&once, ^{
        
        if (!manager) {
            manager=[[loginManager alloc]init];
        }
    });

    return manager;
}


//登陆
-(void)loginWithUsername:(NSString *)username Password:(NSString *)password LoginComplite:(loginComplite)loginComPlite{
    NSString*urlString=[self interfaceFromString:interface_login];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:username forKey:@"mobile"];
    [dict setObject:password forKey:@"password"];
    NSString* openUDID = [OpenUDID value];
    [dict setObject:openUDID forKey:@"machineCode"];
    if ([self getMyPhoneType]) {
        [dict setObject:[self getMyPhoneType] forKey:@"machineType"];
    }else{
        
        [dict setObject:@"unknowIphone" forKey:@"machineType"];
    }
       [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSDictionary*dict=(NSDictionary*)responseObject;
         if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:loginStatus];
            [USER_DEFAULT synchronize];
            [[dataBase share]delePrimaty];
          delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
          loginModel*model=[[loginModel alloc]init];
          NSDictionary*infortionDict=[[dict objectForKey:@"entity"] objectForKey:@"user"];
          [model setValuesForKeysWithDictionary:infortionDict];
          [[dataBase share]insertprimaryInfor:model];
            NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
            [users setObject:username forKey:@"username"];
            [users setObject:password forKey:username];
            [users synchronize];
            [self requestPersonalInformation];
            [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
                       //注册推送
            [[appInitManager share] startupAnimationDone];
            [self setHomePageWithMessage];
            [delegate setupPushWithDictory];
            
        } else if ([[dict objectForKey:@"rspCode"] integerValue]==500) {
            [[appInitManager share] startupAnimationDone];
            if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]!=YES&&[delegate.window.rootViewController isKindOfClass:[UITabBarController  class]]!=YES) {
                [[appInitManager share] setupLoginView];
                
            }else{
               
            }
        }
          
           loginComPlite(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[appInitManager share] startupAnimationDone];
        if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]!=YES||[delegate.window.rootViewController isKindOfClass:[UITabBarController  class]]!=YES) {
            [[appInitManager share] setupLoginView];
            
        }else{
            NSDictionary*returnInfor=@{@"msg":@"当前网络不给力,请稍后重试"};
            loginComPlite(returnInfor);
        }
        
    }];
    
}


/**
 *  请求个人基本信息并缓存
 */
-(void)requestPersonalInformation{
    
    NSString *urlString = [self interfaceFromString:interface_personalDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSDictionary *entityDic = [dict objectForKey:@"entity"];
            NSDictionary *userDic = [entityDic objectForKey:@"user"];
            PersonalDetailModel*model=[[PersonalDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:userDic];
            [[dataBase share]addInformationWithModel:model];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

/**
 *  退出登陆
 */
-(void)loginOut{
    [USER_DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:loginStatus];
    if ([USER_DEFAULT objectForKey:@"username"]) {
        [USER_DEFAULT removeObjectForKey:@"username"];
    }
    if ([USER_DEFAULT objectForKey:@"uid"]) {
        [USER_DEFAULT removeObjectForKey:@"uid"];
    }
    [USER_DEFAULT synchronize];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [XGPush unRegisterDevice];
    [XGPush startApp:2200136520 appKey:@"I197YN27CXHD"];  //信鸽推送初始化
    LoginViewController*lvc=[[LoginViewController alloc]init];
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    nc.navigationBar.barStyle=1;
    nc.navigationBar.barTintColor=COLOR(40, 163, 234, 1);
    [SSEThirdPartyLoginHelper logout:self.user];
    delegate.window.rootViewController=nc;
}


/**
 *  向服务器发送挤掉其他客户端消息
 *
 *  @param pull 信鸽服务器返回的uuid
 */
-(void)sendData:(NSString*)pull{
    
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSString* openUDID = [OpenUDID value];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,@"/openapi/user/checkMutilClientLogin.json"];
    
        NSString*phoneType;
        if ([self getMyPhoneType]) {
            
            phoneType=[self getMyPhoneType];
            
        }else{
            
            phoneType=@"unKnowIpone";
        }
        
        NSDictionary*dict=@{@"machineCode":openUDID,@"pullToken":pull,@"machineType":phoneType};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
    }];
}

/**
 *  设置主页
 */
-(void)setHomePageWithMessage {
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    findMasterViewController*hvc=[[findMasterViewController alloc]init];
    hvc.title=@"找师傅";
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:hvc];
    nc.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc.navigationBar.barStyle=1;
    MyViewController*mvc=[[MyViewController alloc]init];
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:mvc];
    nc2.navigationBar.barStyle=1;
    nc2.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    mvc.title=@"我的";
    UITabBarItem*item1=[[UITabBarItem alloc]initWithTitle:@"找师傅" image: [UIImage imageNamed:@"找师傅-未选择"] selectedImage: [self returnImageFromName:@"找师傅"]];
    UITabBarItem*item2=[[UITabBarItem alloc]initWithTitle:@"找活干" image: [UIImage imageNamed:@"找工作-未选择"] selectedImage: [self returnImageFromName:@"找工作"]];
    UITabBarItem*item3=[[UITabBarItem alloc]initWithTitle:@"我的" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    findWorkViewController*fvc=[[findWorkViewController alloc]init];
    fvc.title=@"找活干";
    UITabBarItem*friendItem=[[UITabBarItem alloc]initWithTitle:@"消息" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    UINavigationController*nc4=[[UINavigationController alloc]initWithRootViewController:fvc];
    nc4.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc4.navigationBar.barStyle=1;
    UITabBarController*cvc=[[UITabBarController alloc]init];
    cvc.viewControllers=@[nc,nc4,nc2];
    cvc.tabBar.selectedImageTintColor=COLOR(0, 166, 237, 1);
    nc.tabBarItem=item1;
    nc2.tabBarItem=item3;
    nc4.tabBarItem=item2;
    delegate.window.rootViewController=cvc;
    NSDictionary* dict=[self.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (dict) {
        NSString*str=[dict objectForKey:PUSHKEY];
        NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
        NSString*type;
        if (array.count>1) {
            type=[array[1] componentsSeparatedByString:@"\"}"][0];
        }
        if ([type isEqualToString:@"masterOrderContact"]==YES||[type isEqualToString:@"masterOrderAccept"]==YES||[type isEqualToString:@"masterOrderReject"]==YES||[type isEqualToString:@"masterOrderFinish"]==YES||[type isEqualToString:@"masterOrderStop"]==YES||[type isEqualToString:@"masterOrderStop"]==YES) {
            cvc.selectedIndex=1;
            NSArray*sepArray=[str componentsSeparatedByString:@"\"entityId\":"];
            NSString*ID=[sepArray[1] componentsSeparatedByString:@","][0];
        }else if ([type isEqualToString:@"personalPass"]==YES||[type isEqualToString:@"personalFail"]==YES||[type isEqualToString:@"masterPostPass"]==YES||[type isEqualToString:@"masterPostFail"]==YES||[type isEqualToString:@"foremanPostPass"]==YES||[type isEqualToString:@"foremanPostFail"]==YES||[type isEqualToString:@"managerPostPass"]==YES||[type isEqualToString:@"managerPostFail"]==YES){
            
        }else if ([type isEqualToString:@"requestRecommend"]==YES){
            cvc.selectedIndex=2;
            myRecommendPeopleViewController*rvc=[[myRecommendPeopleViewController alloc]initWithNibName:@"myRecommendPeopleViewController" bundle:nil];
            rvc.hidesBottomBarWhenPushed=YES;
            [nc2 pushViewController:rvc animated:NO];
        }else if ([type isEqualToString:@"projectAuditPass"]==YES||[type isEqualToString:@"projectAuditFail"]==YES){
            
            cvc.selectedIndex=2;
            myPublicViewController*mvc=[[myPublicViewController alloc]init];
            [nc2 pushViewController:mvc animated:NO];
        }
        
        if (!type) {
            CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"" message:@"当前账号在其他设备登陆,若非本人操作,你的登陆密码可能已经已经泄露,请及时修改密码.紧急情况可以联系客服" buttonTitles:@"确定", nil];
            [dialog showWithCompletion:^(NSInteger selectIndex) {
                
                [self loginOut];
                
            }];
        }
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
}

-(UIImage*)returnImageFromName:(NSString*)name{
    
    UIImage *img = [UIImage imageNamed:name];
    img =  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
    
}



-(void)loginWithAccessToken:(NSString *)accessToken OpenId:(NSString *)openId Type:(NSInteger)thirdType{
   

    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    NSString* openUDID = [OpenUDID value];
    [dict setObject:openUDID forKey:@"machineCode"];
    if ([self getMyPhoneType]) {
        [dict setObject:[self getMyPhoneType] forKey:@"machineType"];
    }else{
        
        [dict setObject:@"unknowIphone" forKey:@"machineType"];
    }
    
    if (accessToken) {
        [dict setObject:accessToken forKey:@"accessToken"];
        [dict setObject:openId forKey:@"openId"];
        [dict setObject:[NSString stringWithFormat:@"%lu",thirdType] forKey:@"thirdType"];
        
        
        NSString*urlString=[self interfaceFromString:interface_qqLogin];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            if (self.block) {
                self.block(responseObject);
            }
            NSDictionary*dict=(NSDictionary*)responseObject;
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==504) {
                
                }else if ([[dict objectForKey:@"rspCode"] integerValue]==200){
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
                loginModel*model=[[loginModel alloc]init];
                NSDictionary*infortionDict=[[dict objectForKey:@"entity"] objectForKey:@"user"];
                [model setValuesForKeysWithDictionary:infortionDict];
                [[dataBase share]delePrimaty];
                [[dataBase share]insertprimaryInfor:model];
                NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
                [users synchronize];
                [[loginManager share] requestPersonalInformation];
                [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
                //注册推送
                [[appInitManager share] startupAnimationDone];
                [delegate setupPushWithDictory];
                [self setHomePageWithMessage];
            
            }else{
 
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            NSDictionary*dict=@{@"rspCode":@"600",@"msg":@"当前网络不好"};
            if (self.block) {
                self.block(dict);
            }
        }];
    }
}


-(void)ReLoginWithAccessToken:(NSString *)accessToken OpenId:(NSString *)openId Type:(NSInteger)thirdType{
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    NSString* openUDID = [OpenUDID value];
    [dict setObject:openUDID forKey:@"machineCode"];
    if ([self getMyPhoneType]) {
        [dict setObject:[self getMyPhoneType] forKey:@"machineType"];
    }else{
        
        [dict setObject:@"unknowIphone" forKey:@"machineType"];
    }
    
    if (accessToken) {
        [dict setObject:accessToken forKey:@"accessToken"];
        [dict setObject:openId forKey:@"openId"];
        [dict setObject:[NSString stringWithFormat:@"%lu",thirdType] forKey:@"thirdType"];
        NSString*urlString=[self interfaceFromString:interface_qqLogin];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//            if (self.block) {
//                self.block(responseObject);
//            }
//            NSDictionary*dict=(NSDictionary*)responseObject;
//            if ([[dict objectForKey:@"rspCode"] integerValue]==504) {
//                
//            }else if ([[dict objectForKey:@"rspCode"] integerValue]==200){
//                
//                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//                delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
//                loginModel*model=[[loginModel alloc]init];
//                NSDictionary*infortionDict=[[dict objectForKey:@"entity"] objectForKey:@"user"];
//                [model setValuesForKeysWithDictionary:infortionDict];
//                [[dataBase share]delePrimaty];
//                [[dataBase share]insertprimaryInfor:model];
//                NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
//                [users synchronize];
//                [[loginManager share] requestPersonalInformation];
//                [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
//                //注册推送
//                [[appInitManager share] startupAnimationDone];
//                [delegate setupPushWithDictory];
//                [self setHomePageWithMessage];
//                
//            }else{
//                
//            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            NSDictionary*dict=@{@"rspCode":@"600",@"msg":@"当前网络不好"};
            if (self.block) {
                self.block(dict);
            }
        }];
    }
}

@end
