//
//  opinionViewController.m
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "opinionViewController.h"
#import "ExampleViewController.h"
#import "CommonAdressController.h"
@interface opinionViewController ()<UITextViewDelegate>

@end

@implementation opinionViewController
{
    NSInteger _id;//被举报人的id
    NSInteger _type; //0为服务描述  1为举报   2为需求人数  3为反馈
    NSString*_title; //本页标题
    NSInteger _limitCount;//限制的字数
    NSString*_origin;//原始数据
    __weak IBOutlet UIButton *example;
    __weak IBOutlet UILabel *_intrduce;
    __weak IBOutlet UIButton *normal;


}

/**
 *  构造函数
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *  @param origin         若果存在原始数据,就传入原始数据
 *  @param title          本页的标题
 *  @param type           0为服务描述  1为举报   2为需求人数  3为反馈
 *  @param limitCount     限制的字数
 *  @param id             如果是被举报人就传入被举报人得id
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Origin:(NSString *)origin Title:(NSString *)title Type:(NSInteger)type LimitCount:(NSInteger)limitCount ID:(NSInteger)id{
    
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    
        _id=id;
        _limitCount=limitCount;
        _origin=origin;
        _type=type;
        _title=title;
    }
    
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=COLOR(236, 237, 239, 1);
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{

    if (self.type==4||self.type==5||self.type==6||self.type==7||self.type==8) {
        [self showExample];
    }else{
    
        [self hideExample];
    }
   
    self.tx.delegate=self;
    if (self.origin&&[self.origin integerValue]!=0) {
      self.tx.text=self.origin;
       self.height.constant=[self accountStringHeightFromString:self.tx.text Width:SCREEN_WIDTH-26]+16;
        [self.tx layoutIfNeeded];
        [self.tx updateConstraintsIfNeeded];

    }
    if (self.type==2) {
        self.tx.keyboardType=UIKeyboardTypeNumberPad;
    }
    self.tx.layer.cornerRadius=2;
    [self customNavationBar];
    if (self.type==9) {
        //招工详细地址特定ui
        normal.hidden=NO;
        [normal setTitle:@"常用地址" forState:UIControlStateNormal];
        [normal setTitleColor:COLOR(14, 148, 231, 1)  forState:UIControlStateNormal];
        normal.titleLabel.font=[UIFont systemFontOfSize:15];
        [normal addTarget:self action:@selector(normal) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self CreateFlow];
}


-(void)normal{

    CommonAdressController*cvc=[[CommonAdressController alloc]initWithNibName:@"CommonAdressController" bundle:nil];
    cvc.type=1;
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
    
}

-(void)showExample{

    _intrduce.hidden=NO;
    example.hidden=NO;

}



-(void)hideExample{

    _intrduce.hidden=YES;
    example.hidden=YES;
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.tx becomeFirstResponder];

}


-(void)customNavationBar{

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:0 target:self action:@selector(confirm)];

}

/**
 *  查看样例
 *
 *  @param sender
 */
- (IBAction)example:(id)sender {
    
    if (self.type==4) {
        ExampleViewController*evc=[[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        evc.imageName=@"成功案例工长";
        [self.navigationController pushViewController:evc animated:YES];
    }else if(self.type==5){
    
        ExampleViewController*evc=[[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        evc.imageName=@"成功案例师傅";
        [self.navigationController pushViewController:evc animated:YES];
    }else if (self.type==6){
    
        ExampleViewController*evc=[[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        evc.imageName=@"曾合作雇主";
        [self.navigationController pushViewController:evc animated:YES];
    }else if(self.type==7){
        ExampleViewController*evc=[[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        evc.imageName=@"服务介绍工长";
        [self.navigationController pushViewController:evc animated:YES];
        
    }else if (self.type==8){
        
        ExampleViewController*evc=[[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        evc.imageName=@"服务介绍师傅";
        evc.type=self.type;
        [self.navigationController pushViewController:evc animated:YES];
        
    }
}

-(void)confirm{
    
    [self.tx resignFirstResponder];
    if (self.tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }else{
        if (self.type==1||self.type==4||self.type==5||self.type==6) {
            
            if (self.contentBlock) {
                self.contentBlock(_tx.text);
                [self popWithnimation:self.navigationController];
                return;
            }
        }
        
        if (self.type==2) {
            
            if ([self isPureNumandCharacters:_tx.text]==NO) {
                [self.view makeToast:@"人数只能为纯数字" duration:1 position:@"center"];
                return;
            }
            
            
            if (self.contentBlock) {
                self.contentBlock(_tx.text);
                [self popWithnimation:self.navigationController];
                return;
            }
        }

        if (self.type==2) {
            if (self.block) {
                self.block(self.tx.text);
                return;
            }
        }
        
        if (self.type==3) {
            
            NSString*urlString=[self interfaceFromString:interface_commitProblem];
            NSDictionary*dict=@{@"problem":_tx.text};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self.view makeToast:@"您的问题我们已经收到，感谢您的反馈。我会尽快处理您反馈的问题" duration:1.5f position:@"center" Finish:^{
                        
                        [self popWithnimation:self.navigationController];
                    }];
                }else{
                
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1.0f position:@"center" Finish:nil];
                
                }

            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                
                 [self.view makeToast:@"当前网络不给路,请稍后重试" duration:1.0f position:@"center" Finish:nil];
            }];
            
            return;
        }
        
        if (self.type==9) {
            if (self.contentBlock) {
                self.contentBlock(self.tx.text);
            }
            [self popWithnimation:self.navigationController];
            return;
        }
        NSString*urlString;
        NSDictionary*dict;
        if (self.type==7||self.type==8) {
            urlString=[self interfaceFromString:interface_updateServiceDescribe];
            dict=@{@"describe":self.tx.text};
        }
        if (self.type==1) {
            urlString=@"interface_reportInfo";
            dict=@{@"problem":self.tx.text,@"checkUser.id":[NSString stringWithFormat:@"%lu",self.id]};
        }
        
        [self flowShow];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                 [self flowHide];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                    if (self.type==7||self.type==8) {
                        self.model.serviceDescribe=self.tx.text;
                    }
                    if (self.block) {
                        self.block(YES);
                    }
                    if (self.type==0) {
                        self.model.serviceDescribe=_tx.text;
                    }
                    [self.navigationController popWithnimation:self.navigationController];
                }];
                
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                [self flowHide];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
        }];
    
    }
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length>self.limitCount+1) {
        
        return NO;
        
    }
    
    self.height.constant=[self accountStringHeightFromString:self.tx.text Width:SCREEN_WIDTH-26]+16;
    self.label.text=[NSString stringWithFormat:@"还有%u字可以填写",self.limitCount-[textView.text length]];
    return YES;
   
}


- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string =[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
