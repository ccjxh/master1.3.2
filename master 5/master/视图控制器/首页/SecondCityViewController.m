//
//  SecondCityViewController.m
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "SecondCityViewController.h"
#import "findMasterViewController.h"
#import "thirdResignViewController.h"
#import "findWorkViewController.h"
@interface SecondCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SecondCityViewController
{
    NSMutableArray*_dataArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"市区选择";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self CreateFlow];
    [self noData];
    [self request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)request{

    self.noDataView.hidden=YES;
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    NSArray*Array=[[dataBase share]findCityInformationWithPid:self.province.id];
    for (NSInteger i=0; i<Array.count; i++) {
        AreaModel*model=Array[i];
        [_dataArray addObject:model];
    }
    
    [self.tableview reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    
    if (self.type==0||self.type==1) {
        return 2;
    }
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.type==0||self.type==1) {
        if (section==0) {
            return 1;
        }else{
        
            return _dataArray.count;
        }
    }
    return _dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    if (self.type==0||self.type==1) {
        if (indexPath.section==0) {
            Cell.textLabel.text=@"全省";
        }else{
            AreaModel*model=_dataArray[indexPath.row];
            Cell.textLabel.text=model.name;    Cell.textLabel.font=[UIFont systemFontOfSize:15];

        }
        return Cell;
    }else{
    AreaModel*model=_dataArray[indexPath.row];
    Cell.textLabel.text=model.name;
    Cell.textLabel.font=[UIFont systemFontOfSize:15];
    }
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.type==0||self.type==1) {
        if (indexPath.section==0) {
//            [self.addressArray addObject:self.province];
        }else{
            AreaModel*model=_dataArray[indexPath.row];
//            [self.addressArray addObject:self.province];
            [self.addressArray addObject:model];
        }
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]initWithObjects:@[self.addressArray] forKeys:@[@"array"]];
        NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotification:notication];
        for (UIViewController*vc in self.navigationController.viewControllers) {
            if (self.type==0) {
                if ([vc isKindOfClass:[findMasterViewController class]]==YES) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
                
            }
            if (self.type==1) {
                if ([vc isKindOfClass:[findWorkViewController class]]==YES) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        [self popWithnimation:self.navigationController];
        return;
    }
    
    if (self.count==2) {
        
        AreaModel*model=_dataArray[indexPath.row];
        NSDictionary*dict=@{@"model":model,@"type":@"secordLocation",@"province":self.province};
        
        
        
        NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotification:notication];
        for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
            if ([viewcontroller isKindOfClass:[findMasterViewController class]]==YES) {
                
                [self.navigationController popToViewController:viewcontroller animated:YES];
            }
        }
        
    }
    
    if (self.count==3) {
        
        AreaModel*model=_dataArray[indexPath.row];
        NSMutableArray*array=[[NSMutableArray alloc]init];
        [array addObject:self.province];
        [array addObject:model];
        thirdResignViewController*tvc=[[thirdResignViewController alloc]initWithNibName:@"thirdResignViewController" bundle:nil];
        tvc.province=self.province;
        tvc.addressArray=array;
        tvc.cityModel=model;
        tvc.type=self.type;
        [self pushWinthAnimation:self.navigationController Viewcontroller:tvc];
    }
}

@end
