//
//  appInitManager.h
//  master
//
//  Created by jin on 15/10/21.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appInitManager : NSObject<CLLocationManagerDelegate>
@property(nonatomic)NSDictionary*launchOptions;//是否有推送的字典
+(appInitManager*)share;

/*初始化第三方库**/
-(void)initPrimaryThirdLibrary;


/*移除启动图片**/
-(void)startupAnimationDone;

/**
 *  设置相应的界面
 */
-(void)setupViewcontroller;


/**
 *  将当前界面设置为登陆界面
 */
-(void)setupLoginView;
@end
