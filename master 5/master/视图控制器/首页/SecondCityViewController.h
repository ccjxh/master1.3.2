//
//  SecondCityViewController.h
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface SecondCityViewController : RootViewController
@property(nonatomic)AreaModel*province;
@property(nonatomic)NSInteger count;
@property(nonatomic)NSInteger type;
@property(nonatomic)NSMutableArray*addressArray;//装着地区的数组
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
