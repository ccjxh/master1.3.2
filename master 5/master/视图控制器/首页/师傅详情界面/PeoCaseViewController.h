//
//  PeoCaseViewController.h
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface PeoCaseViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
-(instancetype)initWithID:(NSInteger)id Navigation:(UINavigationController*)nav;
@property(nonatomic)NSInteger type;//1为师傅详情
@end
