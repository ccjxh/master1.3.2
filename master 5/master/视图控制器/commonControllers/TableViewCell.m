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


-(void)setModelArray:(NSMutableArray *)ModelArray{

    _ModelArray=ModelArray;
    modelDelegateArray=ModelArray;

}
- (void)awakeFromNib {
    // Initialization code
}




-(void)add{
    if (self.block) {
        self.block(1,nil,nil);
    }
}

-(void)dele:(UIButton*)button{

    NSMutableArray*temp=[[NSMutableArray alloc]init];
    if (button.tag-20+1<=modelDelegateArray.count) {
        
       caseDetail*model=self.ModelArray[button.tag-20-(self.picArray.count-self.ModelArray.count)];
        [temp addObject:model];
        [modelDelegateArray removeObjectAtIndex:button.tag-20];
    }
    
    if (self.block) {
        self.block(2,self.picArray[button.tag-20],temp);
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
        imageview.image=self.picArray[i];
        [imageview addSubview:deleButton];
        [view addSubview:imageview];
    }
    
    self.selectionStyle=0;
    [self.contentView addSubview:view];
}



@end
