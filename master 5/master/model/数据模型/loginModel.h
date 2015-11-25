//
//  loginModel.h
//  master
//
//  Created by jin on 15/10/21.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "model.h"
/**
 *  登陆数据模型
 */
@interface loginModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString* iconId;//头像图片id
@property(nonatomic)NSString* age;//
@property(nonatomic)NSString* pageView;//被浏览的次数
@property(nonatomic)NSString* userPost;//职位类型 //1为雇主  2为师傅  3为工长
@property(nonatomic)NSString* integral;//积分
@property(nonatomic)NSString* integrity;//信息完整度
@property(nonatomic)NSString* renewDay;//连续登陆天数
@property(nonatomic)NSString* totalIntegral;
@property(nonatomic)NSString* nextDayIntegral;//下次签到获得积分
@property(nonatomic)NSString* todayIntegral;//今天签到获得积分
@property(nonatomic)NSString* signState;//签到状态
@property(nonatomic)NSString* inviteCode;//邀请码
@property(nonatomic)NSString* mobile;//手机号
@property(nonatomic)NSDictionary*certification;//认证相关
@property(nonatomic)NSDictionary*signInfo;//签到信息相关
@property(nonatomic)NSString*city;//定位的城市

@end
