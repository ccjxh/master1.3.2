//
//  TableViewCell.h
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
//type 表示类型   1是新增  2删除  
typedef void(^managerPhotos) (NSInteger type,id object,NSMutableArray*array);
@interface TableViewCell : UITableViewCell
@property(nonatomic)BOOL isShow;
@property(nonatomic,copy)managerPhotos block;
@property(nonatomic)NSMutableArray*picArray;
@property(nonatomic)UIImage*currentImage;
@property(nonatomic)NSMutableArray*ModelArray;//要删除的数组
-(void)reloadData;
@end
