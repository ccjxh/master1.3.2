//
//  TableViewCell.m
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "TableViewCell.h"
#import "caseDetail.h"
@implementation TableViewCell
{

    NSMutableArray*modelDelegateArray;

}



- (void)awakeFromNib {
    // Initialization code
}




-(void)add{
    if (self.block) {
        self.block(1,nil);
    }
}

-(void)dele:(UIButton*)button{

    id temp=self.picArray[button.tag-20];
    if ([temp isKindOfClass:[caseDetail class]]==YES) {
        if (self.block) {
            caseDetail*valueModel=self.picArray[button.tag-20];
            valueModel.isDelete=YES;
            [self.picArray replaceObjectAtIndex:button.tag-20 withObject:valueModel];
            self.block(2,temp);
        }
    }else{
    if (self.block) {
        self.block(2,self.picArray[button.tag-20]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)reloadData{
    UIView*view=(id)[self viewWithTag:21];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:self.bounds];
    view.tag=21;
    view.userInteractionEnabled=YES;
    NSInteger width=(SCREEN_WIDTH-30)/3;
    for (NSInteger i=0; i<self.picArray.count; i++) {
        if (i==0) {
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20+i%3*(width+5), 10+i/3*(width+5), width-10, width-10)];
            imageview.image=[UIImage imageNamed:@"增加图片"];
            imageview.userInteractionEnabled=YES;
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add)];
            tap.numberOfTapsRequired=1;
            [imageview addGestureRecognizer:tap];
            [view addSubview:imageview];
            continue;
        }
        
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(30+i%3*(width+5), 10+i/3*(width+5), width-10, width-10)];
        
        imageview.userInteractionEnabled=YES;
        UIButton*deleButton=[[UIButton alloc]initWithFrame:CGRectMake(-5, -5, 20, 20)];
        [deleButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        deleButton.tag=20+i;
        if (self.isShow==YES) {
            deleButton.hidden=NO;
        }else{
        
            deleButton.hidden=YES;
        }
        [deleButton addTarget:self action:@selector(dele:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.picArray[i] isKindOfClass:[caseDetail class]]==YES) {
            caseDetail*temp=self.picArray[i];
            [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,temp.resource]] placeholderImage:[UIImage imageNamed:headImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    imageview.image=[UIImage imageNamed:@"碎图"];
                }
                
            }];

        }else{
        imageview.image=self.picArray[i];
        }
        [imageview addSubview:deleButton];
        [view addSubview:imageview];
    }
    
    self.selectionStyle=0;
    [self.contentView addSubview:view];
}



@end
