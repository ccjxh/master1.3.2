//
//  findWorkDetail.m
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findWorkDetail.h"
#import "findWorkDetailTableViewCell.h"
#import "findWorkDetailSecondTableViewCell.h"
#import "commendTableViewCell.h"
#import "publicDetailOpinionTableViewCell.h"
#import "CustomDialogView.h"
#define FUNCTIONBUTTON_TAG 100
@implementation findWorkDetail
{
    UIView*_backView;
    UIButton*functionButton;//招工列表按钮
    UIButton*button;//招满按钮
    UILabel*realName;//
    UILabel*mobileLabel;

}

-(instancetype)initWithType:(NSInteger)type{

    if (self=[super init]) {
        self.type=type;
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    
    return self;
}

-(void)setModel:(findWorkDetailModel *)model{

    _model=model;
    if (model.auditState==2) {
        functionButton.backgroundColor=COLOR(22, 168, 234, 1);
    }else{
        functionButton.backgroundColor=[UIColor lightGrayColor];
    }
    if (_type==1) {
        realName.hidden=YES;
        NSString*Str;
        if (model.auditState==1) {
            Str=@"正在审核";
            mobileLabel.textColor=COLOR(245, 203, 33, 1);
        }
        else if (self.model.auditState==2){
            Str=@"审核通过";
            mobileLabel.textColor=[UIColor greenColor];
            
        }else if (self.model.auditState==3){
            
            Str=@"审核不通过";
            mobileLabel.textColor=[UIColor redColor];
        }
        if (model.auditState!=2) {
            functionButton.userInteractionEnabled=NO;
        }
        mobileLabel.frame=CGRectMake(mobileLabel.frame.origin.x, 15, mobileLabel.frame.size.width, 20);
       
        if (model.auditState==2) {
            [button setTitle:@"招满" forState:UIControlStateNormal];
            button.backgroundColor=COLOR(22, 168, 234, 1);
            if (model.FILLED_FLG==1) {
                [button setTitle:@"已招满" forState:UIControlStateNormal];
                button.userInteractionEnabled=NO;
                button.backgroundColor=[UIColor lightGrayColor];
            }
        }else{
            
             [button setTitle:@"招满" forState:UIControlStateNormal];
            button.backgroundColor=[UIColor lightGrayColor];
            button.userInteractionEnabled=NO;
        }
    }else{
        functionButton.hidden=YES;
        if (model.RECREIT_TYPE==1) {
            //招工报名
            [button setTitle:@"报名" forState:UIControlStateNormal];
            button.backgroundColor=COLOR(22, 168, 234, 1);
            if (model.FILLED_FLG==1) {
                [button setTitle:@"已招满" forState:UIControlStateNormal];
                button.userInteractionEnabled=NO;
                button.backgroundColor=[UIColor lightGrayColor];
            }
        }else{
            
            NSString*name=model.contacts;
            if (self.model.FILLED_FLG==1) {
                if (name) {
                    name=[name substringToIndex:1];
                    name=[NSString stringWithFormat:@"%@**",name];
                }
            }
            realName.text=[NSString stringWithFormat:@"%@",name];
            NSString*mobile=model.phone;
            if (self.model.FILLED_FLG==1) {
                mobile=[mobile substringToIndex:3];
                mobile=[NSString stringWithFormat:@"%@********",mobile];
            }
            mobileLabel.text=mobile;
            realName.hidden=NO;
            mobileLabel.hidden=NO;
            [button setTitle:@"电话" forState:UIControlStateNormal];
            button.backgroundColor=COLOR(22, 168, 234, 1);
            if (model.FILLED_FLG==1) {
                [button setTitle:@"已招满" forState:UIControlStateNormal];
                button.userInteractionEnabled=NO;
                button.backgroundColor=[UIColor lightGrayColor];
        
            }
    
        }
    
    }
}

-(void)initUI{
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-54)];
    self.tableview.separatorStyle=0;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    [self addSubview:self.tableview];
    self.tableview.backgroundColor=COLOR(240, 241, 242, 1);
    self.backgroundColor=self.tableview.backgroundColor;
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44+1, SCREEN_WIDTH, 1)];
    view.backgroundColor=COLOR(203, 203, 203, 1);
    [self addSubview:view];
     _backView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    _backView.backgroundColor=[UIColor whiteColor];
   realName=[[UILabel alloc]initWithFrame:CGRectMake(13, 3, 200, 20)];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    
    realName.textColor=[UIColor lightGrayColor];
    realName.backgroundColor=[UIColor clearColor];
    realName.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:realName];
    mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 20, 200, 20)];
    mobileLabel.backgroundColor=[UIColor clearColor];
    if (self.model) {
      mobileLabel.text=model.mobile;
    }
    mobileLabel.textColor=[UIColor lightGrayColor];
    mobileLabel.font=[UIFont systemFontOfSize:14];
    mobileLabel.tag=11;
    [_backView addSubview:mobileLabel];
    button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-26-20)/3, 0, (SCREEN_WIDTH-26)/3, 44)];
    if (_type==1) {
     [button setTitle:@"招满" forState:UIControlStateNormal];
        button.userInteractionEnabled=YES;
        if (self.model.auditState==1||self.model.auditState==3) {
        button.userInteractionEnabled=NO;
            
        }else{
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    
    }else{
        [button setTitle:@"电话" forState:UIControlStateNormal];
        button.userInteractionEnabled=YES;
    }
    
    if (self.model.FILLED_FLG==1) {
        [button setTitle:@"已招满" forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
    }
    
    
    functionButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-26)/3*2-10, 0,  (SCREEN_WIDTH-26)/3, 44)];
    [functionButton setTitle:@"招工列表" forState:UIControlStateNormal];
    if (_type!=1) {
        functionButton.hidden=YES;
    }
    if (self.model.auditState==2) {

    }
    functionButton.tag=FUNCTIONBUTTON_TAG;
    functionButton.titleLabel.font=[UIFont systemFontOfSize:14];
    functionButton.backgroundColor=COLOR(22, 168, 234, 1);
    [functionButton addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:functionButton];
    if (self.model.auditState==3) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
    
    }
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.backgroundColor=COLOR(22, 168, 234, 1);
    [button addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:button];
    _backView.userInteractionEnabled=YES;
    [self addSubview:_backView];
}


-(void)list:(UIButton*)button{

    if (self.list) {
        self.list();
    }

}

//拨打电话
-(void)phone:(UIButton*)button{
    
    if ([button.titleLabel.text isEqualToString:@"招满"]==YES) {
        
        NSString*Str1=@"招满后将不再对外公开招工联系人信息，是否继续?";
        NSString*Str2=@"招满后将不允许师傅在报名，是否继续?";
        NSString*message;
        if (self.model.RECREIT_TYPE==1) {
            message=Str2;
        }else{
            message=Str1;
        
        }
        
        
        if (self.model.auditState !=1&&self.model.auditState!=3) {
           
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:@"操作提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alter show];
            
            
//            CustomDialogView*cvc=[[CustomDialogView alloc]initWithTitle:@"操作提示" message:@"招满后将不允许师傅再报名，是否继续?" buttonTitles:@"确定",@"取消", nil];
//            __weak typeof(self)WeSelf=self;
//            [cvc showInView:self completion:^(NSInteger selectIndex) {
//                if (selectIndex==0) {
//                    
//                //
//                }else{
//                    
//                    [WeSelf.tableview reloadData];
//                }
//                
//            }];
            
        }
    }else if ([button.titleLabel.text isEqualToString:@"报名"]==YES){
        
        
        if (self.apply) {
            self.apply();
        }
        
    }else{
        
        [self makeToast:@"正在审核的单据不能操作" duration:1 position:@"center"];
    }
    
    return;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString*urlString=[self interfaceFromString:interface_phonerecommend];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject: [NSString stringWithFormat:@"%lu",delegate.id] forKey:@"fromId"];
    [dict setObject:[NSString stringWithFormat:@"%lu",self.model.id] forKey:@"targetId"];
    [dict setObject:self.model.phone forKey:@"targetMobile"];
    if ([self.model.publisher objectForKey:@"realName"]) {
        [dict setObject:[self.model.publisher objectForKey:@"realName"] forKey:@"targetRealName"];
    }
    [dict setObject:@"project" forKey:@"callType"];
    [dict setObject:[NSString stringWithFormat:@"%lu",delegate.id] forKey:@"workId"];
    NSDate*Date=[NSDate date];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*tiem=[formatter stringFromDate:Date];
    [dict setObject:tiem forKey:@"created"];
    
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        if (self.deleBlock) {
            
        self.deleBlock(self.model.id);
                            }

    }else{
    
    
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

   
     //这个地方需要优化,故留出如此结构代码  ^_^   ^_^   ^_^    ^_^
    if (self.model) {
    if (self.model) {
            if (_type==1) {
            if (self.model.auditState==3) {
                
                return 5;
            }
            
            return 4;
            
            }
        }
        
        return 4;
    }
    
    return 0;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.type==1&&self.model.auditState==3) {
        
        if (section==3) {
            if (self.model.RECREIT_TYPE==1) {
                return 0;
            }
            return 2;
        }
        
        return 1;
    }else if (self.type==1&&self.model.auditState!=3){
    
        if (section==2) {
            if (self.model.RECREIT_TYPE==1) {
                return 0;
            }
            return 2;
        }
        return 1;
    }
    
    if (self.type==0) {
    if (section==2) {
        if (self.model.RECREIT_TYPE==1) {
            return 0;
        }
        return 2;
        }
    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    
    if (self.model.auditState==3) {
        
        if (section==1||section==2||section==3||section==4) {
            if (self.model.RECREIT_TYPE==1) {
                if (section==3) {
                    return 0;
                }
            }
            return 30;
        }
        
        return 0;
    }

    if (section==0) {
        return 0;
    }
    
    if (section==3) {
        if (self.model.RECREIT_TYPE==1) {
            return 0;
        }
        return 14;
    }
    
    return 30;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.model.auditState==3) {
         NSArray*array=@[@"",@"招工详情",@"职位描述",@"发布人信息",@"",@"",@""];
        if (section==1||section==2||section==3) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(8, 14, SCREEN_WIDTH, 16)];
            label.textColor=COLOR(114, 114, 114, 1);
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.text=array[section];
            [view addSubview:label];
            return view;
        }
        
    }else{
    NSArray*array=@[@"",@"职位描述",@"",@"",@""];
        if (section==1||section==2) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(8, 14, SCREEN_WIDTH, 16)];
            label.textColor=COLOR(114, 114, 114, 1);
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.text=array[section];
            [view addSubview:label];
            return view;
    
        }
    
    }
    
    return nil;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.type==1) {
        if (self.model.auditState==3) {
            switch (indexPath.section) {
                case 0:
                    return [self returnBillStstusWith:tableView];
                    break;
                    case 1:
                    return [self returnPrimaryInfotmationWithTabelview:tableView];
                    break;
                    case 2:
                    return [self returnWorkpositiondescribeWithTableview:tableView];
                    break;
                    case 3:
                    return [self returnPublierWithTableview:tableView IndexPath:indexPath];
                    break;
                    case 4:
                    return [self returnBillNoWithTaleview:tableView];
                    break;
                default:
                    break;
            }
        }else{
        
            switch (indexPath.section) {
                case 0:
                    return [self returnPrimaryInfotmationWithTabelview:tableView];
                    break;
                    case 1:
                    return [self returnWorkpositiondescribeWithTableview:tableView];
                    break;
                    case 2:
                    return [self returnPublierWithTableview:tableView IndexPath:indexPath];
                    break;
                    case 3:
                    return [self returnBillNoWithTaleview:tableView];
                    break;
                    
                default:
                    break;
            }
        
        }
    }
    
    switch (indexPath.section) {
        case 0:
            return [self returnPrimaryInfotmationWithTabelview:tableView];
            break;
            case 1:
            return [self returnWorkpositiondescribeWithTableview:tableView];
            break;
            case 2:
            return [self returnPublierWithTableview:tableView IndexPath:indexPath];
            break;
            case 3:
            return [self returnReportWithTableview:tableView];
        default:
            break;
    }
    
    return nil;
}



-(UITableViewCell*)returnBillStstusWith:(UITableView*)tableView{

    publicDetailOpinionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"publicDetailOpinionTableViewCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"publicDetailOpinionTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.status.text=@"审核意见";
    cell.content.text=self.model.auditOpinion;
    cell.height.constant=[self accountStringHeightFromString:self.model.auditOpinion Width:SCREEN_WIDTH-20];
    cell.status.textColor=COLOR(85, 85, 85, 1);
    cell.content.textColor=COLOR(225, 0, 31, 1);
    return cell;

}

-(UITableViewCell*)returnPrimaryInfotmationWithTabelview:(UITableView*)tableView{

    findWorkDetailTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"findWorkDetailTableViewCell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"findWorkDetailTableViewCell" owner:nil options:nil]lastObject];
        Cell.selectionStyle=0;
    }
    if (self.model) {
        
        Cell.title.text=self.model.title;
        Cell.title.textColor=COLOR(0, 0, 0, 1);
        Cell.date.text=[self.model.publishTime componentsSeparatedByString:@" "][0];
        Cell.address.text=self.model.fullAddress;
        Cell.count.text=[NSString stringWithFormat:@"浏览量：%lu",self.model.pageView];
        Cell.pay.textColor=COLOR(238, 103, 29, 1);
        Cell.unit.textColor=COLOR(238, 103, 29, 1);
        Cell.addressHeight.constant=[self accountStringHeightFromString:[NSString stringWithFormat:@"%@%@",[self.model.workSite objectForKey:@"name"],self.model.address] Width:SCREEN_WIDTH-100]+5;
        Cell.peopleCount.text=[NSString stringWithFormat:@"%lu",self.model.peopleNumber];
        if ([[self.model.payType objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
            Cell.pay.text=@"面议";
            Cell.unit.hidden=YES;
        }else{
            
            Cell.pay.text=[NSString stringWithFormat:@"%lu",[self.model.pay integerValue]];
            Cell.payWidth.constant=Cell.pay.text.length*13;
            Cell.unit.text=[self.model.payType objectForKey:@"name"];
        }
        
    }
    
    [Cell reloadData];
    return Cell;
}

-(UITableViewCell*)returnWorkpositiondescribeWithTableview:(UITableView*)tableView{

    findWorkDetailSecondTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"findWorkDetailSecondTableViewCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"findWorkDetailSecondTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle=0;
        
    }
    if (self.model) {
        cell.content.text=self.model.workRequire;
    }
    
    return cell;

}

-(UITableViewCell*)returnPublierWithTableview:(UITableView*)tableview IndexPath:(NSIndexPath*)indexPath{

    NSArray*array=@[@"联  系  人",@"联系电话"];
    NSArray*placeArray;
    if (self.model) {
        placeArray=@[self.model.contacts,self.model.phone];
    }
        commendTableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"commendTableViewCell" owner:nil options:nil] lastObject];
            cell.name.text=array[indexPath.row];
            cell.nameToLeft.constant=0;
            if (self.model) {
                NSString*str=placeArray[indexPath.row];
                
                
                cell.content.text=placeArray[indexPath.row];
                if (str) {
                    if (_type==0&&self.model.FILLED_FLG==1) {
                        if (indexPath.row==0) {
                            NSString*newStr=[str substringToIndex:1];
                            newStr=[NSString stringWithFormat:@"%@**",newStr];
                            cell.content.text=newStr;
    
                        }else{
                        
                            NSString*newStr=[str substringToIndex:3];
                            newStr=[NSString stringWithFormat:@"%@**********",newStr];
                            cell.content.text=newStr;
                        
                        }
                        
                    }
                }
            }
            cell.selectionStyle=0;
            cell.name.font=[UIFont systemFontOfSize:15];
            cell.content.font=[UIFont systemFontOfSize:15];
            cell.content.textColor=[UIColor blackColor];
            cell.content.textAlignment=NSTextAlignmentLeft;
            cell.name.textColor=COLOR(114, 114, 114, 1);
            if (indexPath.row==0) {
                cell.topToSuperview.constant=4;
                cell.topToSuperVIew1.constant=4;
            }
            if (indexPath.row==1) {
                cell.topToSuperview.constant=-3;
                cell.topToSuperVIew1.constant=-3;
            }
            
            return cell;

        }
    return cell;
}

        
-(UITableViewCell*)returnReportWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"CELL"];
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.size.height/2-10, 60, 20)];
        [button setTitle:@"举报" forState:UIControlStateNormal];
        [button setTitleColor:COLOR(22, 168, 234, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    cell.selectionStyle=0;
    cell.textLabel.text=@"内容信息不符?";
    cell.textLabel.textColor=COLOR(114, 114, 114, 1);
    return cell;
    
}

-(UITableViewCell*)returnBillNoWithTaleview:(UITableView*)tableview{

    commendTableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"billNo"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"commendTableViewCell" owner:nil
                                         options:nil]lastObject];
    }
    cell.nameToLeft.constant=0;
    cell.name.text=@"订单编号";
    cell.name.font=[UIFont systemFontOfSize:15];
    cell.content.font=[UIFont systemFontOfSize:15];
    cell.topToSuperview.constant=4;
    cell.topToSuperVIew1.constant=4;
    cell.content.textAlignment=NSTextAlignmentLeft;
    cell.name.textColor=COLOR(114, 114, 114, 1);
    cell.content.textColor=[UIColor blackColor];
    cell.content.text=self.model.billsNo;
    return cell;

}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.model.auditState==3) {
        
        if (indexPath.section==0) {
            return 50+[self accountStringHeightFromString:self.model.auditOpinion Width:SCREEN_WIDTH-26];
        }
        
        if (indexPath.section==1) {
            if (self.model) {
                return 150+[self accountStringHeightFromString:[NSString stringWithFormat:@"%@%@",[self.model.workSite objectForKey:@"name"],self.model.address] Width:SCREEN_WIDTH-100]-17+30;
            }
            return 150+15;
        }
        if (indexPath.section==2) {
            if (self.model) {
                
                CGFloat height=[self accountStringHeightFromString:self.model.workRequire Width:SCREEN_WIDTH-20]+17;
                if (height<40) {
                    height=40;
                }
                return height;
            }
            
        }
        
        if (indexPath.section==3) {
           
            return 35;
            
        }
        
        return 40;

    }
    
    
    if (indexPath.section==0) {
        if (self.model) {
            return 150+[self accountStringHeightFromString:[NSString stringWithFormat:@"%@%@",[self.model.workSite objectForKey:@"name"],self.model.address] Width:SCREEN_WIDTH-100]-17+30;
        }
        return 150+15;
    }
    if (indexPath.section==1) {
        if (self.model) {
            
            CGFloat height=[self accountStringHeightFromString:self.model.workRequire Width:SCREEN_WIDTH-20]+17;
            if (height<40) {
                height=40;
            }
            return height;
        }
        
    }
    
    if (indexPath.section==2) {
       
        return 35;
        
    }
    
    return 40;

}

-(void)report{

    if (self.reportBlock) {
        self.reportBlock();
    }

}
@end
