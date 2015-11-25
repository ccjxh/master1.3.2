//
//  secondAreaViewController.h
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "firstAreaViewController.h"
#import "MyServiceDetailModel.h"
@interface secondAreaViewController : firstAreaViewController
@property(nonatomic)MyServiceDetailModel*serModel;
@property(nonatomic,strong)AreaModel*model;//省市数据模型

@end
