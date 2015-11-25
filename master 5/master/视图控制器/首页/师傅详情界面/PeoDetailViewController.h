//
//  PeoDetailViewController.h
//  master
//
//  Created by xuting on 15/7/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "MasterDetailModel.h"

@interface  PeoDetailViewController : RootViewController

-(instancetype)initWithCityId:(NSInteger )ID Peoplr:(peoplr*)model FavoriteFlag:(NSInteger)favoriteFlag IsCollect:(BOOL)isCollect;

@end
