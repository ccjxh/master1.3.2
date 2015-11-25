//
//  contractorViewController.m
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "contractorViewController.h"
#import "PeoDetailViewController.h"
@interface contractorViewController ()

@end

@implementation contractorViewController

- (void)viewDidLoad {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.type=@"工长";
    self.firstLocation=3;
    [super viewDidLoad];
    self.title=@"工长";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    peoplr*model=self.dataArray[indexPath.row];
    AreaModel*areaModel = [[dataBase share]findWithCity:self.cityName];
    PeoDetailViewController*pvc=[[PeoDetailViewController alloc]initWithCityId:areaModel.id  Peoplr:model FavoriteFlag:model.favoriteFlag IsCollect:NO];    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
    
}




@end
