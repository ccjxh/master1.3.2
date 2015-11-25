//
//  LoginSelectViewController.m
//  master
//
//  Created by jin on 15/11/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "ConnectViewController.h"
#import "loginInViewController.h"
@interface LoginSelectViewController ()

@end

@implementation LoginSelectViewController
{
    
    __weak IBOutlet UIImageView *_headImage;
    __weak IBOutlet UILabel *_typeString;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UIButton *resigButton;
    __weak IBOutlet UIButton *_connectButton;
    SSDKUser*_user;

}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil User:(SSDKUser *)user{

    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _user=user;
    }
    
    
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customUI];
    self.title=@"联合登陆";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customUI{

    [resigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resigButton.backgroundColor=COLOR(21, 163, 227, 1);
    resigButton.layer.cornerRadius=10;
    _connectButton.backgroundColor=resigButton.backgroundColor;
    _connectButton.layer.cornerRadius=10;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_user.icon] placeholderImage:[UIImage imageNamed:headImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (error) {
            _headImage.image=[UIImage imageNamed:errorImage];
        }
    }];
    if (_user.platformType==6) {
        _typeString.text=@"亲爱的qq用户";
    }else{
    
        _typeString.text=@"亲爱的微信用户";
    }
   
    _headImage.layer.cornerRadius=_headImage.frame.size.width/2;
    _headImage.clipsToBounds=YES;
    _nameLabel.text=_user.nickname;
    
}




/**
 *  注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)resign:(id)sender {
    
    loginInViewController*lvc=[[loginInViewController alloc]initWithNibName:@"loginInViewController" bundle:nil Type:0];
    lvc.token=self.token;
    [self pushWinthAnimation:self.navigationController Viewcontroller:lvc];
    
}


/**
 *  关联
 *
 *  @param sender <#sender description#>
 */
- (IBAction)connect:(id)sender {
    
    ConnectViewController*cvc=[[ConnectViewController alloc]initWithNibName:@"ConnectViewController" bundle:nil Token:self.token];
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
    
}

@end
