//
//  firstAreaViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "firstAreaViewController.h"
#import "secondAreaViewController.h"
#import "proviceSelectedViewController.h"
@interface firstAreaViewController ()

@end

@implementation firstAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"省选择";
    [self initData];
    [self CreateFlow];
    [self request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{

    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }

}

-(void)request{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_provinceList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*entityArr=[dict objectForKey:@"entities" ];
        for (NSInteger i=0; i<entityArr.count; i++) {
            NSDictionary*inforDic=entityArr[i];
            AreaModel*model=[[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"dataCatalog"]];
            [_dataArray addObject:model];
        }

        [_tableview reloadData];
        [self flowHide];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 1;
    }
    return _dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        Cell.textLabel.text=@"全国";
        Cell.textLabel.font=[UIFont systemFontOfSize:16];

    }else{
    AreaModel*model=_dataArray[indexPath.row];
    Cell.textLabel.text=model.name;
    }
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
        NSDictionary*dict=@{@"allCountryFlg":@"1"};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            [self flowHide];
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
                NSMutableArray*Array=[[NSMutableArray alloc]init];
                NSMutableArray*tempArray=[[NSMutableArray alloc]init];
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self.selectArray removeAllObjects];
                    AreaModel*allChinaMidel=[[AreaModel alloc]init];
                    AreaModel*titleModel=[[AreaModel alloc]init];
                    titleModel.id=4;
                    titleModel.name=@"服务区域";
                    allChinaMidel.name=@"中国";
                    allChinaMidel.id=10;
                    [Array addObject:titleModel];
                    [Array addObject:allChinaMidel];
                    [self.selectArray insertObject:Array atIndex:0];
                    for (UIViewController*vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
                            
                            proviceSelectedViewController*pvc=(proviceSelectedViewController*)vc;
                            [pvc.tableview reloadData];
                            [self popWithnimation:self.navigationController];
                        }
                    }
                    
                }else{
                    [self flowHide];

                    [self.view makeToast:@"当前网络不好,请稍后重试" duration:1 position:@"center"];
                }
                
            }];
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
            
        }];

        
        return;
    }
    secondAreaViewController*svc=[[secondAreaViewController alloc]initWithNibName:@"firstAreaViewController" bundle:nil];
    svc.model=_dataArray[indexPath.row];
    svc.serModel=self.model;
    AreaModel*model=_dataArray[indexPath.row];
//    NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model, nil];
//    [self.selectArray addObject:array];
    svc.selectArray=self.selectArray;
    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];

}
@end
