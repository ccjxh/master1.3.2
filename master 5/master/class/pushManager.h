//
//  pushManager.h
//  master
//
//  Created by jin on 15/10/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pushManager : NSObject
/**
 *  构造器
 *
 *  @param dict 推送传来的字典
 *
 *  @return
 */
+(pushManager*)share;



/**
 *  根据推送的字典做出相应的相应
 *
 *
 */
-(void)actionWithDict:(NSDictionary*)userDict;
@end
