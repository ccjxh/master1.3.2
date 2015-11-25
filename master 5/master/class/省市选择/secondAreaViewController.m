//
//  secondAreaViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "secondAreaViewController.h"
#import "proviceSelectedViewController.h"
#import "selelctAreaTableViewCell.h"
@interface secondAreaViewController ()

@end

@implementation secondAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    self.title=@"市区选择";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)customNavigation{
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 20);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    selelctAreaTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    if (indexPath.section==0) {
        cell.name.text=@"全省";
        
    }else{
    AreaModel*model=_dataArray[indexPath.row];
    cell.name.text=model.name;
    cell.model=model;
    cell.isShowImage=YES;
    [cell reloadData];
    cell.imageView.hidden=NO;
    }
    return cell;
    
}


-(void)postData{

    [self flowShow];
    NSMutableArray*valueArray=[self returnArrayWithNewData];
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSArray*array=self.selectArray[i];
        AreaModel*proviceModel=array[0];
        if (proviceModel.id==self.model.id) {
            [self.selectArray removeObject:array];
        }
    }
    
    if (valueArray.count>1) {
     [self.selectArray addObject:valueArray];
    }
    
    NSString*valueString;
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSArray*tempArray=self.selectArray[i];
           for (NSInteger j=1; j<tempArray.count; j++) {
               AreaModel*tempModel=tempArray[j];
               if (i==0&&j==1) {
                   valueString=[NSString stringWithFormat:@"%lu",tempModel.id];
               }else{
    
                   valueString=[NSString stringWithFormat:@"%@,%lu",valueString,tempModel.id];
               }
           }
       }
    
    if (valueString==nil) {
        valueString=@"0";
    }
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    NSDictionary*dict=@{@"regions":valueString};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
           
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                
                for (UIViewController*vc in self.navigationController.viewControllers) {
                      if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
                          for (NSInteger i=0; i<self.selectArray.count; i++) {
                              NSMutableArray*array=self.selectArray[i];
                              for (NSInteger j=0; j<array.count; j++) {
                                  AreaModel*model=array[j];
                                  model.isselect=NO;
                                  [array replaceObjectAtIndex:j withObject:model];
                              }
                              
                              [self.selectArray replaceObjectAtIndex:i withObject:array];
                          }
                          proviceSelectedViewController*pvc=(proviceSelectedViewController*)vc;
                          pvc.selectArray=self.selectArray;
                          [pvc.tableview reloadData];
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            
        }];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        
    }];

}


-(NSMutableArray*)returnArrayWithNewData{

    NSMutableArray*valueArray=[[NSMutableArray alloc]init];
    [valueArray addObject:self.model];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        AreaModel*tempModel=_dataArray[i];
        if (tempModel.isselect==YES) {
            [valueArray addObject:tempModel];
        }
    }
    return valueArray;


}
-(void)request{
    
    NSArray*Array=[[dataBase share]findCityInformationWithPid:self.model.id];
    for (NSInteger i=0; i<Array.count; i++) {
        AreaModel*model=Array[i];
        for (NSInteger j=0; j<self.selectArray.count; j++) {
            NSArray*comArr=self.selectArray[j];
            for (NSInteger n=i; n<comArr.count; n++) {
                AreaModel*comModel=comArr[n];
                if (comModel.id==model.id) {
                    model.isselect=YES;
                }
                
            }
        }
        
        [_dataArray addObject:model];
    }

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
        
        
        for (NSInteger i=0; i<self.selectArray.count; i++) {
            NSArray*tempArray=self.selectArray[i];
            AreaModel*provinceModel=tempArray[0];
            if (provinceModel.id==self.model.id||provinceModel.id==4) {
                [self.selectArray removeObjectAtIndex:i];
            }
        }
        
        
        NSMutableArray*allProvince=[[dataBase share]findCityInformationWithPid:self.model.id];
        NSMutableArray*newAddressArray=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<allProvince.count+1; i++) {
            if (i==0) {
                [newAddressArray addObject:self.model];
            }else{
            
                AreaModel*cityModel=allProvince[i-1];
                [newAddressArray addObject:cityModel];
            }
        }
        
        [self.selectArray addObject:newAddressArray];
        NSString*cityString;
        for (NSInteger i=0; i<self.selectArray.count; i++) {
            NSArray*tempArray=self.selectArray[i];
            for (NSInteger i=0; i<tempArray.count; i++) {
                AreaModel*valueModel=tempArray[i];
                if (i!=0) {
                    if (i==1) {
                        cityString=[NSString stringWithFormat:@"%lu",valueModel.id];
                    }else{
                        cityString=[NSString stringWithFormat:@"%@,%lu",cityString,valueModel.id];
                    }
                }
            }
            
        }
        
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    NSDictionary*dict=@{@"regions":cityString};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                
                NSMutableArray*selectArray=[[NSMutableArray alloc]init];
                for (UIViewController*vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
                        
                            for (NSInteger i=0; i<self.selectArray.count; i++) {
                            NSMutableArray*temp=[[NSMutableArray alloc]init];
                            [selectArray addObject:temp];
                            
                        }
                        
                        proviceSelectedViewController*pvc=(proviceSelectedViewController*)vc;
                        [pvc.tableview reloadData];
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }else{
            
                [self.view makeToast:@"当前网络不给力" duration:1 position:@"center"];
            }
            
        }];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"当前网络不给力" duration:1 position:@"center"];

        }];
        
        return;
        }

    }
    
    
     AreaModel*model=_dataArray[indexPath.row];
    if (model.isselect==YES) {
        model.isselect=NO;
    }else{
    model.isselect=YES;
    }
    [_dataArray replaceObjectAtIndex:indexPath.section-1 withObject:model];
    NSIndexPath*path=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self.tableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];

}

@end
