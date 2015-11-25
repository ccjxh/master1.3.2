//
//  loginInViewController.m
//  master
//
//  Created by jin on 15/10/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "loginInViewController.h"
#import "ValidateViewController.h"
@interface loginInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextfile;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property(nonatomic)NSInteger type;
@end

@implementation loginInViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(NSInteger )type{


    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _type=type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=COLOR(221, 221, 221, 1);
    self.title=@"注册(1/3)";
    if (_type==1) {
        self.title=@"找回密码(1/3)";
    }
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;    [self initUI];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


-(void)initUI{
    
    self.describeLabel.textColor=COLOR(102, 102, 102, 1);
    self.mobileTextfile.delegate=self;
    self.mobileTextfile.keyboardType=UIKeyboardTypeNumberPad;
    self.nextStepButton.backgroundColor=[UIColor grayColor];
    self.nextStepButton.layer.cornerRadius=5;
}



-(void)setMobileTextfile:(UITextField *)mobileTextfile{

    _mobileTextfile=mobileTextfile;
    if (_mobileTextfile.text.length==11) {
        self.nextStepButton.backgroundColor=COLOR(21, 168, 234, 1);
        self.nextStepButton.userInteractionEnabled=YES;
    }else{
        
        self.nextStepButton.backgroundColor=[UIColor grayColor];
        self.nextStepButton.userInteractionEnabled=NO;
    }

}


/**
 *  下一步按钮被点击
 *
 *
 */
- (IBAction)onclick:(id)sender {
    
    if (_mobileTextfile.text.length==0) {
        [self.view makeToast:@"请先填写手机号" duration:1 position:@"center"];
        return;
    }
    
    if ([self isValidateMobile:_mobileTextfile.text]==NO) {
        [self.view makeToast:@"请填写正确的手机号码" duration:1 position:@"center"];
        return;
    }
    
    [_mobileTextfile resignFirstResponder];
    if (_type==1) {
        
        ValidateViewController*vc=[[ValidateViewController alloc]initWithNibName:@"ValidateViewController" bundle:nil Mobile:_mobileTextfile.text Type:_type];
        
        [self pushWinthAnimation:self.navigationController Viewcontroller:vc];
        return;
        
    }
    
    
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_existMobile];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:_mobileTextfile.text forKey:@"mobile"];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
//            //进入下一个界面
            ValidateViewController*vc=[[ValidateViewController alloc]initWithNibName:@"ValidateViewController" bundle:nil Mobile:_mobileTextfile.text Type:_type];
            if (self.token) {
                vc.token=self.token;
            }
            
            [self pushWinthAnimation:self.navigationController Viewcontroller:vc];
            
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"当前网络不给力,请稍后重试" duration:1 position:@"center"];
    }];
    
}



/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (_mobileTextfile.text.length==10) {
        _nextStepButton.backgroundColor=COLOR(21, 168, 233, 1);
        _nextStepButton.userInteractionEnabled=YES;
    }else{
        _nextStepButton.backgroundColor=[UIColor grayColor];
        _nextStepButton.userInteractionEnabled=NO;
    }
    return YES;

}




/**
 *  呼叫客服
 *
 *  @param sender <#sender description#>
 */
- (IBAction)callServicePeople:(id)sender {
    
    [self callServicePeople];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mobileTextfile resignFirstResponder];
}

@end
