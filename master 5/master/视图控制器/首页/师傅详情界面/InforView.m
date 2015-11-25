//
//  InforView.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "InforView.h"

@implementation InforView
{

    MasterDetailModel*_model;
}


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
    }

    return self;
}

-(void)setName:(NSString *)name{

    _name=name;
    UILabel*nameLabel=(UILabel*)[self viewWithTag:30];
    nameLabel.text=name;

}

-(void)setMobile:(NSString *)mobile{
    _mobile=mobile;
    UILabel*mobileLabel=(UILabel*)[self viewWithTag:31];
    mobileLabel.text=mobile;
}



-(void)createUI{

    NSArray*array=@[@"姓名",@"电话"];
    for (NSInteger i=0; i<array.count; i++) {
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:view];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 5+i*20, 150, 20)];
        label.tag=30+i;
        label.textColor=[UIColor blackColor];
        if (i==1) {
            label.textColor=[UIColor lightGrayColor];
        }
        label.font=[UIFont systemFontOfSize:14];
        [self addSubview:label];
    }
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 1, 100, 49)];
    button.backgroundColor=COLOR(21, 168, 234, 1);
    [button setImage:[UIImage imageNamed:@"打电话"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(phont) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}


-(void)phont{

    if (_mobile) {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [self sendRecond];
    }
}


-(void)sendRecond{

    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString*urlString=[self interfaceFromString:interface_phonerecommend];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject: [NSString stringWithFormat:@"%u",delegate.id] forKey:@"fromId"];
    [dict setObject:[NSString stringWithFormat:@"%lu",self.id] forKey:@"targetId"];
    [dict setObject:_mobile forKey:@"targetMobile"];
    if (_name) {
        [dict setObject:_name forKey:@"targetRealName"];
    }
    [dict setObject:@"user" forKey:@"callType"];
    [dict setObject:[NSString stringWithFormat:@"%u",delegate.id] forKey:@"workId"];
    NSDate*Date=[NSDate date];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*tiem=[formatter stringFromDate:Date];
    [dict setObject:tiem forKey:@"created"];
    
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];


}


@end
