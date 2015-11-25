//
//  certainViewController.h
//  master
//
//  Created by jin on 15/8/12.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "MyServiceDetailModel.h"
@interface certainViewController : RootViewController

@property (nonatomic) UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger id;
@property(nonatomic)BOOL isShow;
@property(nonatomic)NSIndexPath*currentIndexPath;
@property(nonatomic)MyServiceDetailModel*model;
@end
