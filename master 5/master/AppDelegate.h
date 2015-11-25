//
//  AppDelegate.h
//  master
//
//  Created by jin on 15/5/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#import "TencentOpenAPI/QQApiInterface.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic)NSInteger id;
@property(nonatomic)UINavigationController*nc;
@property(nonatomic)NSString*province;//定位的省
@property(nonatomic)NSString*city;//定位大地区
@property(nonatomic)NSString*detailAdress;//定位小地区
@property(nonatomic)NSString*pullToken;//从信鸽服务器获得的token
@property(nonatomic)BOOL isLogin;//是否登录
@property(nonatomic,copy)void(^cityChangeBlock)(NSString*cityName);
-(void)setupPushWithDictory;
@end

