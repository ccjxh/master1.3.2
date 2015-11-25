//
//  headViewController.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "headViewController.h"
#import "PeoDetailViewController.h"

@interface headViewController ()

@end

@implementation headViewController

- (void)viewDidLoad {
    self.type=@"师傅";
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    peoplr*model=self.dataArray[indexPath.row];
    AreaModel*areaModel = [[dataBase share]findWithCity:self.cityName];
    PeoDetailViewController*ctl=[[PeoDetailViewController alloc]initWithCityId:areaModel.id  Peoplr:model FavoriteFlag:model.favoriteFlag IsCollect:NO];
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}
@end
