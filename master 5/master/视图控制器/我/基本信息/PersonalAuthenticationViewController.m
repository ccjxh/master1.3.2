//
//  PersonalAuthenticationViewController.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//真实姓名  性别 籍贯 年龄 身份证号码

#import "PersonalAuthenticationViewController.h"
#import "ModifyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "PersonalDetailModel.h"
#import "requestModel.h"
#import "myServiceDetaiTableViewCell.h"
#import "ModifySexViewController.h"
#import "ProvinceTableViewController.h"
#import "ChangeDateViewController.h"
@interface PersonalAuthenticationViewController ()<UIAlertViewDelegate>
{
    NSArray *personalAuthorArr ;
    NSMutableArray *personalAuthoArr; //保存个人认证
    UIImage *selectImage; //选中的图片
    NSString *resourceURL; //存放图片路径
    BOOL isIdentity;  //判断身份证姓名是否填写
    BOOL isIdNo;  //判断身份证号码是否填写
    BOOL isNoImage;   //判断证件照是否上传
    BOOL isAuthorType;  //认证类型
    NSInteger _currentTag;//当前选择的照片
    __weak IBOutlet NSLayoutConstraint *labelHeight;
}
@end

@implementation PersonalAuthenticationViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self flowShow];
}




-(void) viewDidAppear:(BOOL)animated
{
    [self flowHide];
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"basic" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAuthorType=NO;
    isIdentity=NO;
    isIdNo=NO;
    isNoImage=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.personalAuthorTableView.delegate = self;
    self.personalAuthorTableView.dataSource = self;
    self.personalAuthorTableView.scrollEnabled = NO; //设置表格不被滑动
    self.personalAuthorTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.personalAuthorTableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"personalAuthorTableView"];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateRegion:) name:@"basic" object:nil];
    personalAuthoArr = [[NSMutableArray alloc ]initWithObjects:@"真实姓名",@"性别",@"籍贯",@"年龄",@"身份证号",@"证件照",nil];
    self.navigationItem.title = @"个人认证";
    
    //获取当前日期
//    NSDate *senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *locationString=[dateformatter stringFromDate:senddate];
//    self.contentLabel.text = [NSString stringWithFormat:@"于%@提交验证，工作人员将于一工作日内反馈认证结果。请耐心等候!",locationString];
    
    //导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交认证" style:UIBarButtonItemStylePlain target:self action:@selector(personalAuthorSureBtn)];
    [self CreateFlow];
}


-(void) upDateRegion:(NSNotification *)nof
{
    
    if ([[USER_DEFAULT objectForKey:@"type"] integerValue]==10) {
    NSDictionary *dict =  nof.object;
    [requestModel requestRegionInfo:[dict objectForKey:@"regionId"]];
    NSArray *arr = [[dict objectForKey:@"region"] componentsSeparatedByString:@"-"];
    NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
    [pDict setObject:arr[0] forKey:@"name"];
    NSMutableDictionary *cDict = [NSMutableDictionary dictionary];
    [cDict setObject:arr[1] forKey:@"name"];
    
    //    NSMutableDictionary *rDict = [NSMutableDictionary dictionary];
    //    [rDict setObject:arr[2] forKey:@"name"];
    
    self.model.nativeProvince = pDict;
    self.model.nativeCity = cDict;
    [_personalAuthorTableView reloadData];
    }
}


#pragma mark - 个人认证确定按钮
-(void) personalAuthorSureBtn
{
    
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"审核通过后,该部分内容将不可修改,是否立即提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    [alter show];
    
    
    }



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if ([[self.model.certification objectForKey:@"personal"]integerValue] == 1)
        {
            [self popWithnimation:self.navigationController];
        }
        else
        {
            [self flowShow];
            if(isIdentity == NO)
            {
                [self.view makeToast:@"请输入真实身份!" duration:2.0f position:@"center"];
                [self flowHide];
            }else if (self.model.realName==nil){
                [self.view makeToast:@"请输真实姓名!" duration:2.0f position:@"center"];
                [self flowHide];
                return;
                
                
            }else if (self.model.gendar==nil){
                [self.view makeToast:@"请选择性别!" duration:2.0f position:@"center"];
                [self flowHide];
                return;
                
                
            }else if ([self.model.nativeProvince objectForKey:@"name"]==nil){
                [self.view makeToast:@"请选择籍贯" duration:2.0f position:@"center"];
                [self flowHide];
                return;
                
                
            }
            else if (self.model.birthday==nil){
                [self.view makeToast:@"请选择年龄" duration:2.0f position:@"center"];
                [self flowHide];
                return;
                
                
            }
            else if (isIdNo == NO)
            {
                [self.view makeToast:@"请输入真实身份证号码!" duration:2.0f position:@"center"];
                [self flowHide];
                return;
                
            }
            else if(self.model.idNoFile == nil||self.model.idNoBackFile==nil)
            {
                [self.view makeToast:@"请上传证件照!" duration:2.0f position:@"center"];
                [self flowHide];
                return;
            }
            
            [self requestPersonalAuthor];
        }

    }

}


#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    loginModel*logModel=[[dataBase share]findLoginInformationWithID:delegate.id];
    if ([[self.model.certification objectForKey:@"personal"]integerValue] == 1)
    {
        [self.view makeToast:@"已认证或认证状态用户不支持修改个人信息!" duration:2.0f position:@"bottom"];
    }
    else
    {
        
        if (indexPath.row==1) {
            
            ModifySexViewController *ctl = [[ModifySexViewController alloc] init];
            ctl.gendarValueBlock = ^(long gendarId,long tag){
                NSString *urlString = [self interfaceFromString:interface_updateGendar];
                NSDictionary *dict = @{@"gendar":[NSNumber numberWithLong:gendarId]};
                [requestModel isRequestSuccess:urlString :dict : self.personalAuthorTableView];
                if (gendarId == 0)
                {
                    self.model.gendar = @"男";
                }
                else
                {
                    self.model.gendar = @"女";
                }
                
                [self.personalAuthorTableView reloadData];
            };
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            
        }
        
        if (indexPath.row == 0 || indexPath.row == 4)
        {
            
            ModifyInfoViewController *ctl = [[ModifyInfoViewController alloc] init];
            if (indexPath.row == 0)
            {
                ctl.content = self.model.realName;
            }
            else
            {
                ctl.content = self.model.idNo;
            }
            ctl.index = indexPath.row + 3;
            if (indexPath.row==4) {
                ctl.index=indexPath.row;
            }
            ctl.flag = indexPath.row;
            ctl.modifyBasicInfoBlock = ^(NSString *content,long flag){
                
                [personalAuthoArr setObject:content atIndexedSubscript:flag];
                [self.personalAuthorTableView reloadData];
                if (indexPath.row == 0)
                {
                    self.model.realName = content;
                    NSString *urlString=[self interfaceFromString:interface_updateRealName];
                    NSDictionary *dict = @{@"realName":content};
                    [self isRequestSuccess:urlString :dict:indexPath.row];
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                                       model.realName=content;
                    [[dataBase share]addInformationWithModel:model];
                }
                else if (indexPath.row == 4)
                {
                    self.model.idNo = content;
                    NSString *urlString=[self interfaceFromString:interface_updateIDNo];
                    NSDictionary *dict = @{@"idNo":content};
                    [self isRequestSuccess:urlString :dict:indexPath.row];
                }
                [self.personalAuthorTableView reloadData];
            };
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
        
        else if (indexPath.row==2){
        
            ProvinceTableViewController *ctl = [[ProvinceTableViewController alloc] init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"10" forKey:@"type"];
            [defaults synchronize];
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            
        }
        else if (indexPath.row==3){
        
            ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
            cvc.isfuture=YES;
            cvc.isPass=YES;
            if (self.model.birthday) {
                cvc.oldDate=self.model.birthday;
                
            }
            cvc.blockDateValue=^(NSString*date){
                [self flowShow];
                NSString*urlString=[self interfaceFromString:interface_updateBirthday];
                NSArray*temp=[date componentsSeparatedByString:@"-"];
                NSString*birthday=[NSString stringWithFormat:@"%@/%@/%@",temp[0],temp[1],temp[2]];
                NSDictionary*dict=@{@"birthday":birthday};
                [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    [self flowHide];
                    if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                        
                        if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                            logModel.integrity=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"];
                            [[dataBase share]updatePrimaryInforWithModel:logModel];
                            
                        }
                        if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                            if ([logModel.integral integerValue]-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                                logModel.integral=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"];
                                [[dataBase share]updatePrimaryInforWithModel:logModel];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"showIncreaImage" object:nil];
                            }
                            
                        }
                        
                        [self.view makeToast:@"更新成功" duration:1 position:@"center" Finish:^{
                            
                            self.model.birthday=date;
                            [_personalAuthorTableView reloadData];
                        }];
                    }else{
                        
                        [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                    [self flowHide];
                    [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
                    
                }];
            };
            
            [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
        
        
        }
        else
        {
//            [self setUserHeaderIamge];
        }
    }
}

#pragma mark - UITableViewDataSource
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        return 150;
    }
    return 44;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return personalAuthoArr.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [personalAuthoArr replaceObjectAtIndex:1 withObject:@"性别"];
    myServiceDetaiTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"myServiceDetaiTableViewCell"];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"myServiceDetaiTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.liadToRight.constant=-8;
    cell.name.text = personalAuthoArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        if ([self.model.realName isEqualToString:@""])
        {
            cell.content.text = @"请输入真实姓名";
            cell.content.hidden=YES;
            cell.content.textColor = [UIColor grayColor];
        }
        else
        {
            cell.content.text = self.model.realName;
            cell.content.textColor = [UIColor blackColor];
            isIdentity=YES;
        }
    }
    if (indexPath.row==1) {
        if ([self.model.gendar isEqualToString:@""])
        {
            cell.content.text = @"请选择性别";
            cell.content.textColor = [UIColor grayColor];
        }
        else
        {
            cell.content.text = self.model.gendar;
            cell.content.textColor = [UIColor blackColor];
            isIdentity=YES;
        }

    }
    if (indexPath.row==2) {
        
        NSString *str = [self.model.nativeProvince objectForKey:@"name"];
        
    
        self.contentLabel.text = str;
        if (!str)
        {
          
            cell.content.text = @"请选择籍贯";
            cell.content.textColor = [UIColor grayColor];
        }
        else
        {
            NSString* str1 = [str stringByAppendingFormat:@"-%@",[self.model.nativeCity objectForKey:@"name"]];
            cell.content.text = str1;
            cell.content.textColor = [UIColor blackColor];
            isIdentity=YES;
        }

    }
    if (indexPath.row==3) {
        
        if (!self.model.birthday)
        {
            cell.content.text = @"请选择年龄";
            cell.content.textColor = [UIColor grayColor];
        }
        else
        {
            cell.content.text = [self getAgeFromDate:self.model.birthday];
            cell.content.textColor = [UIColor blackColor];
            isIdentity=YES;
        }
    }
    
     if (indexPath.row == 4)
    {
        
        if ([self.model.idNo isEqualToString:@""])
        {
            cell.content.text = @"请输入身份证号";
            cell.content.textColor = [UIColor grayColor];
        }
        else
        {
            cell.content.text = self.model.idNo;
            cell.content.textColor = [UIColor blackColor];
            isIdNo=YES;
        }
    }
    else
    {
        if (self.model.idNoFile != nil)
        {
            isNoImage = YES;
        }
        if (indexPath.row==5) {
            
            NSArray*array=@[@"身份证正面照片",@"身份证背面照片"];
            for (UIView*view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 5, 120, 20)];
            nameLabel.text=@"身份证照片";
            nameLabel.textColor=[UIColor blackColor];
            nameLabel.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:nameLabel];
            for (NSInteger i=0; i<array.count; i++) {
                
                UIImageView*photoImage=[[UIImageView alloc]initWithFrame:CGRectMake(13+i*150, 35, 100, 70)];
                photoImage.userInteractionEnabled=YES;
                photoImage.tag=40+i;
                photoImage.image=[UIImage imageNamed:array[i]];
                if (i==0&&self.model.idNoFile) {
                    [photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,self.model.idNoFile]] placeholderImage:[UIImage imageNamed:array[i]]];
                                                }
                if (i==1&&self.model.idNoBackFile) {
                    [photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,self.model.idNoBackFile]] placeholderImage:[UIImage imageNamed:array[i]]];
                }
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(photoImage.frame.origin.x, CGRectGetMaxY(photoImage.frame)+5, photoImage.frame.size.width, 15)];
                label.text=array[i];
                label.font=[UIFont systemFontOfSize:14];
                label.textColor=[UIColor lightGrayColor];
                [cell.contentView addSubview:label];
                photoImage.contentMode =  UIViewContentModeScaleAspectFit;
//                photoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                photoImage.clipsToBounds=YES;
                UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPhotos:)];
                tap.numberOfTapsRequired=1;
                tap.numberOfTouchesRequired=1;
                [photoImage addGestureRecognizer:tap];
                [cell.contentView addSubview:photoImage];
            }
            
            [self flowHide];
            
        }
       
    }
    return cell;
}


-(void)uploadPhotos:(UITapGestureRecognizer*)tap{

    _currentTag=[tap view].tag;
    if ([tap view].tag==40) {
        //正面照片
        [self setUserHeaderIamge];
        
    }else{
        //反面照片
    
        [self setUserHeaderIamge];
    }

}

#pragma mark - 判断请求是否成功
-(void) isRequestSuccess : (NSString*)url : (NSDictionary*)dict : (long)row
{
    [[httpManager share] POST:url parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200)
        {
            [self.view makeToast:@"更新成功" duration:1.5f position:@"center"];
//            NSLog(@"保存成功");
            if (row == 0)
            {
                isIdentity = YES;
            }
            else if (row == 1)
            {
                isIdNo = YES;
            }
        }
        else
        {
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
//            NSLog(@"保存失败");
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}
#pragma mark - 更换头像
- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 255)
    {
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
        {
            
            switch (buttonIndex)
            {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else
            {
                return;
            }
        }
        
        // 跳转到相机或相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //设置拍照后的图片可被编辑
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self flowShow];
//        NSLog(@"image info : %@",info);
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            CGFloat length;
            if (image.size.width>image.size.height) {
                length=image.size.height;
            }else{
                
                length=image.size.width;
            }
            CGSize imagesize = CGSizeMake(length, length);
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            //将图片转换成二进制
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.1);
            selectImage=nil;
            if (selectImage == nil)
            {
                selectImage = [UIImage imageWithData:imageData];
                NSString*urlString=[self interfaceFromString:interface_uploadHeadImage];
                NSDictionary *dict;
                NSString*type;
                if (_currentTag==40) {
                    type=@"idNo";
                    if (self.model.idNoId==nil) {
    
                        dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNo",@"workId":self.model.id};
                    }else{
                        dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNo",@"workId":self.model.id,@"removeFileId":self.model.idNoId};
                    }
                    
                }else{
                    type=@"idNoBack";
                    if (self.model.idNoBackFileId==nil) {
                    dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNoBack",@"workId":self.model.id,};
                    }else{
                    dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNoBack",@"workId":self.model.id,@"removeFileId":self.model.idNoBackFileId};
                    
                    }
                }
                
                    [self flowShow];
                [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSData *data = UIImageJPEGRepresentation(selectImage, 0.5);
                    [formData appendPartWithFileData:data name:@"file" fileName:[@"3" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSLog(@"++++++%@",responseObject);
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [[loginManager share]requestPersonalInformation];
                    NSDictionary*postDict=@{@"picture":image};
                    NSNotification*notiction=[[NSNotification alloc]initWithName:@"headRefersh" object:nil userInfo:postDict];
                    [[NSNotificationCenter defaultCenter]postNotification:notiction];
                    //                    headimag=image;
                    
                    [self requestInfor];
                    }
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                   
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@" 结果 ===== %@",error);
                    [self flowHide];
                }];
            }
        }
    }];
}

-(void)requestInfor{

    NSString*urlString=[self interfaceFromString:interface_personalDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
             [self flowHide];
            if (_currentTag==40) {
                self.model.idNoFile=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoFile"];
                self.model.idNoId=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoId"];
            }else{
                
                self.model.idNoBackFile=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoBackFile"];
                self.model.idNoBackFileId=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoBackFileId"];
            }
            
        }
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [[dataBase share]updateInformationWithTable:@"information" Id:delegate.id Attribute:@"personalState" Content:@"1"];
        [self.personalAuthorTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
         [self flowHide];
        
    }];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
//    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 判断个人认证是否正确
-(void) requestPersonalAuthor
{
     AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    NSString *urlString = [self interfaceFromString:interface_uploadIdentity];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
       
        [self flowHide];
        NSDictionary*objDic=(NSDictionary*)responseObject;
        NSString *str = [objDic objectForKey:@"msg"];
        if ([[objDic objectForKey:@"rspCode"] integerValue]==200)
        {
            model.personalState=1;
            model.certification=[self getDictoryWithModel:model];
            [[dataBase share]updateInformationWithWithPeopleInfoematin:model];
            [self.view makeToast:@"资料已提交，请耐心等候!" duration:2.0f position:@"center"];
            if (self.authorTypeBlock)
            {
                isAuthorType = YES;
                self.authorTypeBlock(isAuthorType);
            }
            [self popWithnimation:self.navigationController];
            
        }
        else if ([[objDic objectForKey:@"rspCode"] integerValue]==500)
        {
            [self.view makeToast:str duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
    }];
}



@end
