//
//  opinionViewController.h
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "MyServiceDetailModel.h"
typedef void (^opinionBlock)(BOOL isRefersh);
typedef void (^content)(NSString*content);
@interface opinionViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *tx;
@property(nonatomic)NSString*origin;//原始数据
@property(nonatomic)NSString*title;//标题
@property(nonatomic)NSInteger type;//0为服务描述  1为举报   2为需求人数  3为反馈 4为工长过往工地  5师傅过往工地 6曾合作雇主  7工长服务介绍  8师傅服务介绍 9为招工的详细地址
@property(nonatomic)NSInteger limitCount;//限制的字数
@property(nonatomic)NSInteger id;//当为举报按钮推出本页时需传入举报人id

/**
 *  构造函数
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *  @param origin         若果存在原始数据,就传入原始数据
 *  @param title          本页的标题
 *  @param type           0为服务描述  1为举报   2为需求人数  3为反馈
 *  @param limitCount     限制的字数
 *  @param id             如果是被举报人就传入被举报人得id
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Origin:(NSString*)origin Title:(NSString*)title Type:(NSInteger)type LimitCount:(NSInteger)limitCount ID:(NSInteger)id;


@property(nonatomic,copy)opinionBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property(nonatomic,copy)content contentBlock;
@property(nonatomic)MyServiceDetailModel*model;
@end
