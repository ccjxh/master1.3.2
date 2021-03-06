//
//  RootView.h
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"

@interface RootView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)void(^tableviewDidselecredAtIndexpath)(NSIndexPath*indexpath);
@property(nonatomic,copy)void(^tableviewPullDown)();
@property(nonatomic,copy)void(^tableviewPullUp)();
- (void)setupHeaderWithTableview:(UITableView*)tableview;//设置下拉刷新
- (void)setupFooter:(UIScrollView*)tableview;//设置上拉加载
@end
