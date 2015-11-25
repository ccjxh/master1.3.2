//
//  StarPhotosTableViewCell.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "StarPhotosTableViewCell.h"

@implementation StarPhotosTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.firstLabel.text=[NSString stringWithFormat:@"%@\n%@",@"本人",@"现场施工照"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
