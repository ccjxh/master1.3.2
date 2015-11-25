//
//  StarCaseViewController.h
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//
/**
 *  明星工程案例
 */
#import "RootViewController.h"
#import "peojectCaseModel.h"
@interface StarCaseViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *opinion;
@property(nonatomic)peojectCaseModel*model;
@property(nonatomic)BOOL Editable;//是否可编辑
@end
