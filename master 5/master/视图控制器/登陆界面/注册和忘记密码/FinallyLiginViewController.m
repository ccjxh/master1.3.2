//
//  FinallyLiginViewController.m
//  master
//
//  Created by jin on 15/10/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "FinallyLiginViewController.h"
#import "ZJSwitch.h"
#import "LoginViewController.h"
#import "XGPush.h"
#import "appInitManager.h"
#import "loginManager.h"
@interface FinallyLiginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UIButton *finshButton;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *visitCode;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic)NSInteger type;
@property(nonatomic,copy)NSString*mobile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;

@end

@implementation FinallyLiginViewController
{

    ZJSwitch*_zjSwit;

}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Mobile:(NSString *)mobile Type:(NSInteger)type{

    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _mobile=mobile;
        _type=type;
        self.view.backgroundColor=COLOR(221, 221, 221, 1);
        if (type==1) {
            self.backHeight.constant=39.5;
            self.lineView.hidden=YES;
        }
    }

    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册(3/3)";
    if (self.type==1) {
        self.title=@"找回密码(3/3)";
    }
    self.navigationItem.leftBarButtonItem.title=@"返回";

    [self initUI];
    [self CreateFlow];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initUI{
    
    self.finshButton.layer.cornerRadius=5;
    self.finshButton.userInteractionEnabled=NO;
    self.finshButton.backgroundColor=[UIColor grayColor];
    _zjSwit=[[ZJSwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-53, 8, 40, 13)];
    _zjSwit.onText=@"ABC";
    _zjSwit.onTintColor=COLOR(21, 168, 233, 1);
    self.password.keyboardType=UIKeyboardTypeASCIICapable;
    [_zjSwit setOn:YES animated:NO];
    [_zjSwit addTarget:self action:@selector(IsShow:) forControlEvents:UIControlEventValueChanged];
    [self.backView addSubview:_zjSwit];

}


/**
 *  是否显示明文
 *
 *  @param sender <#sender description#>
 */
- (void)IsShow:(id)sender {
    
    if (_zjSwit.on==YES) {
        [_password setSecureTextEntry:NO];
    }else{
    
        [_password setSecureTextEntry:YES];

    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    if (_password.text.length>=4) {
        
        self.finshButton.userInteractionEnabled=YES;
        self.finshButton.backgroundColor=COLOR(21, 168, 233, 1);
    }else{
    
        self.finshButton.userInteractionEnabled=NO;
        self.finshButton.backgroundColor=[UIColor grayColor];
    
    }

    return YES;

}


/**
 *  完成按钮被点击
 *
 *
 */
- (IBAction)finsh:(id)sender {
    
    
    [_password resignFirstResponder];
    [_visitCode resignFirstResponder];
    if (self.password.text.length<6) {
        [self.view makeToast:@"密码至少是六位数" duration:1 position:@"center"];
        return;
    }
    if (_visitCode.text.length!=0) {
    
    if (self.visitCode.text.length<4) {
        [self.view makeToast:@"请输入正确的邀请码" duration:1 position:@"center"];
        return;
        }
    }
    [self flowShow];
    
    if (_type==1) {
    //找回密码
        NSString*urlString=[self interfaceFromString:interface_resetPassword];
        NSDictionary*dict=@{@"mobile":_mobile,@"password":_password.text};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"密码重置成功" duration:1 position:@"center" Finish:^{
                    for (UIViewController*Vc in self.navigationController.viewControllers) {
                        if ([Vc isKindOfClass:[LoginViewController class]]==YES) {
                            [self.navigationController popToViewController:Vc animated:YES];
                        }
                    }
                    
                }];
                
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            
            }
            
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
             [self.view makeToast:@"当前网络不给力,请稍后重试" duration:1 position:@"center"];
        }];
        
        
        return;
        
    }
    
    NSString* openUDID = [OpenUDID value];
    NSString*urlString=[self interfaceFromString:interface_resogn];
    NSDictionary*dict;
    NSString*type=[self getMyPhoneType];
    if (!type) {
        type=@"iPhone6s/iPhone6sPlus";
    }
    dict=@{@"mobile":_mobile,@"password":_password.text,@"machineType":type,@"machineCode":openUDID};
    if (self.token) {
        dict=@{@"mobile":_mobile,@"password":_password.text,@"machineType":type,@"machineCode":openUDID,@"authToken":self.token};
    }
    if (_visitCode.text.length!=0) {
        dict=@{@"mobile":_mobile,@"password":_password.text,@"machineType":type,@"machineCode":openUDID,@"inviteCode":_visitCode.text};
        if (self.token) {
             dict=@{@"mobile":_mobile,@"password":_password.text,@"machineType":type,@"machineCode":openUDID,@"inviteCode":_visitCode.text,@"authToken":self.token};
        }
    }
    
    
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        
        
        [self flowHide];
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200)
        {
            [self.view makeToast:@"恭喜！注册成功。" duration:1 position:@"center" Finish:^{
                [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:loginStatus];
                [USER_DEFAULT synchronize];
                [[dataBase share]delePrimaty];
                delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
                loginModel*model=[[loginModel alloc]init];
                NSDictionary*infortionDict=[[dict objectForKey:@"entity"] objectForKey:@"user"];
                [model setValuesForKeysWithDictionary:infortionDict];
                [[dataBase share]delePrimaty];
                [[dataBase share]insertprimaryInfor:model];
                NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
                [users setObject:_mobile forKey:@"username"];
                [users setObject:_password.text forKey:_mobile];
                [users synchronize];
                [[loginManager share]requestPersonalInformation];
                [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
                //注册推送
                [delegate setupPushWithDictory];
                [[appInitManager share] startupAnimationDone];
                [[loginManager share]setHomePageWithMessage];
            }];
           
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }

    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        [self.view makeToast:@"当前网络不给力，请检查网络设置" duration:1.0f position:@"center"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
