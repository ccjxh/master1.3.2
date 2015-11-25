//
//  TownTableViewController.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockRegion)(NSString *region,long regionId);
@interface TownTableViewController : UITableViewController

/**
 *  <#Description#>
 *
 *  @param type       类型
 *  @param id         上一级选中的地方id
 *  @param adressName 拼接的地区名字
 *
 *
 */
-(instancetype)initWithType:(typeName)type City:(NSInteger)cityID AdressName:(NSString*)adressName;

@property (strong, nonatomic) IBOutlet UITableView *townTableView;
@property (nonatomic,copy) BlockRegion blockRegion;

@end
