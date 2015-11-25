//
//  MyserviceManager.h
//  master
//
//  Created by jin on 15/11/4.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyServiceDetailModel.h"
typedef void (^addCertain)();
@interface MyserviceManager : NSObject
@property(nonatomic)MyServiceDetailModel*model;
@property(nonatomic)NSInteger type;
@property(nonatomic,copy)addCertain block;


-(instancetype)initWithType:(NSInteger)type Title:(NSString*)title;
-(UITableViewCell*)getCellFromtableview:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath;

-(void)tableDidSelectedWithIndexPath:(NSIndexPath*)indexPath;
@end
