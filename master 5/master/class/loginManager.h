//
//  loginManager.h
//  master
//
//  Created by jin on 15/9/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

typedef void (^appStatus)(id object);
/*登陆管理器**/
typedef void (^loginComplite)(NSDictionary*statusDict);
@interface loginManager : NSObject
@property(nonatomic,copy)appStatus block;
@property(nonatomic)NSDictionary*launchOptions;//启动的字典
@property(nonatomic)SSEBaseUser*user;

+(loginManager*)share;


/**
 *  登陆接口
 *
 *  @param username                   用户名
 *  @param password                   用户密码
 *  @param requestPersonalInformation 成功后回调 loginComPlite
 */
-(void)loginWithUsername:(NSString*)username Password:(NSString *)password LoginComplite:(loginComplite)loginComPlite;


/**
 *  设置主页
 */
-(void)setHomePageWithMessage;


/**
 *  退出登陆
 */
-(void)loginOut;

/**
 *  向服务器发送挤掉其他客户端消息
 *
 *  @param pull 信鸽服务器返回的uuid
 */
-(void)sendData:(NSString*)pull;

/**
 *  缓存个人信息
 */
-(void)requestPersonalInformation;


/**
 *  根据token登陆
 *
 *  @param accessToken  token
 *  @param openId      uid
 *  @param thirdType   登陆类型
 */
-(void)loginWithAccessToken:(NSString*)accessToken OpenId:(NSString*)openId Type:(NSInteger)thirdType;

/**
 *  530重新登录
 *
 *  @param accessToken <#accessToken description#>
 *  @param openId      <#openId description#>
 *  @param thirdType   <#thirdType description#>
 */
-(void)ReLoginWithAccessToken:(NSString*)accessToken OpenId:(NSString*)openId Type:(NSInteger)thirdType;
@end
