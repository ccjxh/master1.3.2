//
//  CommituateTableViewCell.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "CommituateTableViewCell.h"

@implementation CommituateTableViewCell
{

   
    __weak IBOutlet NSLayoutConstraint *weChatWidth;
    
    __weak IBOutlet NSLayoutConstraint *qqWidth;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)reloadData{

    self.selectionStyle=0;
    if ([self.model.weChat isEqualToString:@""]==YES) {
        weChatWidth.constant=0;
    }else{
        weChatWidth.constant=18;
    }
    if ([self.model.qq isEqualToString:@""]==YES) {
        qqWidth.constant=0;
    }else{
        qqWidth.constant=18;
    }

}

- (IBAction)qq:(id)sender {
    
    [self.contentView makeToast:[NSString stringWithFormat:@"qq号是:%@",self.model.qq] duration:1 position:@"center"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.qq;
}

- (IBAction)weChat:(id)sender {
    [self.contentView makeToast:[NSString stringWithFormat:@"微信号是:%@",self.model.qq] duration:1 position:@"center"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.weChat;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
