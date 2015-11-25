//
//  caseDetail.h
//  master
//
//  Created by jin on 15/11/6.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface caseDetail : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger fileSize;
@property(nonatomic)NSString*resource;
@property(nonatomic)NSString*category;
@property(nonatomic)NSInteger workId;

@end
