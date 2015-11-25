//
//  ValidateViewController.h
//  master
//
//  Created by jin on 15/10/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface ValidateViewController : RootViewController

/**
 *  构造器
 *
 *  type为1时是找回密码
 *
 *  @return <#return value description#>
 */

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Mobile:(NSString*)mobile Type:(NSInteger)type;
@property(nonatomic)NSString*token;

@end
