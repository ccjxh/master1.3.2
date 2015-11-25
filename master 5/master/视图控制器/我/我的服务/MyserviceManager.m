//
//  MyserviceManager.m
//  master
//
//  Created by jin on 15/11/4.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "MyserviceManager.h"
#import "myServiceDetaiTableViewCell.h"

@implementation MyserviceManager
{
    NSString*_title;
  
}


-(void)setType:(NSInteger)type{

    _type=type;

}
-(instancetype)initWithType:(NSInteger)type Title:(NSString *)title{

    if (self=[super init]) {
        _type=type;
        _title=title;
    }

    return self;
}

/**
 *  得到tabelviewde cell
 *
 */
-(UITableViewCell*)getCellFromtableview:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath{

    myServiceDetaiTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"myServiceDetaiTableViewCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"myServiceDetaiTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.contentToTop.constant=10;
    cell.contentToBottom.constant=10;
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (model.personal==1||(model.personal==0&&model.personalState==1)) {
            cell.accessoryType=0;
            cell.liadToRight.constant=13;
            cell.selectionStyle=UITableViewCellAccessoryNone;
        }else{
        
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.liadToRight.constant=-3;
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.name.text=@"姓名";
                if (model.realName) {
                    cell.content.text=model.realName;
                }else{
                    
                    cell.content.text=@"点击填写姓名(必填项)";
                }
                return cell;
                
            }
                break;
            case 2:
            {
                cell.name.text=@"年龄";
                if ([model.age integerValue]==0) {
                    cell.content.text=@"点击选择年龄(必填项)";
                }else{
                    
                    cell.content.text=model.age;
                }
                
                return cell;
            }
                break;
            case 1:
            {
                cell.name.text=@"性别";
                cell.content.text=model.gendar;
                return cell;
            }
                break;
            default:
                break;
        }
        
    }else{
        cell.liadToRight.constant=-3;
        switch (indexPath.row) {
            case 0:
            {
                
                cell.selectionStyle=0;
                cell.accessoryType = 0;
                cell.liadToRight.constant=13;
                cell.name.text=@"岗位";
                if ([logModel.userPost integerValue]==1) {
                if ([_title isEqualToString:@"成为宝师傅"]==YES||[_title isEqualToString:@"申请中"]==YES) {
                    if (_type==0) {
                        cell.content.text=@"师傅";
                    }else if (_type==1){
                        cell.content.text=@"工长";
                    }
                }
                   
                }else{
                    if ([logModel.userPost integerValue]==1) {
                        cell.content.text=@"雇主";
                    }else if ([logModel.userPost integerValue]==2){
                        
                        cell.content.text=@"师傅";
                    }else if ([logModel.userPost integerValue]==3){
                        cell.content.text=@"工长";
                    }
                }
                return cell;
                
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.name.text=@"技能";
                if ([self getAllSkillString]) {
                    cell.content.text=[self getAllSkillString];

                }else{
                
                    cell.content.text=@"点击选择技能(必填项)";
                }
                return cell;
                
            }
                break;
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.name.text=@"从业时间";
                if (_model.startWork) {
                    cell.content.text=_model.startWork;
                }else{
                    
                    cell.content.text=@"请选择从业时间(必填项)";
                }
                
                return cell;
                
            }
                break;
            case 3:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.name.text=@"服务区域";
                if ([self getServiceString]) {
                    cell.content.text=[self getServiceString];
                }else{
                
                cell.content.text=@"点击选择服务区域(必填项)";
                }
                return cell;
                
            }
                break;
            case 4:
            {
                cell.name.text=@"期望薪资";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                payModel*pModel=[[payModel alloc]init];
                [pModel setValuesForKeysWithDictionary:_model.payType];
                if (pModel.name) {
                        if ([pModel.name isEqualToString:@"面议"]==YES) {
                            cell.content.text=pModel.name;
                        }else{
                            cell.content.text=[NSString stringWithFormat:@"%.2ld%@",_model.expectPay,pModel.name];
                        }
                }else{
                
                cell.content.text=@"请填写期望薪资(必填项)";
                }
                
                return cell;
            }
                break;
            case 5:
            {
                
                cell.name.text=@"服务介绍";
                if (_model.serviceDescribe) {
                    cell.content.text=_model.serviceDescribe;
                }else{
                cell.content.text=@"请填写服务介绍(必填)";
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.liadToRight.constant=-10;
                return cell;
                
            }
                break;
            case 6:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.name.text=@"日程";
                if (_model.workStatus) {
                    cell.content.text=_model.workStatus;
                }else{
                    
                    cell.content.text=@"点击选择日程(必选项)";
                }
                return cell;
                
            }
                break;
                
            case 7:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if ([logModel.userPost integerValue]==3||(model.skill==0&&_type==1)||(model.skill==1&&_type==1)) {
                    
                cell.name.text=@"成功案例";
                    if (_model.prjectCase) {
                        cell.content.text=_model.prjectCase;
                    }else{
                        
                        cell.content.text=@"请成功案例(必填项)";
                        
                    }

                    
                }else{
                    cell.name.text=@"过往工地";
                    if (_model.prjectCase) {
                        cell.content.text=_model.prjectCase;
                    }else{
                        
                        cell.content.text=@"请成功案例(必填项)";
                        
                    }

                }
                
                return cell;
                
            }
                break;
            case 8:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.name.text=@"曾合作雇主";
                if (_model.buyer) {
                    cell.content.text=_model.buyer;
                }else{
                    cell.content.text=@"请填曾合作的雇主";
                }
                return cell;
            }
                
                break;
            case 9:
                {
                    
                    
                    if ([logModel.userPost integerValue]==3||(model.skill==0&&_type==1)) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.liadToRight.constant=-3;
                      cell.name.text=@"团队规模";
                        if (_model.teamScale) {
                            cell.content.text=[NSString stringWithFormat:@"%d",[_model.teamScale integerValue]];
                        }else{
                            cell.content.text=@"点击填写团队规模";
                            
                            
                        }
                        return cell;
                        
                    }
                    
                 if ([logModel.userPost integerValue]==1&&(model.skillState==0||model.skillState==3||model.skillState==1)) {
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     if (_type==1||model.certifyType==3) {
                         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                         cell.liadToRight.constant=-3;
                         cell.name.text=@"团队规模";
                         if (_model.teamScale) {
                            cell.content.text=[NSString stringWithFormat:@"%d",[_model.teamScale integerValue]];
                         }else{
                         cell.content.text=@"点击填写团队规模";
                         }
                     }else{
                     
                      return  [self getCertainCellWithTableview:tableView];
                     }
                     
                     return   [self getCertainCellWithTableview:tableView];;
                     
                     
                 }
                    
                    return   [self getCertainCellWithTableview:tableView];;

            }
                break;
                
            case 10:
                {
                    return [self getCertainCellWithTableview:tableView];
                    
                }
                    break;
                
            default:
                break;
        }
    }
    
        return nil;
}


-(NSString*)getAllSkillString{

    NSString*skillString;
    for (NSInteger i=0; i<_model.servicerSkills.count; i++) {
        skillModel*model=[[skillModel alloc]init];
        [model setValuesForKeysWithDictionary:_model.servicerSkills[i]];
        if (i==0) {
            skillString=model.name;
        }else{
        
            skillString=[NSString stringWithFormat:@"%@、%@",skillString,model.name];
        }
    }

    return skillString;
}

-(NSString*)getServiceString{

    NSString*Str;
    for (NSInteger i=0; i<_model.areaArray.count; i++) {
        NSMutableArray*array=_model.areaArray[i];
        for (NSInteger j=1; j<array.count; j++) {
            AreaModel*model=array[j];
            
            
            
            if (model.id==10) {
               Str=@"全国";
                return Str;
            }
            
            
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
    return Str;
}

//证书
-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell1"];
    }
    for (NSInteger i=0; i<cell.contentView.subviews.count; i++) {
        UIView*view=cell.contentView.subviews[i];
        [view removeFromSuperview];
    }
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, cell.frame.size.height/2-10, 100, 20)];
    label.text=@"证书";
    label.textColor=[UIColor blackColor];
    label.enabled=YES;
    label.userInteractionEnabled=NO;
    label.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label];
    NSInteger width=(SCREEN_WIDTH-40-100)/4;
    for (NSInteger i=0; i<_model.certaionArray.count; i++) {
        CGFloat height;
        if (i==0) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
            [button setImage:[UIImage imageNamed:@"增加图片"] forState:UIControlStateNormal];
            [button addTarget: self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            continue;
        }
        
        certificateModel*model=_model.certaionArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (_model.certaionArray.count%4==0) {
            height=_model.certaionArray.count/4*40;
        }
        else{
            height=(_model.certaionArray.count/4+1)*40;
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
        imageview.tag=20+i;
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [cell.contentView addSubview:imageview];
    }
    cell.selectionStyle=0;
    return cell;
}


-(void)add{

    if (self.block) {
        self.block();
    }

}


@end
