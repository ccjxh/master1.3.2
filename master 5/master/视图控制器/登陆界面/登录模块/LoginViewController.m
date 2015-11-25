//
//  LoginViewController.m
//  BaoMaster
//
//  Created by xuting on 15/5/21.
//  Copyright (c) 2015年 xuting. All rights reserved.
//

#import "LoginViewController.h"
#import "XGSetting.h"
#import "XGPush.h"
#import "OpenUDID.h"
#import "loginInViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "ConnectViewController.h"
#import "appInitManager.h"
#import "LoginSelectViewController.h"
//#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UIActionSheetDelegate>

@end

@implementation LoginViewController
{
    UITextField*_account;
    UITextField*_passWord;
    UIButton*forgetButton;
    UIButton*resignButton;
    __weak IBOutlet UIButton *qqLogin;
    __weak IBOutlet UIButton *wechatLogin;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.view endEditing:YES];
   
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登陆";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self setupUI];
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*userName=[users objectForKey:@"username"];
    if (userName) {
        _account.text=userName;
        NSString*password=[users objectForKey:userName];
        if (password) {
            _passWord.text=password;
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    [self CreateFlow];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
}


-(void)setupUI{

    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(qqLogin.frame.size.width/2-35,15 , 20, 20)];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, imageview.frame.size.height/2+5, 60, 20)];
    label.text=@"QQ登陆";
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:15];
    label.enabled=YES;
    label.userInteractionEnabled=NO;
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"QQ图标"];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 1)];
    view.backgroundColor=COLOR(242, 242, 242, 1);
    UIView*Vview=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 0, 1, 50)];
    Vview.backgroundColor=COLOR(242, 242, 242, 1);
    [qqLogin addSubview:label];
    [qqLogin addSubview:Vview];
    [qqLogin addSubview:view];
    [qqLogin addSubview:imageview];
    UILabel*wechatLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+12, imageview.frame.size.height/2+5, 60, 20)];
    wechatLabel.text=@"微信登陆";
    wechatLabel.textColor=[UIColor lightGrayColor];
    wechatLabel.font=[UIFont systemFontOfSize:15];
    wechatLabel.enabled=YES;
    wechatLabel.userInteractionEnabled=NO;
    UIImageView*wechatImage=[[UIImageView alloc]initWithFrame:CGRectMake(wechatLogin.frame.size.width/2-35,15, 23, 20)];
    wechatImage.userInteractionEnabled=YES;
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 1)];
    view1.backgroundColor=COLOR(242, 242, 242, 1);

    wechatImage.image=[UIImage imageNamed:@"微信"];
    [wechatLogin addSubview:view1];
    [wechatLogin addSubview:wechatLabel];
    [wechatLogin addSubview:wechatImage];

}




-(void)login{
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*userName=[users objectForKey:@"username"];
    NSString*passWord=[users objectForKey:userName];
    [self startRequestWithUsername:userName Password:passWord];
}



-(void)startRequestWithUsername:(NSString*)username Password:(NSString*)password{

    [[loginManager share] loginWithUsername:username Password:password LoginComplite:^(id object) {
        
    }];
}

-(void)initUI{
    self.backView.layer.cornerRadius=5;
    self.icon.layer.masksToBounds=YES;
    self.icon.layer.cornerRadius=15;
    _account=[[UITextField alloc]initWithFrame:CGRectMake(25, 0,self.view.bounds.size.width , 40)];
    _account.font=[UIFont systemFontOfSize:15];
    _account.backgroundColor=[UIColor clearColor];
    _account.keyboardType=UIKeyboardTypeNumberPad;
    _account.placeholder=@"账号";
    _account.keyboardType=UIKeyboardTypeNumberPad;
    _account.layer.cornerRadius=5;
    [self.backView addSubview:_account];
    _passWord=[[UITextField alloc]initWithFrame:CGRectMake(25, 40,self.view.bounds.size.width , 40)];
    _passWord.font=[UIFont systemFontOfSize:15];
    _passWord.secureTextEntry=YES;
    self.name.text=@"baoself";
    self.name.textColor=[UIColor whiteColor];
    _passWord.backgroundColor=[UIColor clearColor];
    _passWord.placeholder=@"密码";
    _passWord.keyboardType=UIKeyboardTypeASCIICapable;
    self.lineView.backgroundColor=COLOR(242, 242, 242, 1);
    _passWord.layer.cornerRadius=5;
    self.name.font=[UIFont fontWithName:@"zapfino" size:30];
    self.loginButton.layer.cornerRadius=3;
    self.loginButton.backgroundColor=COLOR(22, 168, 234, 1);
    UIImageView*accountImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 13, 16)];
    accountImage.image=[UIImage imageNamed:@"Shape 32@2x"];
    [self.backView addSubview:accountImage];
    UIImageView*passWordImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 13, 17)];
    passWordImage.image=[UIImage imageNamed:@"LOCK@2x"];
    [self.backView addSubview:passWordImage];
    [self.backView addSubview:_passWord];
}


-(void) tapClick
{
    [self.view endEditing:YES];
}



//忘记密码
- (IBAction)forget:(id)sender {
    
    loginInViewController*lvc=[[loginInViewController alloc]initWithNibName:@"loginInViewController" bundle:nil Type:1];
    [self pushWinthAnimation:self.navigationController Viewcontroller:lvc ];
}


- (IBAction)sendLogin:(UIButton *)sender {
    //登陆
    [self flowShow];
    if ([_account.text isEqualToString:@""]||[_passWord.text isEqualToString:@""]) {
        [self.view makeToast:@"账户名或者密码不能为空" duration:1.0f position:@"center"];
        [self flowHide];
        return;
    }
    else
    {
      [[loginManager share]loginWithUsername:_account.text Password:_passWord.text LoginComplite:^(NSDictionary*statusDic) {
          NSDictionary*dict=(NSDictionary*)statusDic;
          
          
          [self flowHide];
          [self.view makeToast:[statusDic objectForKey:@"msg"] duration:1 position:@"center"];
       }];
        
    }
}


- (IBAction)resign:(UIButton *)sender {
    //注册
    loginInViewController*lvc=[[loginInViewController alloc]initWithNibName:@"loginInViewController" bundle:nil Type:0];
    [self pushWinthAnimation:self.navigationController Viewcontroller:lvc ];

}


- (IBAction)help:(id)sender {
    //需求帮助
    UIActionSheet*action=[[UIActionSheet alloc]initWithTitle:@"帮助类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"忘记密码" otherButtonTitles:@"帮助中心", nil];
    [action showInView:[[UIApplication sharedApplication].delegate window]];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        //忘记密码
        
        
    }else if (buttonIndex==1){
    
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.zhuobao.com"]];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}






- (IBAction)qqLogin:(id)sender {
    
   
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        [[SSEThirdPartyLoginHelper users]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [loginManager share].user=obj;
        }];
        
        [self flowShow];
        [[loginManager share]loginWithAccessToken:user.credential.token OpenId:user.credential.uid Type:2];
        [loginManager share].block=^(id object){
                
                NSDictionary*dict=(NSDictionary*)object;
            [self flowHide];

                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {

                    [[NSUserDefaults standardUserDefaults]setObject:user.credential.uid forKey:@"uid"];
                    [[NSUserDefaults standardUserDefaults]setObject:user.credential.token forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"loginType"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else if([[dict objectForKey:@"rspCode"] integerValue]==504){

                    [self.view makeToast:@"当前账号未绑定,请绑定后在登陆" duration:1 position:@"center" Finish:^{
                         LoginSelectViewController*lvc=[[LoginSelectViewController alloc]initWithNibName:@"LoginSelectViewController" bundle:nil User:user];
                        lvc.token=[[dict objectForKey:@"properties"] objectForKey:@"authToken"];
                        [self pushWinthAnimation:self.navigationController Viewcontroller:lvc];
                    }];
                    
                }else{
                    [self flowHide];

                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
                
            };
        
      } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        
  }];
    
}



- (IBAction)weChatLogin:(id)sender {
    
    
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        [[SSEThirdPartyLoginHelper users]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [loginManager share].user=obj;
        }];
            [self flowShow];
        [[loginManager share]loginWithAccessToken:user.credential.token OpenId:user.credential.uid Type:1];
        [loginManager share].block=^(id object){
            NSDictionary*dict=(NSDictionary*)object;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [[loginManager share]setHomePageWithMessage];
                [[NSUserDefaults standardUserDefaults]setObject:user.credential.uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults]setObject:user.credential.token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"loginType"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[loginManager share]setHomePageWithMessage];
            }else if([[dict objectForKey:@"rspCode"] integerValue]==504){
                
                [self.view makeToast:@"当前账号未绑定,请绑定后在登陆" duration:1 position:@"center" Finish:^{
                    LoginSelectViewController*lvc=[[LoginSelectViewController alloc]initWithNibName:@"LoginSelectViewController" bundle:nil User:user];
                    lvc.token=[[dict objectForKey:@"properties"] objectForKey:@"authToken"];
                    [self pushWinthAnimation:self.navigationController Viewcontroller:lvc];
                }];
                
            }else{
                [self flowHide];
                
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
        };
        
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        
 }];

}

@end
