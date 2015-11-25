//
//  MyserviceViewController.m
//  master
//
//  Created by jin on 15/5/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MyserviceViewController.h"
#import "introlduceChangeViewController.h"
#import "workStatusViewController.h"
#import "recommendViewController.h"
#import "TableViewCell.h"
#import "projectCaseAddViewController.h"
#import "PayViewController.h"
#import "projectCastDetailViewController.h"
#import "myServiceSelectedViewController.h"
#import "ChangeDateViewController.h"
#import "certainViewController.h"
#import "cityViewController.h"
#import "provinceViewController.h"
#import "proviceSelectedViewController.h"
#import "timetableviewCell.h"
#import "customOrderTableViewCell.h"
#import "nameViewController.h"
#import "ModifySexViewController.h"
#import "requestModel.h"
#import "MyServiceDetailModel.h"
#import "myServiceDetaiTableViewCell.h"
#import "MyserviceManager.h"



@interface MyserviceViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*noRecomandDataSource;//未认证的数据源
@property(nonatomic)NSMutableArray*managerDataSource;//项目经理的数据源
@property(nonatomic)NSMutableArray*headDataSource;//工头的数据源
@property(nonatomic)NSMutableArray*currentDataArray;
@property(nonatomic)NSMutableArray*skillArray;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSString* cityString;//城市名字
@property(nonatomic)NSString*townString;//地区名字
@property(nonatomic)CGFloat YPonit;//上次的高度
@property(nonatomic)CGFloat totleHeight;//服务的label总高度
@property(nonatomic)NSIndexPath*currentIndexPath;//当前选择indexPath
@property(nonatomic)NSInteger currentDate;//当前选择的日期
@property(nonatomic)UITextView*tx;
@end

@implementation MyserviceViewController
{
    UIView *_tagView;   //
    UIDatePicker *_DatePickerView;  //
    UIView *_titleView;
    NSString*date;
    UITableView*_payTableview;//支付tableview
    NSMutableArray*_payArray;//支付数据
    NSMutableArray*_recommendSkillArray;//已认证的技能数组
    UILabel*_reasonLabel;//被拒绝理由展示
    MyServiceDetailModel*_detaiModel;
    NSArray*_firstName;
    NSArray*_secondName;
    NSMutableArray*_firstArray;
    NSMutableArray*_secondArray;
    MyserviceManager*_manager;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self createManagr];
    }

    return self;
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.tableview reloadData];

}


#pragma mark-接收到通知后刷新UI
-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityInfprmatin:) name:@"city" object:nil];  //省市选择通知
    
}


-(void)reloadData{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (model.skillState==3) {
        _reasonLabel.text=[NSString stringWithFormat:@"被拒绝的原因是:%@",model.skillOpinion];
    }
    if (model.skillState!=3) {
        _reasonLabel.hidden=YES;
        self.topHeight.constant=64;
    }else{
        _reasonLabel.hidden=NO;
        self.topHeight.constant=84;
    }
}

-(void)update{
    
    [self request];   //网络请求
    
    [self initUI];    //UI搭建

}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"city" object:nil];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self customNaigationLeftButton];
    
    [super viewDidLoad];
    
    _manager.type=self.type;
    _manager.block=^(){
    
        [self add];
    
    };
    
    
    [self initData];   //设置数据源
    
    [self initUI];    //UI搭建
    
    [self CreateFlow];   //菊花
    
    [self request];

    
    [self disPalyReason];//展示被拒绝的原因
    
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self receiveNotice];

}


-(void)createManagr{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    NSString*buttonStatus;
    if (model.skill==0&&model.skillState==1){
        buttonStatus=@"申请中";
    }else{
        buttonStatus=@"成为宝师傅";
    }
    
    _manager=[[MyserviceManager alloc]initWithType:self.type Title:buttonStatus];
    if (buttonStatus==nil) {
        _manager=[[MyserviceManager alloc]initWithType:self.type Title:nil];
    }

}


-(void)add{
    
    certainViewController*pvc=[[certainViewController alloc]init];
    pvc.model=_detaiModel;
    NSMutableArray*temp=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<_detaiModel.certaionArray.count; i++) {
        if (i==0) {
            continue;
        }
        certificateModel*model=_detaiModel.certaionArray[i];
        [temp addObject:model];
    }
    pvc.dataArray=temp;
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
}



-(void)disPalyReason{

    _reasonLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 64, SCREEN_WIDTH-13, 20)];
    _reasonLabel.textColor=[UIColor blackColor];
    _reasonLabel.font=[UIFont systemFontOfSize:16];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refuse)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [_reasonLabel addGestureRecognizer:tap];
    [self reloadData];
    _reasonLabel.userInteractionEnabled=YES;
    [self.view addSubview:_reasonLabel];

}


-(void)refuse{

    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"拒绝理由" message:_reasonLabel.text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}


-(void)customNaigationLeftButton{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 36)];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, button.frame.size.height/2-7.5, 13, 21)];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"拐"];
    [button addSubview:imageview];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+5, imageview.frame.origin.y+1, 36, 20)];
    label.textColor=[UIColor whiteColor];
    label.text=@"返回";
    CGFloat size=[UIFont buttonFontSize];
    label.font=[UIFont systemFontOfSize:size];
    label.enabled=YES;
    label.userInteractionEnabled=NO;
    [button addSubview:label];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)pop{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];

}

#pragma mark-构建基本UI
-(void)initUI{
    
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableview.backgroundColor=COLOR(228, 228, 228, 1);
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    dispatch_async(dispatch_get_main_queue(), ^{
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
        if ([logModel.userPost integerValue]==2||[logModel.userPost integerValue]==3) {
            self.tableview.tableFooterView=nil;
            return;
        }
        NSString*buttonStatus;
        if (model.skill==0&&model.skillState==1){
            buttonStatus=@"申请中";
        }else{
            buttonStatus=@"成为宝师傅";
        }

        UIView*view=(id)[self.view viewWithTag:600];
        if (view) {
            [view removeFromSuperview];
        }
        if ([logModel.userPost integerValue]==1) {
            view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            view.tag=600;
            if (model.skill==0&&_currentDataArray!=_noRecomandDataSource) {
                UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
                button.backgroundColor=[UIColor orangeColor];
                [button setTitle:buttonStatus forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font=[UIFont systemFontOfSize:16];
                button.layer.cornerRadius=3;
                [button addTarget:self action:@selector(appication) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                view.userInteractionEnabled=YES;
                self.tableview.tableFooterView=view;
            }
        }

    });
   
    }


#pragma mark-提交按钮点击
-(void)appication{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    __block PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (model.realName==nil) {
        [self.view makeToast:@"请填写完姓名在提交" duration:1.5f position:@"center"];
        return;
    }
    
    if (model.age==0) {
        [self.view makeToast:@"请选择年龄后在提交" duration:1.5f position:@"center"];
        return;

    }
    if (model.gendar==nil) {
        [self.view makeToast:@"请选择性别后在提交" duration:1.5f position:@"center"];
        return;
    }
    
    if (_detaiModel.startWork==nil) {
        [self.view makeToast:@"从业时间不能为空" duration:1 position:@"center"];
        return;
    }
    if (_detaiModel.servicerSkills.count==0) {
        [self.view makeToast:@"请选择技能后在提交认证" duration:1 position:@"center"];
        return;
    }
    
    if (_detaiModel.areaArray.count==0) {
        [self.view makeToast:@"请选择服务区域后在提交认证" duration:1 position:@"center"];
        return;
    }
    
    if ([_detaiModel.payType objectForKey:@"id"]==0) {
        [self.view makeToast:@"薪资期望不能为空" duration:1 position:@"center"];
        return;
    }
    
    if (!_detaiModel.prjectCase) {
        [self.view makeToast:@"过往工地不能为空" duration:1 position:@"center"];
        return;
    }
    
    NSString*urlString=[self interfaceFromString:interface_attestation];
    NSDictionary*dict=@{@"skillType":[NSString stringWithFormat:@"%lu",self.type+1]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"已经提交审核" duration:1 position:@"center" Finish:^{
              model.skillState=1;
              model.certification =[self getDictoryWithModel:model];
               [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
                [self initUI];
                }];
        }else{
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }

        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

//构建列表数据
-(void)initData{

    if (!_noRecomandDataSource) {
        NSArray*Array=@[@"师傅",@"工长"];
        _noRecomandDataSource=[[NSMutableArray alloc]initWithObjects:Array, nil];
    }
    if (!_managerDataSource) {
        NSArray*array1=@[@""];
        NSArray*Array2=@[@"专业技能"];
        NSArray*array3=@[@"服务区域"];
        NSArray*array4=@[@"证书",@"服务介绍",@"薪资期望"];
        NSArray*array5=@[@"工作状态"];
//        NSArray*array6=@[@""];
        _managerDataSource=[[NSMutableArray alloc]initWithObjects:array1,Array2,array3,array4,array5, nil];
        
    }
    if (!_headDataSource) {
        NSArray*array1=@[@""];
        NSArray*Array2=@[@"专业技能"];
        NSArray*array3=@[@"服务区域"];
        NSArray*array4=@[@"证书",@"服务介绍",@"薪资期望"];
        NSArray*array5=@[@"工作状态"];
        _firstArray=[[NSMutableArray alloc]initWithObjects:@"待完善",@"待完善",@"待完善", nil];
         _secondArray=[[NSMutableArray alloc]initWithObjects:@"待完善",@"待完善",@"待完善", @"待完善",@"待完善",@"待完善",@"待完善",@"待完善",@"待完善",nil];
//        NSArray*array6=@[@""];
        _headDataSource=[[NSMutableArray alloc]initWithObjects:array1,Array2,array3,array4,array5, nil];
    }
}


//请求个人详情
-(void)request{
    
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_myServicerDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSMutableArray*areaArray=[[NSMutableArray alloc]init];
       _detaiModel=[[MyServiceDetailModel alloc]init];
        
       [_detaiModel setValuesForKeysWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"]];
        
        
        _detaiModel.certificate=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"certificate"];
        
        
        
        for (NSInteger i=0; i<_detaiModel.allServiceRegions.count; i++) {
            
            NSDictionary*dict1=_detaiModel.allServiceRegions[i];
            NSString*tempString=dict1.allKeys[0];
            NSArray*array=[tempString componentsSeparatedByString:@"id\":"];
            AreaModel*model=[[AreaModel alloc]init];
            model.id=[[array[1] componentsSeparatedByString:@","][0] integerValue];
            NSArray* cityArray=[tempString componentsSeparatedByString:@"name\":\""];
            model.name=[cityArray[1] componentsSeparatedByString:@"\""][0];
            NSMutableArray*secondArray=[[NSMutableArray alloc]init];
            [secondArray addObject:model];
            NSArray*detailArray=[dict1 objectForKey:tempString];
            for (NSInteger j=0; j<detailArray.count; j++) {
                AreaModel*citymodel=[[AreaModel alloc]init];
                citymodel.isselect=YES;
                [citymodel setValuesForKeysWithDictionary:detailArray[j]];
                [secondArray addObject:citymodel];
                }
            [areaArray addObject:secondArray];
        }
        _detaiModel.areaArray=areaArray;
        NSMutableArray*cerDict=[[NSMutableArray alloc]init];
        [cerDict addObject:@""];
      for (NSInteger i=0; i<_detaiModel.certificate.count; i++) {
          NSDictionary*tempDict=_detaiModel.certificate[i];
          certificateModel*tempModel=[[certificateModel alloc]init];
          [tempModel setValuesForKeysWithDictionary:tempDict];
          [cerDict addObject:tempModel];
      }
        _detaiModel.certaionArray=cerDict;
        _manager.model=_detaiModel;
        [_tableview reloadData];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];

   }];
}




#pragma mark-tableview代理相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 3;
    }
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if ([logModel.userPost integerValue]==3) {
        return 11;
    }
    
    if (model.skill==0) {
        if (self.type==0) {
            return 10;
        }else{
        
            return 11;
        }
    }
    
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_manager getCellFromtableview:tableView IndexPath:indexPath];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor=COLOR(228, 228, 228, 1);
    UILabel*label=[[UILabel alloc]initWithFrame:view.bounds];
    NSString*tempString;
        NSArray*array=@[@"    基本资料",@"    服务信息",@"  服务区域",@"  证书",@"",@""];
       tempString=array[section];
       label.text=tempString;
    label.font=[UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
            return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if (indexPath.section==0) {
        return 44;
    }else{
        
        switch (indexPath.row) {
                
            case 9:
            {
                if ([logModel.userPost integerValue]==1&&(model.skillState==0||model.skillState==3||model.skillState==1)&&(self.type==0||model.certifyType==2)||[logModel.userPost integerValue]==2) {
                    return [self accountPicture];
                    
                }
            }
                break;
            case 10:
            {
                return [self accountPicture];
                
            }
            default:
                break;
        }
        
    }
    
    return 44;
    

}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//  }
//


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    __block PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    _currentIndexPath=indexPath;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                nameViewController*nvc=[[nameViewController alloc]initWithNibName:@"nameViewController" bundle:nil];
                if (model.realName) {
                    nvc.origin=model.realName;
                }
                nvc.contentChange=^(NSString*name){
                    model.realName=name;
                    model.certification=[self getDictoryWithModel:model];
                    [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
                    [_tableview reloadData];
                };
                
                [self pushWinthAnimation:self.navigationController Viewcontroller:nvc];
                cell.selectionStyle=0;
            }
                break;
            case 2:
            {
                if (model.personal==1||model.personalState==1||model.personalState==3) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
                cvc.isfuture=YES;
                cvc.isPass=YES;
                if (model.birthday) {
                    cvc.oldDate=model.birthday;
                }
                
                cvc.blockDateValue=^(NSString*date){
                    [self flowShow];
                    NSString*urlString=[self interfaceFromString:interface_updateBirthday];
                    NSArray*temp=[date componentsSeparatedByString:@"-"];
                    NSString*birthday=[NSString stringWithFormat:@"%@/%@/%@",temp[0],temp[1],temp[2]];
                    NSDictionary*dict=@{@"birthday":birthday};
                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                        NSDictionary*dict=(NSDictionary*)responseObject;
                        [self flowHide];
                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                            
                            if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                                logModel.integrity=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ;
                                [[dataBase share]updatePrimaryInforWithModel:logModel];
                                if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                                    logModel.integral= [[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] ;
                                    [[dataBase share]updatePrimaryInforWithModel:logModel];
                                    NSDictionary*parent=@{@"value":[NSString stringWithFormat:@"%lu",[logModel.integral integerValue]]};
                                    NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                                    [[NSNotificationCenter defaultCenter]postNotification:noction];
                                }
                            }
                            
                            model.age=[self getAgeFromDate:date];
                            [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
                            [_tableview reloadData];
                            [self.view makeToast:@"更新成功" duration:1 position:@"center" Finish:^{
                            }];
                        }else{
                            
                            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                        [self flowHide];
                        [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
                    }];
                };
                
                [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
                cell.selectionStyle=0;

            }
                break;
            case 1:
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                if (model.personal==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                ModifySexViewController *ctl = [[ModifySexViewController alloc] init];
                ctl.gendarValueBlock = ^(long gendarId,long tag){
                    NSString *urlString = [self interfaceFromString:interface_updateGendar];
                    NSDictionary *dict = @{@"gendar":[NSString stringWithFormat:@"%lu",gendarId]};
                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                        NSDictionary*dict=(NSDictionary*)responseObject;
                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                            NSString*content;
                            if (gendarId == 0)
                            {
                                content = @"男";
                            }
                            else
                            {
                                content = @"女";
                            }
                            model.gendar=content;
                            model.certification=[self getDictoryWithModel:model];
                            [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
                            [_tableview reloadData];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                        
                    }];
                    
                };
                
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
                cell.selectionStyle=0;

            }
                break;
                
            default:
                break;
        }
    }else{
        
        switch (indexPath.row) {
            case 1:
            {
                skillSelectViewController*svc=[[skillSelectViewController alloc]init];
                svc.Array=_detaiModel.servicerSkills;
                svc.model=_detaiModel;
                svc.skillArray=^(NSMutableArray*array){
                    NSString*valuerString;
                    for (NSInteger i=0; i<array.count; i++) {
                        skillModel*model=[[skillModel alloc]init];
                        [model setValuesForKeysWithDictionary:array[i]];
                        if (i==0) {
                            valuerString=[NSString stringWithFormat:@"%lu",model.id];
                        }else{
                            valuerString=[NSString stringWithFormat:@"%@,%lu",valuerString,model.id];
                        }
                    }
                    [self flowShow];
                    NSDictionary*dict;
                    if (valuerString==nil) {
                        dict=@{@"skill":@"0"};
                    }else{
                        dict=@{@"skill":valuerString};
                    }
                    NSString*urlString=[self interfaceFromString:interface_updateServicerSkill];
                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                        NSDictionary*dict=(NSDictionary*)responseObject;
                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                            [self flowHide];
                            [self.view makeToast:@"技能更新成功" duration:1 position:@"center" Finish:^{
                                //                              [self request];
                                
                            }];
                        }
                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                        [self flowHide];
                    }];
                };
                [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
                cell.selectionStyle=0;

            }
                break;
            case 2:
            {
                
                _currentIndexPath=indexPath;
                [self selectedDate];
            }
                break;
            case 3:
            {
                //
                proviceSelectedViewController*pvc=[[proviceSelectedViewController alloc]initWithNibName:@"proviceSelectedViewController" bundle:nil];
                pvc.model=_detaiModel;
                pvc.selectArray=_detaiModel.areaArray;
                [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                cell.selectionStyle=0;

                
            }
                break;
            case 4:
            {
                [self setPayType];
                
            }
                break;
            case 5:
            {
                opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
                ovc.limitCount=300;
                ovc.origin=_detaiModel.serviceDescribe;
                ovc.model=_detaiModel;
                if ([logModel.userPost integerValue]==3||(model.skill==0&&self.type==1)) {
                    
                    ovc.type=7;
                }else{
                    
                    ovc.type=8;
                }
                ovc.model=_detaiModel;
                [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
                cell.selectionStyle=0;

            }
                break;
            case 6:
            {
                
                _currentIndexPath=indexPath;
                [self setupWorkStatus];
                
            }
                break;
                case 7:
            {
                [self setOpinionWithIndexPath:0];
            
            }
                break;
                case 8:
            {
            
                [self setOpinionWithIndexPath:1];
            }
                break;
                case 9:
            {
            
                if ([logModel.userPost integerValue]==2) {
                    _currentIndexPath=indexPath;
                    certainViewController*pvc=[[certainViewController alloc]init];
                    pvc.model=_detaiModel;
                    NSMutableArray*temp=[[NSMutableArray alloc]init];
                    for (NSInteger i=0; i<_detaiModel.certaionArray.count; i++) {
                        if (i==0) {
                            continue;
                        }
                        certificateModel*model=_detaiModel.certaionArray[i];
                        [temp addObject:model];
                    }
                    pvc.dataArray=temp;
                    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                    cell.selectionStyle=0;
                    return;
                }
                
                if ([logModel.userPost integerValue]==3) {

                    [self setOpinionWithIndexPath:2];

                    return;
                }
                
                if ([logModel.userPost integerValue]==1&&(model.skillState==0||model.skillState==3||model.skillState==1)) {
                    if (_type==1||model.certifyType==3) {
                        [self setOpinionWithIndexPath:2];
                    }else{
                        
                _currentIndexPath=indexPath;
                 certainViewController*pvc=[[certainViewController alloc]init];
                 pvc.model=_detaiModel;
                 NSMutableArray*temp=[[NSMutableArray alloc]init];
                 for (NSInteger i=0; i<_detaiModel.certaionArray.count; i++) {
                     if (i==0) {
                         continue;
                     }
                     certificateModel*model=_detaiModel.certaionArray[i];
                     [temp addObject:model];
                 }
                 pvc.dataArray=temp;
                 [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                        cell.selectionStyle=0;

                    }
                    
                }
                
            }
                break;
            case 10:
            {
                _currentIndexPath=indexPath;
                certainViewController*pvc=[[certainViewController alloc]init];
                pvc.model=_detaiModel;
                NSMutableArray*temp=[[NSMutableArray alloc]init];
                for (NSInteger i=0; i<_detaiModel.certaionArray.count; i++) {
                    if (i==0) {
                        continue;
                    }
                    certificateModel*model=_detaiModel.certaionArray[i];
                    [temp addObject:model];
                }
                pvc.dataArray=temp;
                [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                cell.selectionStyle=0;

            }
                break;
            default:
                break;
        }
        
    }
   
}

-(void)setOpinionWithIndexPath:(NSInteger)indexPath{
    NSIndexPath*tempIndexPath=[NSIndexPath indexPathForRow:indexPath inSection:1];
    UITableViewCell*cell=[self.tableview cellForRowAtIndexPath:tempIndexPath];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    __block PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];

    NSString*prjectCase,*buyer,*teamScale;
    if (_detaiModel.prjectCase) {
        prjectCase=_detaiModel.prjectCase;
    }else{
        prjectCase=@"";
    }
    
    if (_detaiModel.buyer) {
        buyer=_detaiModel.buyer;
    }else{
        buyer=@"";
    }
    if (_detaiModel.teamScale) {
        teamScale=_detaiModel.teamScale;
    }else{
        
        teamScale=@"";
    }
    
    NSArray*origin=@[prjectCase,buyer,teamScale];
    opinionViewController*ovc;
    if (indexPath==0||indexPath==1) {
      ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil Origin:origin[indexPath] Title:@"更新资料" Type:1 LimitCount:200 ID:0];
        ovc.limitCount=100;
        if ([logModel.userPost integerValue]==3||(model.skill==0&&self.type==1)) {
            if (indexPath==0) {
                ovc.type=4;
            }
            
            if (indexPath==1) {
                ovc.type=6;
            }
            
        }else{
        
            if (indexPath==0) {
                ovc.type=5;
            }
            
            if (indexPath==1) {
                ovc.type=6;
            }
        }
        
        if (indexPath==2) {
            ovc.type=2;
        }
        ovc.contentBlock=^(NSString*content){
        
            switch (indexPath) {
                case 0:
                    _detaiModel.prjectCase=content;
                    [self senddataWithIndexPath:0 Content:content];
                    break;
                    case 1:
                    _detaiModel.buyer=content;
                    [self senddataWithIndexPath:1 Content:content];
                    break;
                default:
                    break;
            }
        
            };
    }else{
    
        ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil Origin:origin[indexPath] Title:@"更新资料" Type:2 LimitCount:5 ID:0];
        ovc.type=2;
        if (_detaiModel.teamScale) {
            ovc.origin=_detaiModel.teamScale;
            
            
        }
        ovc.limitCount=5;
        ovc.contentBlock=^(NSString*content){
            _detaiModel.teamScale=content;
            [self senddataWithIndexPath:2 Content:content];
        
        };
    }
    
    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
    cell.selectionStyle=0;

}


-(void)senddataWithIndexPath:(NSInteger)indexPath Content:(NSString*)content{

    NSArray*Array=@[[self interfaceFromString:interface_updatePrjectCase],[self interfaceFromString:interface_updateBuyer],[self interfaceFromString:interface_updateTeamScale]];
    NSArray*keyArray=@[@"prjectCase",@"buyer",@"teamScale"];
    NSDictionary*dict=@{keyArray[indexPath]:content};
    [self flowShow];
    [[httpManager share]POST:Array[indexPath] parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"更新成功" duration:1 position:@"center"];
            [_tableview reloadData];
        }else{
            
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        [self.view makeToast:@"当前网络不给力,请稍后重试" duration:1 position:@"center"];
    }];

}

//日期选择
-(void)selectedDate{

    _currentDataArray=_managerDataSource;
    ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
    if (_detaiModel.startWork) {
        cvc.oldDate=_detaiModel.startWork;
    }
    if (_currentIndexPath.section==1) {
        if (_currentIndexPath.row==2) {
            
        cvc.isPass=YES;
        cvc.isfuture=YES;
        cvc.isShowMessage=NO;
            
        }else{
        
            cvc.isShowMessage=YES;
        }
    }
    cvc.blockDateValue=^(NSString*date){
       
        NSString*urlString=[self interfaceFromString:interface_updateStartWork];
        [self flowShow];
        NSArray*sepArray=[date componentsSeparatedByString:@"-"];
        NSString*temp=[NSString stringWithFormat:@"%@/%@/%@",sepArray[0],sepArray[1],sepArray[2]];
          NSDictionary*dict=@{@"startWork":temp};
        if (_currentIndexPath.row==6) {
            urlString=[self interfaceFromString:interface_updateStatus];
            dict=@{@"status":@"1",@"freeDate":temp};
        }
        
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
               
                    [self request];
                
            }else{
            
                [self flowHide];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
            [self.view makeToast:@"当前网络状况不好，请稍后重试" duration:1   position:@"center"];
            
        }];
        
    };
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];

}



//薪资期望点击事件
-(void)setPayType{
    PayViewController*pvc=[[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    pvc.model=_detaiModel;
    pvc.expectBlock=^{
        
            };
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];

}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (textView.text.length>=800) {
        return NO;
    }
    if (textView.text.length < 800){
        
        return YES;
    }
    
    return NO;

}


-(void)changeDEsscribe
{
    //改变说明
    
    if (_tx.text.length==0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _detaiModel.serviceDescribe=_tx.text;
    NSDictionary*dict=@{@"describe":_tx.text};
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_updateServiceDescribe];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                [self request];
                [self flowHide];
            }];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        
    }];

}

//设置工作状态
-(void)setupWorkStatus{

    
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"工作状态选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"空闲" otherButtonTitles:@"繁忙", nil];
    sheet.tag=300;
    [sheet showInView:self.view];
    
}



-(void)setStatus:(UIButton*)button{
  
    if (button.tag==700) {
        NSDictionary*dict;
        dict=@{@"status":@"0"};
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_updateStatus];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
            [[KGModal sharedInstance]hideAnimated:YES];
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                   
                    [self request];
                    [self flowHide];
                }];
               
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
           
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
                       [self flowHide];

        }];
        
    }else if (button.tag==701){
        _currentDate=1;
        [[KGModal sharedInstance] hide];
        [self selectedDate];
    }
}

#pragma mark-cell设置
//技能
    //技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView  SkillArray:(NSMutableArray*)skillArray{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
        }
        cell.textLabel.text=@"技能";
        if (_detaiModel.servicerSkills.count==0) {
            cell.detailTextLabel.text=@"点击选择技能";
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
            return cell;
        }
    
        UIView*view=(id)[cell.contentView viewWithTag:31];
        if (view) {
            [view removeFromSuperview];
        }
        
        view=[[UIView alloc]initWithFrame:cell.bounds];
        view.tag=31;
        cell.detailTextLabel.text=@"";
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        NSInteger orginX = 0;
        for (NSInteger i=0; i<_detaiModel.servicerSkills.count; i++) {
            skillModel*model=[[skillModel alloc]init];
            [model setValuesForKeysWithDictionary:_detaiModel.servicerSkills[i]];
            NSInteger width=(SCREEN_WIDTH-110-30)/3;
            if (i!=0&&i%3==0) {
                orginX=0;
            }
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 10+i/3*30,model.name.length*12+5, 25)];
            if (i/3!=0) {
                label.frame=CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 10+i/3*30,model.name.length*12+5, 25);
            }
            
            if (label.frame.origin.x<100) {
                CGFloat tempWidth=SCREEN_WIDTH-orginX-30-5;
                label.frame=CGRectMake(100, label.frame.origin.y,tempWidth-100-5, label.frame.size.height);
            }
            orginX+=model.name.length*12+10;
            width=label.frame.origin.x+label.frame.size.width+5;
            label.text=model.name;
            label.tag=12;
            label.font=[UIFont systemFontOfSize:12];
            label.layer.borderWidth=1;
            label.numberOfLines=0;
            label.layer.cornerRadius=4;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor lightGrayColor];
            label.layer.borderColor=[UIColor lightGrayColor].CGColor;
            label.layer.borderWidth=1;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            label.enabled=YES;
            label.userInteractionEnabled=NO;
            [view addSubview:label];
            [cell.contentView addSubview:view];
        }
    return cell;
}



//服务区域
-(UITableViewCell*)getServiceCellWithTableview:(UITableView*)tableView{
    customOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"customOrderTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.function.text=@"服务区域";
    NSString*Str;
    for (NSInteger i=0; i<_detaiModel.areaArray.count; i++) {
            NSMutableArray*array=_detaiModel.areaArray[i];
                for (NSInteger j=1; j<array.count; j++) {
                AreaModel*model=array[j];
                if (i==0||j==1) {
                    Str=model.name;
            
                }else{
                
                    Str=[NSString stringWithFormat:@"%@、%@",Str,model.name];
                }
            }
            
            if (!Str) {
                Str=@"点击选择服务区域";
            }
        }
    cell.content.text=Str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}


//证书
-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell1"];
    }
    UIView*view=(id)[self.view viewWithTag:45];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=45;
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, cell.frame.size.height/2-10, 100, 20)];
    label.text=@"证书";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    [view addSubview:label];
    NSInteger width=(SCREEN_WIDTH-40-100)/4;
       for (NSInteger i=0; i<_detaiModel.certaionArray.count; i++) {
        CGFloat height;
              if (i==0) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
            [button setImage:[UIImage imageNamed:@"增加图片"] forState:UIControlStateNormal];
            [button addTarget: self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            continue;
        }
          
        certificateModel*model=_detaiModel.certaionArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (_detaiModel.certaionArray.count%4==0) {
            height=_detaiModel.certaionArray.count/4*40;
        }
        else{
            height=(_detaiModel.certaionArray.count/4+1)*40;
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
        imageview.tag=20+i;
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds=YES;
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [view addSubview:imageview];
    }
    view.userInteractionEnabled=YES;
    cell.userInteractionEnabled=YES;
    cell.selectionStyle=0;
    [cell.contentView addSubview:view];
    return cell;
}






#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (actionSheet.tag==300) {
        if (buttonIndex==0) {
            //空闲
            NSDictionary*dict;
            dict=@{@"status":@"0"};
            [self flowShow];
            NSString*urlString=[self interfaceFromString:interface_updateStatus];
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                [[KGModal sharedInstance]hideAnimated:YES];
                [self flowHide];
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                        
                        _detaiModel.workStatus=@"空闲";
                        [self.tableview reloadData];
                    
                    }];
                    
                }else{
                    
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
                
                
                
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                
                [self flowHide];
                
            }];
            
        }else if(buttonIndex==1){
            
            _currentDate=1;
            [[KGModal sharedInstance] hide];
            [self selectedDate];
            
        }
        
        return;
        
    }
    
}



#pragma mark-计算cell高度
/**计算证书高度*/
-(CGFloat)accountPicture{
    
    CGFloat height;
     NSInteger width=(SCREEN_WIDTH-140)/4;
    if (_detaiModel.certaionArray.count==0) {
        return 44;
    }
    if (_detaiModel.certaionArray.count%4==0) {
        height=_detaiModel.certaionArray.count/4*width+20;
    }
    else{
        height=(_detaiModel.certaionArray.count/4+1)*width+20;
    }
    return height+10;
    
}
/**计算服务区域高度*/
-(CGFloat)accountservice{

    if (_detaiModel.areaArray.count==0) {
        return 44;
    }
    _totleHeight=0;
    for (NSInteger i=0; i<_detaiModel.areaArray.count; i++) {
        NSMutableArray*array=_detaiModel.areaArray[i];
        for (NSInteger j=0; j<array.count; j++) {
            AreaModel*model=array[j];
            if (j==0) {
                _cityString=[NSString stringWithFormat:@"%@:",model.name];
            }
            else if (j==1) {
                
                _townString=model.name;
                
            }
            else if (j==array.count-1){
                if (i==_detaiModel.areaArray.count-1) {
                    _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
                }
                else{
                    _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
                }
                
            }
            else{
                _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
            }
            
        }
        
        CGFloat height=[self accountStringHeightFromString:_townString Width:SCREEN_WIDTH-140];
        _totleHeight+=height;
        
    }
    
    return _totleHeight+20;

}

/**计算服务介绍高度*/
-(CGFloat)accountIntrolduce{

    if (_detaiModel.serviceDescribe.length==0||[self accountStringHeightFromString:_detaiModel.serviceDescribe Width:SCREEN_WIDTH-150 FrontSize:14]+20<44) {
        return 44;
    }
    
    return [self accountStringHeightFromString:_detaiModel.serviceDescribe Width:SCREEN_WIDTH-150 FrontSize:14]+20;
}


@end
