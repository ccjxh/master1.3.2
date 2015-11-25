//
//  thirdResignViewController.m
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "thirdResignViewController.h"
#import "findAddNewWorkViewController.h"
#import "findWorkViewController.h"
#import "findMasterViewController.h"
@interface thirdResignViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation thirdResignViewController
{

    NSMutableArray*_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSArray*Array=[[dataBase share]findCityInformationWithPid:self.cityModel.id];
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
        Cell.textLabel.text=@"全市";
        Cell.textLabel.font=[UIFont systemFontOfSize:15];
        return Cell;
    }
    AreaModel*model=_dataArray[indexPath.row];
    Cell.textLabel.text=model.name;
    Cell.textLabel.font=[UIFont systemFontOfSize:15];
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];;
    if (self.type==0||self.type==1) {
        if (indexPath.section!=0) {
            AreaModel*model=_dataArray[indexPath.row];
            [self.addressArray addObject:model];
        }
                [dict setObject:dict  forKey:@"array"];
                NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter]postNotification:notication];
            for (UIViewController*vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[findWorkViewController class]]==YES) {
                    if (self.type==1) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                
                if ([vc isKindOfClass:[findMasterViewController class]]==YES) {
                 
                    if (self.type==0) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    
                }
            }
            return;
        
    }else if(self.type==2){
        AreaModel*model=_dataArray[indexPath.row];
        NSDictionary*dict=@{@"model":model,@"type":@"thirdLocation",@"province":self.province,@"city":self.cityModel};
        NSNotification*notication=[[NSNotification alloc]initWithName:@"workPlace" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotification:notication];
        for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
            if ([viewcontroller isKindOfClass:[findAddNewWorkViewController class]]==YES) {
                
                [self.navigationController popToViewController:viewcontroller animated:YES];
            }
            
        }
    
    }
}

@end
