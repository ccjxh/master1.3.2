//
//  ValidateViewController.m
//  master
//
//  Created by jin on 15/10/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "ValidateViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
 #import "FinallyLiginViewController.h"

@interface ValidateViewController ()

@property (weak, nonatomic) IBOutlet UILabel *function;
@property (weak, nonatomic) IBOutlet UITextField *textfile;
@property (weak, nonatomic) IBOutlet UIButton *getvalidate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet UIButton *bextButton;
@property (weak, nonatomic) IBOutlet UIButton *getUs;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property(nonatomic)BOOL isTure;//判断验证码是否通过
@property(nonatomic,copy)NSString*mobile;
@property(nonatomic)NSInteger type;
@end

@implementation ValidateViewController
{
    NSTimer*_timer;
    NSInteger time;
}

-(void)dealloc{

[_timer setFireDate:[NSDate distantFuture]];

}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Mobile:(NSString *)mobile Type:(NSInteger)type{
    
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _mobile=mobile;
        _type=type;
    }
    
    return self;
}


- (void)viewDidLoad {
    self.title=@"注册(2/3)";
    if (_type==1) {
        self.title=@"找回密码(2/3)";
    }
    [super viewDidLoad];
    [self initUI];
    [self sendMessage];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initUI{

    self.view.backgroundColor=COLOR(221, 221, 221, 1);
    self.function.textColor=COLOR(102, 101, 102, 1);
    self.function.text=[NSString stringWithFormat:@"请输入%@收到的短信验证码",_mobile];
    self.describe.textColor=self.function.textColor;
    self.getvalidate.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.getvalidate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bextButton.backgroundColor=COLOR(21, 168, 233, 1);
    self.getvalidate.backgroundColor=self.bextButton.backgroundColor;
    self.bextButton.layer.cornerRadius=5;
    

}

-(void)referTime{
    
    if (time==0) {
        self.getvalidate.userInteractionEnabled=YES;
        [self.getvalidate setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
        self.buttonWidth.constant=100;
        
    }else{
        
        [self.getvalidate setTitle:[NSString stringWithFormat:@"%us",--time] forState:UIControlStateNormal ];
        self.buttonWidth.constant=60;
    }
}

/**
 *  发送短信验证
 */

-(void)sendMessage{
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_mobile
                                   zone:@"+86"
                       customIdentifier:nil
                                 result:^(NSError *error)
     {
         
         if (!error)
         {
             //验证码发送成功
             if (!_timer) {
                 _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(referTime) userInfo:nil repeats:YES];
                 self.getvalidate.userInteractionEnabled=NO;
                 
             }
             time=60;
             [_timer setFireDate:[NSDate distantPast]];
             
         }
         else
         {
             [self.view makeToast:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]] duration:1.5f position:@"center"];
             time=0;
             self.getvalidate.userInteractionEnabled=YES;
         }
         
     }];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
    [SMSSDK commitVerificationCode:_textfile.text phoneNumber:_mobile zone:@"+86" result:^(NSError *error) {
        
        if (!error) {
            [self.getvalidate setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.buttonWidth.constant=80;
            self.getvalidate.userInteractionEnabled = YES;
            time=0;
            _isTure=YES;
            [self referTime];
            [_textfile resignFirstResponder];
            FinallyLiginViewController*fvc=[[FinallyLiginViewController alloc]initWithNibName:@"FinallyLiginViewController" bundle:nil Mobile:_mobile Type:_type];
            [self pushWinthAnimation:self.navigationController Viewcontroller:fvc];
        }
        else
        {
            [self.view makeToast:@"验证码输入错误" duration:1.0f position:@"center"];
        }
    }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textfile resignFirstResponder];
}


/**
 *  下一步
 *
 *  @param sender <#sender description#>
 */

- (IBAction)nextStep:(id)sender {
    [_textfile resignFirstResponder];
    if (_isTure) {
        FinallyLiginViewController*fvc=[[FinallyLiginViewController alloc]initWithNibName:@"FinallyLiginViewController" bundle:nil Mobile:_mobile Type:_type];
        if (self.token) {
            fvc.token=self.token;
        }
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = returnButtonItem;
        [self pushWinthAnimation:self.navigationController Viewcontroller:fvc];
    }else{
    
         }
    
}



/**
 *  获取mob验证码
 *
 *  @param sender <#sender description#>
 */

- (IBAction)reValidate:(id)sender {
    
    [self sendMessage];
    
}







/**
 *  联系我们
 *
 *  
 */
- (IBAction)getUs:(id)sender {
    
    [self callServicePeople];
}


@end
