//
//  CityTableViewController.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewController : UITableViewController
/**
 *  <#Description#>
 *
 *  @param type       类型
 *  @param id         上一级选中的地方id
 *  @param adressName 拼接的地区名字
 *
 *
 */
-(instancetype)initWithType:(typeName)type ProvinceID:(NSInteger)provinceId AdressName:(NSString*)adressName;
@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@end
