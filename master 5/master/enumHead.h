//
//  enumHead.h
//  master
//
//  Created by jin on 15/10/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#ifndef enumHead_h
#define enumHead_h
typedef enum : NSUInteger {
    masterOrderContact,/**雇主预约*/
    masterOrderAccept,/**师傅应约*/
    masterOrderReject,/**师傅拒绝*/
    masterOrderFinish,/**雇主确认完工*/
    masterOrderStop,/**雇主终止用工*/
    personalPass, /**身份认证成功*/
    personalFail,/**身份认证失败*/
    masterPostPass,/**师傅认证成功*/
    masterPostFail,/**师傅认证失败*/
    foremanPostPass,/**包工头认证成功*/
    foremanPostFail,/**包工头认证失败*/
    managerPostPass,/**项目经理认证成功*/
    managerPostFail,/**项目经理认证失败*/
    projectAuditPass,/**招工信息审核通过*/
    projectAuditFail,/**招工信息审核不通过*/
    projectAccept,/**问题被采纳*/
    noticeRelease,/**最新公告已发布*/
} pushType;


#endif /* enumHead_h */
