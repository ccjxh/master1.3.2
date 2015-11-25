//
//  myServiceDetaiTableViewCell.h
//  master
//
//  Created by jin on 15/11/1.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myServiceDetaiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liadToRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentToBottom;

@end
