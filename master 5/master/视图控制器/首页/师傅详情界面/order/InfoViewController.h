//
//  InfoViewController.h
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
-(instancetype)initWithCityId:(NSInteger )ID Peoplr:(peoplr*)model;
@end
