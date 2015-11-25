//
//  MyServiceDetailModel.h
//  master
//
//  Created by jin on 15/11/1.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface MyServiceDetailModel : model
@property(nonatomic)NSInteger workExperience;//工作经验
@property(nonatomic)NSString*serviceDescribe;/**服务介绍*/
@property(nonatomic)NSString*workStatus;//工作状态
@property(nonatomic)NSMutableArray*servicerSkills;//服务技能
@property(nonatomic)NSMutableArray*allServiceRegions;//服务区域
@property(nonatomic)NSString*startWork;//从业时间
@property(nonatomic)NSInteger expectPay;//日薪
@property(nonatomic)NSDictionary*payType;/**支付方式*/
@property(nonatomic)NSString*buyer;//**合作的雇主/
@property(nonatomic)NSString*prjectCase;//**过往工地*/
@property(nonatomic)NSString*teamScale;//**团队规模*/
@property(nonatomic)NSMutableArray*certificate;/**证书*/
@property(nonatomic)NSMutableArray*areaArray;//地区数组
@property(nonatomic)NSMutableArray*certaionArray;//**证书数组*/
-(instancetype)initWithDict:(NSDictionary*)infor Type:(NSInteger)type;
/**
 *  根据index返回cell
 *
 *  @param indexPath
 *
 *
 */
-(UITableViewCell*)returnCellRegisterWithIndexPath:(NSIndexPath*)indexPath;
@end
