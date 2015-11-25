//
//  thirdResignViewController.h
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface thirdResignViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)AreaModel*province;
@property(nonatomic)AreaModel*cityModel;
@property(nonatomic)NSInteger type;
@property(nonatomic)NSMutableArray*addressArray;//装着地区的数组

@end
