//
//  StarCaseExample.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "StarCaseExample.h"

@implementation StarCaseExample

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super initWithCoder:aDecoder]) {
        
        self.backgroundColor=COLOR(235, 235, 235, 1);
        CGRect rect=self.frame;
        rect.size.height=170;
        self.frame=rect;
    }
    
    self.firstLabel.text=[NSString stringWithFormat:@"%@\n%@",@"本人",@"现场施工照"];

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
