//
//  ConnectViewController.m
//  master
//
//  Created by jin on 15/11/9.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "ConnectViewController.h"
#import "XGPush.h"
#import "loginManager.h"
#import "appInitManager.h"
@interface ConnectViewController ()

@end

@implementation ConnectViewController
{
    

    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UIButton *connectButton;
    __weak IBOutlet UIView *_backView;
    NSString*_token;
    ZJSwitch*_zjSwit;

}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Token:(NSString *)token{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _token=token;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR(230, 231, 233, 1);
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{

    self.title=@"登陆绑定";
    connectButton.layer.cornerRadius=10;
    [connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connectButton addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    connectButton.backgroundColor=COLOR(0, 166, 237, 1);
    _zjSwit=[[ZJSwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-53, 48, 40, 13)];
    _zjSwit.onText=@"ABC";
    _zjSwit.onTintColor=COLOR(21, 168, 233, 1);
    password.keyboardType=UIKeyboardTypeASCIICapable;
    [_zjSwit setOn:YES animated:NO];
    [_zjSwit addTarget:self action:@selector(IsShow:) forControlEvents:UIControlEventValueChanged];
    [_backView addSubview:_zjSwit];

}




/**
 *  是否显示明文
 *
 *  @param sender <#sender description#>
 */
- (void)IsShow:(id)sender {
    
    if (_zjSwit.on==YES) {
        [password setSecureTextEntry:NO];
    }else{
        
        [password setSecureTextEntry:YES];
        
    }
    
}




-(void)connect{

    if (username.text!=nil&&password.text!=nil) {
        NSString*urlString=[self interfaceFromString:interface_Connect];
        NSString*type;
        if ([self getMyPhoneType]) {
            type=[self getMyPhoneType];
        }else{
            type=@"unknowIphone";
        }
        NSString* openUDID = [OpenUDID value];
    NSDictionary*dict=@{@"mobile":username.text,@"password":password.text,@"machineType":type,@"machineCode":openUDID,@"authToken":_token};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
               
                  [self.view makeToast:@"绑定成功" duration:1 position:@"center" Finish:^{
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
                      [[loginManager share]setHomePageWithMessage];
                }];
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self.view makeToast:@"当前网络不给力,请稍后重试" duration:1 position:@"center"];
        }];
        
    }

}

@end
