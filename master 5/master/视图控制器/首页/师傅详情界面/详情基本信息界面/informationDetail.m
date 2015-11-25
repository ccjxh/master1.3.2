//
//  informationDetail.m
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "informationDetail.h"
#import "requestModel.h"
#import "myServiceDetaiTableViewCell.h"
#import "CommituateTableViewCell.h"
#import "caseDetail.h"
@implementation informationDetail
{
    NSMutableArray*_nameArray;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
        [self createHead];
        if (!_nameArray) {
            _nameArray=[[NSMutableArray alloc]init];
        }
    }
    NSArray*array=@[@"专 业 技 能",@"服 务 介 绍"];
    NSArray*array1=@[@"曾合作雇主",@"过 往 工 地",@"期 望 薪 资",@"日          程",@"电          话",@"社          交",@"证          书"];
    [_nameArray addObject:@""];
    [_nameArray addObject:array];
    [_nameArray addObject:array1];
    return self;
    
}

-(void)setModel:(personDetailViewModel *)model{

    _model=model;
    NSArray* array1=@[@"曾合作雇主",@"过 往 工 地",@"团队规模",@"期 望 薪 资",@"日          程",@"电          话",@"社          交",@"证          书"];
    if (model.userPost==3) {
        [_nameArray replaceObjectAtIndex:_dataArray.count-1 withObject:array1];
    }

}




-(void)setDataArray:(NSMutableArray *)dataArray{

    _dataArray=dataArray;
    if (_dataArray.count>_nameArray.count) {
        [_nameArray insertObject:@"" atIndex:1];
    }
    
}


-(void)initUI{
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-110-49)];
    self.tableview.backgroundColor=COLOR(246, 246, 246, 1);
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=0;
    [self addSubview:self.tableview];
}


-(void)createHead{
    
    self.contentLabel.textColor=COLOR(201, 201, 201, 1);
    self.checkButton.backgroundColor=COLOR(22, 167, 232, 1);
    [self.checkButton addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    if (self.dataArray.count==4) {
        if (section==1) {
            return 1;
        }
        if (section==2) {
            return 2;
        }
        if (section==3) {
            if (self.model.userPost==3) {
                return 8;
            }
            return 7;
        }
    }
    if (self.dataArray.count==3) {
        if (section==1) {
            return 2;
        }
        if (section==2) {
            if (self.model.userPost==3) {
                return 8;
            }
            return 7;
        }
    }
    
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count==4) {
        
        if (indexPath.section==1) {
            
            return 125;
        }
        if (indexPath.section==2) {
            
            if (indexPath.row==0) {
               
                return   [self accountStringHeightFromString:[self getAllSkillString] Width:SCREEN_WIDTH-100 FrontSize:14]+8>34?[self accountStringHeightFromString:[self getAllSkillString] Width:SCREEN_WIDTH-100 FrontSize:14]+8:34;
            }
            if (indexPath.row==1) {

              return   [self accountStringHeightFromString:[self.model.service objectForKey:@"serviceDescribe"] Width:SCREEN_WIDTH-100 FrontSize:14]+8>34?[self accountStringHeightFromString:[self.model.service objectForKey:@"serviceDescribe"] Width:SCREEN_WIDTH-100 FrontSize:14]+8:34;
            }
        }
        

        if (indexPath.section==3) {
           
            if (self.model.userPost==3) {
               
                if (indexPath.row==6) {
                    return 53;
                }
                if (indexPath.row==7) {
                    return [self accountPictureFromArray:self.model.certificate];
                }

                
            }
            if (indexPath.row==5) {
                return 53;
            }
            if (indexPath.row==6) {
                return [self accountPictureFromArray:self.model.certificate];
            }
        }
    }
    
    if (self.dataArray.count==3) {
        
        if (indexPath.section==2) {
            
            if (self.model.userPost==3) {
                
                if (indexPath.row==6) {
                    return 53;
                }
                if (indexPath.row==7) {
                    return [self accountPictureFromArray:self.model.certificate];
                }
                
                
            }
            if (indexPath.row==5) {
                return 53;
            }
            if (indexPath.row==6) {
                return [self accountPictureFromArray:self.model.certificate];
            }
        }
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    
    if (cell.frame.size.height<=34) {
        return 34;
    }
    return cell.frame.size.height;
}


-(CGFloat)returnSkillHeight{

    return  [self accountStringHeightFromString:[self getAllSkillString] Width:SCREEN_WIDTH-126 FrontSize:14]+10>30?[self accountStringHeightFromString:[self getAllSkillString] Width:SCREEN_WIDTH-126 FrontSize:14]+10:30;

}

-(CGFloat)returnServiceIntroduceHeight{
    
   
    return  [self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-126 FrontSize:14]+10>30?[self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-126 FrontSize:14]+10:30;
}


-(CGFloat)returnInformationHeightWith:(NSIndexPath*)indexPath{
    
    if (indexPath.row==0) {
        if ([[self.model.service objectForKey:@"servicerSkills"] count]<=2) {
            
            return 25;
        }
        else
        {
            if ([[self.model.service objectForKey:@"servicerSkills"] count]%3==0) {
                
                return [[self.model.service objectForKey:@"servicerSkills"] count]/3*30-5;
                
            }
            
            else
            {
                return ([[self.model.service objectForKey:@"servicerSkills"] count]+1)/3*30+20;
            }
        }
        
    }
    
    else if (indexPath.row==4){
        
        if ([self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-110]>16) {
            
            return [self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-110]+40;
        }
        
        return 60;
    }
    return 30;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }
    return 20;
    
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    label.backgroundColor=COLOR(246, 246, 246, 1);
    return label;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableview.tableFooterView==nil&&_dataArray.count!=0) {
        [self getCheckCell:self.tableview];
    }
    peopleDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"peopleDetailTableViewCell"];
    if (cell1 == nil)
    {
        cell1=[[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
        
    }
    
    __weak typeof(peopleDetailTableViewCell*)weCell=cell1;
    cell1.displayBlock=^(NSString*iconString){
        
        if (self.headImageBlock) {
            self.headImageBlock(iconString,weCell);
        }
        
    };
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    [requestModel isNullMasterDetail:self.model];
    [cell1 upDateWithModel:self.model];
    
    myServiceDetaiTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"myServiceDetaiTableViewCell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"myServiceDetaiTableViewCell" owner:nil options:nil]lastObject];
    }

    if (indexPath.section==0) {
        return cell1;
        
    }else if (indexPath.section==1){
        if (self.dataArray.count==4) {
            
            
            return [self getCertainCellWithTableview:tableView];
        }else if (self.dataArray.count==3){
            return  [self getAboutSkillCellWithIndexPath:indexPath];
        }
    }else if (indexPath.section==2){
        
        if (self.dataArray.count==3) {
            return [self getPrimaryWithIndexPath:indexPath];
        }else{
            
            return [self getAboutSkillCellWithIndexPath:indexPath];
            
        }
    }
    if (indexPath.section==3) {
        
        return [self getPrimaryWithIndexPath:indexPath];
        
    }
    return Cell;
}


-(UITableViewCell*)getAboutSkillCellWithIndexPath:(NSIndexPath*)indexPath{
    

    myServiceDetaiTableViewCell*Cell=[self.tableview dequeueReusableCellWithIdentifier:@"myServiceDetaiTableViewCell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"myServiceDetaiTableViewCell" owner:nil options:nil]lastObject];
    }
    Cell.name.text=_nameArray[indexPath.section][indexPath.row];
    Cell.name.textColor=[UIColor lightGrayColor];
    Cell.content.textColor=COLOR(0, 0, 0, 1);
    Cell.selectionStyle=0;
    Cell.liadToRight.constant=8;
    Cell.content.textAlignment=NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0:
        {
            
            Cell.content.text=[self getAllSkillString];
            Cell.liadToRight.constant=8;
            return Cell;
        }
            break;
        case 1:
        {
            if ([self.model.service objectForKey:@"serviceDescribe"]) {
                Cell.content.text=[self.model.service objectForKey:@"serviceDescribe"];
            }else{
                Cell.content.text=@"师傅忘填了,囧~";
            }
            
            return Cell;
        }
            break;
       
        default:
            break;
    }
    return Cell;
}



-(UITableViewCell*)getPrimaryWithIndexPath:(NSIndexPath*)indexPath{

    myServiceDetaiTableViewCell*Cell=[self.tableview dequeueReusableCellWithIdentifier:@"myServiceDetaiTableViewCell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"myServiceDetaiTableViewCell" owner:nil options:nil]lastObject];
    }
    Cell.selectionStyle=0;
    Cell.name.text=_nameArray[indexPath.section][indexPath.row];
    Cell.name.textColor=[UIColor lightGrayColor];
    Cell.content.textColor=COLOR(0, 0, 0, 1);
    Cell.liadToRight.constant=8;
    Cell.content.textAlignment=NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0:
        {
            if (self.model.buyer) {
                Cell.content.text=self.model.buyer;
            }else{
                Cell.content.text=@"师傅忘填了,囧~";
            }
            return Cell;
            
        }
            break;
            
        case 1:
        {
            
            if (self.model.prjectCase) {
                Cell.content.text=self.model.prjectCase;
            }else{
                Cell.content.text=@"师傅忘填了,囧~";
            }
            return Cell;
        }
            break;
            case 2:
        {
            if (self.model.userPost==3) {
                
            if (self.model.teamScale!=0) {
                Cell.content.text=[NSString stringWithFormat:@"%lu",self.model.teamScale];
            }else{
                Cell.content.text=@"师傅忘填了,囧~";
            }
            return Cell;
            }
            
            if ([[[self.model.service objectForKey:@"payType"] objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
                Cell.content.text=@"面议";
                Cell.content.textColor=[UIColor blackColor];
                return Cell;
                
            }else if (![[self.model.service objectForKey:@"payType"] objectForKey:@"name"]){
                Cell.content.text=@"";
                return Cell;
            }else {
                
                Cell.content.text=[NSString stringWithFormat:@"%.2f%@",[[self.model.service objectForKey:@"expectPay"] floatValue],[[self.model.service objectForKey:@"payType"] objectForKey:@"name"]];
                Cell.content.textColor=[UIColor blackColor];
                
            }
            
            return Cell;

            
        }
            break;
        case 3:
        {
            if (self.model.userPost==3) {
                
                Cell.content.text=[self.model.service objectForKey:@"workStatus"];
                return Cell;
                
            }
            if ([[[self.model.service objectForKey:@"payType"] objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
                Cell.content.text=@"面议";
                Cell.content.textColor=[UIColor blackColor];
                return Cell;
                
            }else if (![[self.model.service objectForKey:@"payType"] objectForKey:@"name"]){
                Cell.content.text=@"";
                return Cell;
            }else {
                
                Cell.content.text=[NSString stringWithFormat:@"%.2f%@",[[self.model.service objectForKey:@"expectPay"] floatValue],[[self.model.service objectForKey:@"payType"] objectForKey:@"name"]];
                Cell.content.textColor=[UIColor blackColor];
                
            }
            
            return Cell;
        }
            break;
        case 4:
        {
            if (self.model.userPost==3) {
                
                Cell.content.text=self.model.mobile;
                return Cell;
                
            }
            Cell.content.text=[self.model.service objectForKey:@"workStatus"];
            return Cell;
        }
            break;
        case 5:
        {
            if (self.model.userPost==3) {
                Cell.content.text=self.model.mobile;
                return Cell;

            }
            CommituateTableViewCell*cell=[self.tableview dequeueReusableCellWithIdentifier:@"CommituateTableViewCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"CommituateTableViewCell" owner:nil options:nil] lastObject];
                
            }
            cell.model=self.model;
            [cell reloadData];
            return cell;

        }
            break;
        case 6:
        {
            
            if (self.model.userPost==3) {
                
                CommituateTableViewCell*cell=[self.tableview dequeueReusableCellWithIdentifier:@"CommituateTableViewCell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"CommituateTableViewCell" owner:nil options:nil] lastObject];
                    
                }
                cell.model=self.model;
                return cell;
                
            }
            if ([self.model.qq isEqual:@""]&&[self.model.weChat isEqual:@""]) {
                
                Cell.content.text=@"师傅忘填了,囧~";
                return Cell;
            }
            if (self.model.certificate.count==0) {
                Cell.name.text=@"证        书";
                Cell.content.text=@"师傅忘填了,囧~";
                return Cell;
            }
            return [self getCertainCellWithTableview];
        }
            break;
        case 7:
        {
                    if (self.model.certificate.count==0) {
                Cell.name.text=@"证        书";
                Cell.content.text=@"师傅忘填了,囧~";
                return Cell;
            }
            return [self getCertainCellWithTableview];
        }
            break;
            default:
            break;
    }

    return Cell;
}


-(void)check{
    
    if (self.checkBlock) {
        self.checkBlock();
    }
    
}


-(NSString*)getAllSkillString{
    NSString*skillString;
    for (NSInteger i=0; i<[[self.model.service objectForKey:@"servicerSkills"] count]; i++){
        skillModel*model=[[skillModel alloc]init];
        [model setValuesForKeysWithDictionary:[self.model.service objectForKey:@"servicerSkills"][i]];
        if (i==0) {
            skillString=model.name;
        }else{
        
            skillString=[NSString stringWithFormat:@"%@、%@",skillString,model.name];
        }
    
    }
    return skillString;

}


-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView{
    
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell3"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell3"];
    }
    cell.selectionStyle=0;
    UIView*view=(id)[self viewWithTag:45];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
    view.tag=45;
    view.userInteractionEnabled=YES;
    NSArray*array=@[@"本人现场施工照",@"工地全景",@"防水施工面"];
    UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, 70, 20)];
    nameLabel.textColor=[UIColor lightGrayColor];
    nameLabel.text=@"明星工程";
    nameLabel.enabled=YES;
    nameLabel.userInteractionEnabled=NO;
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    UILabel*contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(93, 0, SCREEN_WIDTH-123, 20)];
    contentLabel.textColor=[UIColor blackColor];
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.text=[[self.model.service objectForKey:@"starMasterProjectCase"][0] objectForKey:@"caseName"];
    contentLabel.enabled=YES;
    contentLabel.userInteractionEnabled=NO;
    [view addSubview:contentLabel];
    NSMutableArray*rankArray=[[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
    NSArray*nameArray=@[@"siteFull",@"operateArea",@"masterWork"];
    for ( NSInteger i=0; i<3; i++) {
        caseDetail*detailModel=[[caseDetail alloc]init];
        [detailModel setValuesForKeysWithDictionary:[[self.model.service objectForKey:@"starMasterProjectCase"][0] objectForKey:@"projectCaseList"][i]];
        if ([detailModel.category isEqualToString:nameArray[0]]==YES) {
            [rankArray replaceObjectAtIndex:0 withObject:detailModel];
        }else if ([detailModel.category isEqualToString:nameArray[1]]==YES){
            
            [rankArray replaceObjectAtIndex:1 withObject:detailModel];
        }else{
            [rankArray replaceObjectAtIndex:2 withObject:detailModel];
            
        }
        
    }
    for (NSInteger i=0; i<3; i++) {
        CGFloat height;
        NSInteger width=70;
        CGFloat space=(SCREEN_WIDTH-26-3*width)/2;
        caseDetail*tempModel=rankArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,tempModel.resource];
        
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(13+i%3*(space+width), 20+i/3*(width+5), width, width)];
        imageview.tag=20+i;
        __block UIProgressView *pv;
        __weak UIImageView *weakImageView = imageview;
        imageview.userInteractionEnabled=YES;
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, width,width)];
        button.tag=30+i;
        [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds=YES;
        imageview.tag=40+i;
        [imageview addSubview:button];
        UILabel*functionLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.origin.x, CGRectGetMaxY(imageview.frame)+2, imageview.frame.size.width, 30)];
        functionLabel.font=[UIFont systemFontOfSize:12];
        functionLabel.numberOfLines=0;
        functionLabel.enabled=YES;
        functionLabel.userInteractionEnabled=NO;
        functionLabel.textColor=[UIColor lightGrayColor];
        functionLabel.textAlignment=NSTextAlignmentCenter;
        functionLabel.text=array[i];
        [imageview sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:urlString] andPlaceholderImage:[UIImage imageNamed:headImageName] options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!pv) {
                [weakImageView addSubview:pv = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault]];
                pv.frame = CGRectMake(0, 0, 100, 20);
                float showProgress = (float)receivedSize/(float)expectedSize;
                [pv setProgress:showProgress];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [pv removeFromSuperview];
            pv = nil;
            if (error) {
                imageview.image=[UIImage imageNamed:@"碎图"];
                
            }
            
        }];

        [view addSubview:functionLabel];
        [view addSubview:imageview];
    }
    [cell.contentView addSubview:view];

    return cell;
}


-(void)open:(UIButton*)button{
    
    if (self.starCaseDisplay) {
        UIImageView*imageview=(UIImageView*)[self viewWithTag:button.tag+10];
        self.starCaseDisplay(button.tag-30,imageview,self.model);
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableDisSelected) {
        self.tableDisSelected(indexPath,self.model);
    }
}



-(void)getCheckCell:(UITableView*)tableview {
    
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    UIView*view=(id)[self viewWithTag:10];
    if (view) {
        
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, cell.frame.size.height)];
    view.userInteractionEnabled=YES;
    view.tag=10;
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13,view.frame.size.height/2-10, 70, 20)];
    label.textColor=COLOR(143, 142, 142, 1);
    label.text=@"内容不符?";
    label.font=[UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-70, view.frame.size.height/2-15, 60, 30)];
    [button setTitle:@"举报" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    button.layer.cornerRadius=5;
    [button setTitleColor:COLOR(74, 166, 216, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [cell.contentView addSubview:view];
    cell.selectionStyle=0;
    self.tableview.tableFooterView=view;
    
}



//证书
-(UITableViewCell*)getCertainCellWithTableview{
    
    UITableViewCell*cell=[self.tableview dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell1"];
    }
    for (NSInteger i=0; i<cell.contentView.subviews.count; i++) {
        UIView*view=cell.contentView.subviews[i];
        [view removeFromSuperview];
    }
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, 70, 20)];
    label.text=@"证        书";
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label];
    NSInteger width=(SCREEN_WIDTH-110)/3;
    for (NSInteger i=0; i<self.model.certificate.count; i++) {
        CGFloat height;
        certificateModel*model=[[certificateModel alloc]init];
        [model setValuesForKeysWithDictionary:self.model.certificate[i]];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (self.model.certificate.count%3==0) {
            height=self.model.certificate.count/3*40;
        }
        else{
            height=(self.model.certificate.count/3+1)*40;
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(90 +i%3*(width+5), i/3*(width+5), width, width)];
        imageview.tag=20+i;
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanf:)];
        tap.numberOfTapsRequired=1;
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imageview.clipsToBounds=YES;
        [imageview addGestureRecognizer:tap];
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:headImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                imageview.image=[UIImage imageNamed:@"碎图"];
            }
        }];
        [cell.contentView addSubview:imageview];
    }
    cell.selectionStyle=0;
    return cell;
}

-(void)scanf:(UITapGestureRecognizer*)tap{

    if (self.imageDisplay) {
        UIImageView*imageview=(UIImageView*)[self viewWithTag:[tap view].tag];
        self.imageDisplay([tap view].tag-20,imageview,self.model);
    }

}

@end
