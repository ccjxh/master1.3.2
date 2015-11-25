//
//  informationDetail.h
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personDetailViewModel.h"
/*
 详情界面个人信息view
 **/
@interface informationDetail : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITableView*tableview;
@property(nonatomic)NSMutableArray*dataArray;//数据源
@property(nonatomic)personDetailViewModel*model;
@property(nonatomic,copy)void(^checkBlock)();//举报按钮点击触发
@property(nonatomic,copy)void(^tableDisSelected)(NSIndexPath*indexPath,personDetailViewModel*model);
@property(nonatomic,copy)void(^imageDisplay)(NSInteger index,UIImageView*imageview,personDetailViewModel*model);//**证书点击处理事件  type1是证书*/
@property(nonatomic,copy)void(^starCaseDisplay)(NSInteger index,UIImageView*imageview,personDetailViewModel*model);
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property(nonatomic,copy)void(^headImageBlock)(NSString*urlString,peopleDetailTableViewCell*cell);//**头像点击事件*/


-(void)reloadData;
@end
