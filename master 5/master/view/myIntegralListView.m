//
//  myIntegralListView.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListView.h"
#import "myIntegralListCellTableViewCell.h"
#import "myIntrgalListModel.h"
#import "IntegralDetailTableViewHeaderCell.h"

@implementation myIntegralListView
{
    
    NSMutableDictionary*_dict;//保存section是否展开的字典

}

-(id)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
        
    }

    return self;
}


-(void)createUI{

    _tableview=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=COLOR(237, 238, 240, 1);
    _tableview.separatorStyle=0;
    [self addSubview:_tableview];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        
        return 1;
    }else{
    
        return _dataArray.count;
    
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 27;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray*Array=@[@"当前总积分",@"积分明细"];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 5, 120, 16)];
    label.textColor=[UIColor blackColor];
    label.text=Array[section];
    label.font=[UIFont boldSystemFontOfSize:16];
    [view addSubview:label];
    return view;
    
}


-(void)show:(UIButton*)button{

    if (self.changeDictValue) {
        self.changeDictValue(button.tag);
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if (indexPath.section==0) {
        
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"Cell"];
        UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-113, cell.contentView.frame.size.height/2-15, 100, 28)];
        lable.text=[NSString stringWithFormat:@"%u",[logModel.integral integerValue]];
        lable.textColor=COLOR(249, 190, 84, 1);
        lable.textAlignment=NSTextAlignmentRight;
        lable.font=[UIFont systemFontOfSize:25];
        [cell.contentView addSubview:lable];
        return cell;
    }
    
    
    return [self getTableviewcellWithTableview:tableView IndexPath:indexPath];

}


-(UITableViewCell*)getTableviewcellWithTableview:(UITableView*)tableview IndexPath:(NSIndexPath*)indexpath{

    myIntrgalListModel*model=_dataArray[indexpath.row];
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    UIView*view=(id)[cell.contentView viewWithTag:20];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
    view.tag=20;
    UILabel*typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 4.5, 120, 15)];
    typeLabel.textColor=COLOR(104, 104, 104, 1);
    typeLabel.font=[UIFont systemFontOfSize:15];
    typeLabel.text=model.type;
    [view addSubview:typeLabel];
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 24, 180, 15)];
    timeLabel.textColor=COLOR(104, 104, 104, 1);
    timeLabel.font=[UIFont systemFontOfSize:13];
    timeLabel.text=model.createTime;
    [view addSubview:timeLabel];
    UILabel*countLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-133, (cell.contentView.frame.size.height-16)/2, 120, 16)];
    countLabel.font=[UIFont systemFontOfSize:20];
    countLabel.textAlignment=NSTextAlignmentRight;
    if (model.value>0) {
        countLabel.text=[NSString stringWithFormat:@"+%lu",model.value];
    }else{
        
        countLabel.text=[NSString stringWithFormat:@"-%lu",model.value];
    }
    countLabel.textColor=model.value>0?COLOR(249, 190, 87, 1):COLOR(109, 217, 251, 1);
    [view addSubview:countLabel];
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(10, cell.contentView.frame.size.height-1, SCREEN_WIDTH-15, 1)];
    lineView.backgroundColor=COLOR(205, 205, 205, 1);
    [view addSubview:lineView];
    [cell.contentView addSubview:view];
    cell.selectionStyle=0;
    return cell;
}

-(void)reloadData{

    [_tableview reloadData];
    
}


//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}


#pragma mark - UITableViewDataSource


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        [self.sectionsArray removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
