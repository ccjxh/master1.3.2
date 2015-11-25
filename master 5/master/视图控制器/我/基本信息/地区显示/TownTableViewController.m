//
//  TownTableViewController.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "TownTableViewController.h"
#import "AreaModel.h"
#import "BasicInfoViewController.h"
#import "OrderDetailViewController.h"  //提交预约界面
#import "AddCommonAddressCtl.h" //添加常用地址界面
#import "RootViewController.h"

@interface TownTableViewController ()

@property(nonatomic) AreaModel *townModel;
@property(nonatomic) NSMutableArray *townArr;
@property (nonatomic,strong) RootViewController *rVC;
@property(nonatomic)typeName type;
@property(nonatomic,copy)NSString*adressName;
@property(nonatomic)NSInteger cityID;
@end

@implementation TownTableViewController


-(instancetype)initWithType:(typeName)type City:(NSInteger)cityID AdressName:(NSString *)adressName{

    if (self=[super init]) {
        
        _cityID=cityID;
        _type=type;
        _adressName=adressName;
        
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地区选择";
    self.townTableView.delegate = self;
    self.townTableView.dataSource = self;
    _townArr = [NSMutableArray array];
    [_rVC CreateFlow];
    [self requestCityInfo:_cityID];
    
}
#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _townArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TownTableViewController"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:@"TownTableViewController"];
    }
    _townModel = _townArr[indexPath.row];
    cell.textLabel.text = _townModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _townModel = _townArr[indexPath.row];
   
       for (UIViewController*vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[AddCommonAddressCtl class]]==YES) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:[NSString stringWithFormat:@"%@-%@",_adressName,_townModel.name] forKey:@"region"];
                        [dict setObject:[NSNumber numberWithInteger:_townModel.id] forKey:@"regionId"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:dict];
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    }
    
}


#pragma mark - 请求城市信息
-(void) requestCityInfo : (NSInteger) Id
{
    [_rVC flowShow];
    NSString *urlString = [self interfaceFromString:interface_resigionList];
    NSDictionary *dict = @{@"cityId":[NSNumber numberWithInteger:_cityID]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [_rVC flowHide];
        
        NSDictionary *objDic = (NSDictionary*)responseObject;
        NSArray *entityArr = objDic[@"entities"];
        
        for (int i=0; i<entityArr.count; i++)
        {
            _townModel = [[AreaModel alloc] init];
            NSDictionary *dict = entityArr[i];
            NSDictionary *dataCatalogDic = dict[@"dataCatalog"];
            [_townModel setValuesForKeysWithDictionary:dataCatalogDic];
            [_townArr addObject:_townModel];
        }
        [self.townTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

@end
