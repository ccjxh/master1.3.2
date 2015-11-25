//
//  tableManager.h
//  master
//
//  Created by jin on 15/11/3.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tableManager : NSObject
@property(nonatomic)NSMutableArray*dequeueReusableArray;//**注册的cell数组*/
@property(nonatomic)NSMutableArray*sectionArray;
@property(nonatomic)NSMutableArray*rowHeight;
//@property(nonatomic)
@end
