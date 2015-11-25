//
//  CityTableViewController.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "CityTableViewController.h"
#import "AreaModel.h"
#import "TownTableViewController.h"
#import "RootViewController.h"
#import "BasicInfoViewController.h"
#import "OrderDetailViewController.h"
#import "AddCommonAddressCtl.h"
#import "findMasterViewController.h"
#import "PersonalAuthenticationViewController.h"

@interface CityTableViewController ()

@property(nonatomic,copy) NSMutableArray *cityArr;
@property(nonatomic,copy) AreaModel *cityModel;
@property (nonatomic,strong) RootViewController *rVC;
@property(nonatomic,copy)NSString*adressName;
@property(nonatomic)typeName type;
@property(nonatomic)NSInteger provinceId;
@end

@implementation CityTableViewController

-(instancetype)initWithType:(typeName)type ProvinceID:(NSInteger)provinceId AdressName:(NSString *)adressName{

    if (self= [super init]) {
    _type=type;
    _provinceId=provinceId;
    _adressName=adressName;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市选择";
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    _cityArr = [NSMutableArray array];
    [_rVC CreateFlow];
    [self requestCityInfo:_provinceId];
}


#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewController"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:@"CityTableViewController"];
    }
    _cityModel = _cityArr[indexPath.row];
    cell.textLabel.text = _cityModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     _cityModel = _cityArr[indexPath.row];
    if (_type==1) {
        TownTableViewController *ctl = [[TownTableViewController alloc] initWithType:_type City:_cityModel.id AdressName:[NSString stringWithFormat:@"%@-%@",_adressName,_cityModel.name]];
        [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        return;
        
    }
    
    
    for (UIViewController*vc in self.navigationController.viewControllers) {
        
        if ([[USER_DEFAULT objectForKey:@"type"] integerValue]==10) {
            
            if ([vc isKindOfClass:[PersonalAuthenticationViewController class]]==YES) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSString stringWithFormat:@"%@-%@",_adressName,_cityModel.name] forKey:@"region"];
                [dict setObject:[NSNumber numberWithInteger:_cityModel.id]  forKey:@"regionId"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"basic" object:dict];
                
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }else{

        if ([vc isKindOfClass:[BasicInfoViewController class]]==YES) {
        
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%@-%@",_adressName,_cityModel.name] forKey:@"region"];
            [dict setObject:[NSNumber numberWithInteger:_cityModel.id]  forKey:@"regionId"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"basic" object:dict];
            [self.navigationController popToViewController:vc animated:YES];
                
            }
        
        }
    }
}

#pragma mark - 请求城市信息
-(void) requestCityInfo : (NSInteger) Id
{
    [_rVC flowShow];
    NSString *urlString = [self interfaceFromString:interface_allCityList];
    NSDictionary *dict = @{@"provinceId":[NSNumber numberWithInteger:Id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [_rVC flowHide];
        
        NSDictionary *objDic = (NSDictionary*)responseObject;
        NSArray *entityArr = objDic[@"entities"];
        for (int i=0; i<entityArr.count; i++)
        {
            _cityModel = [[AreaModel alloc] init];
            NSDictionary *dict = entityArr[i];
            NSDictionary *dataCatalogDic = dict[@"dataCatalog"];
            [_cityModel setValuesForKeysWithDictionary:dataCatalogDic];
            [_cityArr addObject:_cityModel];
        }
        [self.cityTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}
@end
