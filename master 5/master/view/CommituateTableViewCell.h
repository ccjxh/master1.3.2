//
//  CommituateTableViewCell.h
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommituateTableViewCell : UITableViewCell
@property(nonatomic)personDetailViewModel*model;
-(void)reloadData;
@end
