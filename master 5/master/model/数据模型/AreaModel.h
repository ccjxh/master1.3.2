//
//  AreaModel.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface AreaModel : model
@property(nonatomic,copy)NSString*name;
@property(nonatomic)NSString*text;
@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString*indexLetter;
@property(nonatomic)NSArray* children;
@property(nonatomic)NSInteger childTotal;
@property(nonatomic)NSString*ucode;
@property(nonatomic)BOOL isselect;
@property(nonatomic)NSInteger pid;
@end
