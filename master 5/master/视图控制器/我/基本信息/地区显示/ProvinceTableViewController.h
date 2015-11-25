//
//  ProvinceTableViewController.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProvinceTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

/**
 *  构造省份
 *
 *
 *  @param type           1为我的常用地址
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithType:(typeName)type;

@property (strong, nonatomic) IBOutlet UITableView *provinceTableView;

//@property (nonatomic,assign) int flag;
@end
