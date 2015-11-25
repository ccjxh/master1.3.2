//
//  datBase+normal.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "payModel.h"
#import "loginModel.h"
typedef enum{
    city,
    skill,
    information,
    pay,
    primaryInfor,
    
}tablename;

@interface dataBase (normal)

-(void)createTable;

//插入城市信息
-(void)inserCity:(NSArray*)array Pid:(NSInteger)pid;

//跟新城市信息
-(BOOL)updateWintCity:(AreaModel*)model;

//根据城市名字查找城市信息
-(AreaModel*)findWithCity:(NSString*)cityName;

//根据城市id查找城市下的地区信息
-(NSMutableArray*)findWithPid:(NSInteger)pid;

//根据首字母查找城市信息
-(NSMutableArray*)findWithFlag:(NSString*)flag;


//删除所有城市信息
-(BOOL)deleAllCityInformation;



//插入技能信息
-(BOOL)inserSkillModel:(skillModel*)model;


//跟新技能信息
-(BOOL)updateWintSkillModel:(skillModel*)model;


//查找全部技能
-(NSMutableArray*)findAllSkill;


//删除所有技能信息
-(BOOL)deleAllSkillInformation;


//插入技能信息
-(BOOL)inserSkillModel:(skillModel*)model;


//插入个人信息
-(BOOL)inserInformationWithPeopleInfoematin:(PersonalDetailModel*)model;


//跟新个人信息
-(BOOL)updateInformationWithWithPeopleInfoematin:(PersonalDetailModel*)model;


//查找个人信息
-(PersonalDetailModel*)findPersonInformation:(NSInteger)ID;

//删除个人信息
-(BOOL)deleInformationWithID:(NSInteger)ID;


//缓存支付
-(BOOL)insertPayFromTable:(payModel*)model;

//跟新支付
-(BOOL)updatePayFromTable:(payModel*)model;

-(NSMutableArray*)findAllPay;


//删除支付
-(BOOL)deleAllPay;


-(void)updateInformationWithTable:(NSString*)table Id:(NSInteger)ID Attribute:(NSString*)attribute Content:(NSString*)content;

/**
 *  插入基本信息
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)insertprimaryInfor:(loginModel*)model;

/**
 *  查找基本信息
 *
 *  @param ID <#ID description#>
 *
 *  @return <#return value description#>
 */
-(loginModel*)findLoginInformationWithID:(NSInteger)ID;


/**
 *  更新签到信息
 *
 *  @param model 登陆信息model
 *
 *  @return 是否签到成功
 */
-(BOOL)updatePrimaryInforWithModel:(loginModel*)model;


/**
 *  删除个人签到信息
 *
 *  @return <#return value description#>
 */
-(BOOL)delePrimaty;


/**
 *  插入全国省份
 *
 *  @param db       省份数组
 *  @param rollback pid
 *
 *  @return void
 */
-(void)inserProvinceCity:(NSArray*)array Pid:(NSInteger)pid;



/**
 *  //根据首字母查找城市信息
 *
 *  @param NSMutableArray flag  为城市的首字母
 *
 *  @return
 */
-(NSMutableArray*)findProviceWithFlag:(NSString *)flag;

-(void)inserCity:(NSArray *)array;
-(NSMutableArray*)findCityInformationWithPid:(NSInteger)pid;
-(NSMutableArray*)findcityWithKeyWord:(NSString*)keyWord;
-(AreaModel*)findCityWithCityId:(NSInteger)id;
@end
