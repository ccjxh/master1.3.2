//
//  MyServiceDetailModel.m
//  master
//
//  Created by jin on 15/11/1.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "MyServiceDetailModel.h"

@implementation MyServiceDetailModel
{

    NSInteger _type;
    
}
-(instancetype)initWithDict:(NSDictionary*)infor Type:(NSInteger)type{
    if (self=[super init]) {
        _type=type;
        [self setValuesForKeysWithDictionary:infor];
        
    }

    return self;

}




@end
