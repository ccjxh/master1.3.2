//
//  InfoViewController.m
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "InfoViewController.h"
#import "requestModel.h"
#import "peopleDetailTableViewCell.h"
#import "peopleDetail2TableViewCell.h"
#import "peopleDetaileeTableViewCell.h"
#import "peopleDetail4TableViewCell.h"
#import "ReferrerCommentsCell.h"
#import "MasterDetailModel.h" //师傅详情model
#import "recommendInforTableViewCell.h"
#import "recommendInforModel.h"
#import "ReportTableViewCell.h"
#import "recommendViewController.h"
#import "informationDetail.h"


@interface InfoViewController ()
@end

@implementation InfoViewController
{
    
    peoplr*_valueModel; ///
    NSInteger _cityID;
    personDetailViewModel *masterDetailModel;
    informationDetail*inforView;//视图
    NSMutableArray*_dataType;//根据请求到的不同数组  做出不同的请求
   
}

-(instancetype)initWithCityId:(NSInteger)ID Peoplr:(peoplr *)model{
    if (self=[super init]) {
        
        _valueModel=model;
        _cityID=city;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  initUI];
    [self CreateFlow];
    [self requestMasterDetail];
    
}



-(void)initUI{
    
    if (!_dataType) {
        _dataType=[[NSMutableArray alloc]init];
    }
    inforView=[[informationDetail alloc]initWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, SCREEN_HEIGHT)];
    inforView.dataArray=_dataType;
    __weak typeof(self)weSelf=self;
    //举报按钮点击事件
    inforView.checkBlock=^{
        [weSelf report];
    };
    
    //点击照片预览
    
    inforView.starCaseDisplay=^(NSInteger index,UIImageView*tempImageview,personDetailViewModel*tempModel){
        NSMutableArray*temp=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",nil];
        NSArray*nameArray=@[@"siteFull",@"operateArea",@"masterWork"];
        for ( NSInteger i=0; i<3; i++) {
            certificateModel*model=[[certificateModel alloc]init];
            [model setValuesForKeysWithDictionary:[[tempModel.service objectForKey:@"starMasterProjectCase"][0] objectForKey:@"projectCaseList"][i]];
            NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
            if ([model.category isEqualToString:nameArray[0]]==YES) {
                [temp replaceObjectAtIndex:0 withObject:urlString];
            }else if ([model.category isEqualToString:nameArray[1]]==YES){
                
                [temp replaceObjectAtIndex:1 withObject:urlString];
            }else{
                [temp replaceObjectAtIndex:2 withObject:urlString];
            }
        }

        [weSelf displayPhotosWithIndex:index Tilte:@"证书" describe:nil ShowViewcontroller:weSelf UrlSarray:temp ImageView:tempImageview];
    
    };
    
    inforView.imageDisplay=^(NSInteger index,UIImageView*tempImageview,personDetailViewModel*tempModel){
        NSMutableArray*temp=[[NSMutableArray alloc]init];
            for (NSInteger i=0; i<tempModel.certificate.count; i++) {
                certificateModel*model=[[certificateModel alloc]init];
                [model setValuesForKeysWithDictionary:tempModel.certificate[i]];
                NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
                [temp addObject:urlString];
            }
            
            [weSelf displayPhotosWithIndex:index Tilte:@"证书" describe:nil ShowViewcontroller:weSelf UrlSarray:temp ImageView:tempImageview];
    };
    inforView.headImageBlock=^(NSString*urlString,peopleDetailTableViewCell*cell){
        NSMutableArray*tempArray=[[NSMutableArray alloc]initWithObjects:urlString, nil];
        [weSelf displayPhotosWithIndex:0 Tilte:nil describe:nil ShowViewcontroller:weSelf UrlSarray:tempArray ImageView:cell.master_headImage];
    };
    
    //拨打电话
    __weak typeof(MasterDetailModel*)weakModel=masterDetailModel;
    inforView.tableDisSelected=^(NSIndexPath*index,personDetailViewModel*tempModel){
        if (_dataType.count==3) {
            if (index.section==1&&index.row==1) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                NSString*urlString=[weSelf interfaceFromString:interface_phonerecommend];
                NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
                [dict setObject: [NSString stringWithFormat:@"%u",delegate.id] forKey:@"fromId"];
                [dict setObject:[NSString stringWithFormat:@"%lu",weakModel.id] forKey:@"targetId"];
                [dict setObject:tempModel.mobile forKey:@"targetMobile"];
                if (weakModel.realName) {
                    [dict setObject:weakModel.realName forKey:@"targetRealName"];
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
            
        }else if (_dataType.count==4){
            if (index.section==2&&index.row==1) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            
        }
        
    };
    
    self.view=inforView;

}


-(void)report{

    opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil Origin:nil Title:@"举报" Type:0 LimitCount:500 ID:_valueModel.id];
    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
}

#pragma mark - 请求师傅详情
-(void) requestMasterDetail
{
    [self flowShow];
    NSString *urlString = [self interfaceFromString:interface_masterDetail];
    NSDictionary *dict = @{@"userId":[NSNumber numberWithInteger:_valueModel.id],@"firstLocation":[NSNumber numberWithInteger:_cityID]};
    [[httpManager share] POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary *objDic=(NSDictionary *)responseObject;
        NSDictionary *entityDic = objDic[@"entity"];
        NSDictionary *userDic = entityDic[@"user"];
        masterDetailModel=[[personDetailViewModel alloc]init];
        masterDetailModel.teamScale=[[[[entityDic objectForKey:@"user"] objectForKey:@"service"] objectForKey:@"teamScale"] integerValue];
        [masterDetailModel setValuesForKeysWithDictionary:userDic];
        _dataType=[[NSMutableArray alloc]initWithObjects:@"基本信息",@"证书",@"基本资料",nil];
        if ([[masterDetailModel.service objectForKey:@"starMasterProjectCase"] count]>0) {
            [_dataType addObject:@""];
        }
        
        inforView.dataArray=_dataType;
        inforView.model=masterDetailModel;
        [inforView.tableview reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        [self.view makeToast:@"当前网络不好，请稍候重试" duration:1 position:@"center"];
    }];
    

}


@end
