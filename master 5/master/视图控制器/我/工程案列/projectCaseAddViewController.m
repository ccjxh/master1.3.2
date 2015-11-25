//
//  projectCaseAddViewController.m
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "projectCaseAddViewController.h"
#import "TableViewCell.h"
#import "MyStartContentTableViewCell.h"
#import "PhotoManager.h"
#import "myCaseViewController.h"
#import "caseDetail.h"
@interface projectCaseAddViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,PhotoDelegate>

@end

@implementation projectCaseAddViewController
{
    NSMutableArray*_valueArray;
    NSMutableDictionary*_subDict;
    BOOL _isShow;
    NSMutableArray*_adminArray;//新增的数组
    NSMutableArray*_modelArray;
    NSMutableArray*_removeArray;//要移除的图片的数组
    __block NSMutableArray*_subDeleteArray;//提交的删除的数组
    __weak IBOutlet UIButton *regiButton;
}


-(void)setModel:(peojectCaseModel *)model{
    if (_picArray) {
        [_picArray removeAllObjects];
        [_picArray addObject:@""];
    }
    
    _model=model;
    if (model.applyFlg==1||model.applyFlg==2) {
        self.tableview.userInteractionEnabled=NO;
    }else{
    
        self.tableview.userInteractionEnabled=YES;
    }
    if (!_modelArray) {
        _modelArray=[[NSMutableArray alloc]init];
    }
    [_subDict setObject:model.caseName forKey:@"caseName"];
    [_subDict setObject:model.introduce forKey:@"introduce"];
    for (NSInteger i=0; i<model.projectCaseList.count; i++) {
        caseDetail*temp=[[caseDetail alloc]init];
        [temp setValuesForKeysWithDictionary:model.projectCaseList[i]];
        [_modelArray addObject:temp];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,temp.resource];
        [_subDict setObject:urlString forKey:[NSString stringWithFormat:@"url%d",i]];
        [_picArray addObject:temp];
    }
    
    if (model.applyFlg==1) {
        _isShow=NO;
        [regiButton setTitle:@"审核中" forState:UIControlStateNormal];
        [regiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        regiButton.userInteractionEnabled=NO;
    }else{
        [regiButton setTitle:@"提交审核" forState:UIControlStateNormal];
        [regiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        regiButton.userInteractionEnabled=YES;
        _isShow=YES;
    }
    
   
   [self.tableview reloadData];
    
}


-(instancetype)init{

    if (self=[super init]) {
        if (!_valueArray) {
            _valueArray=[[NSMutableArray alloc]init];
            [_valueArray addObject:@"请输入案例名称"];
            [_valueArray addObject:@"请输入案例说明"];
        }
        
        if (!_subDict) {
            _subDict=[[NSMutableDictionary alloc]init];
        }
        
        if (!_adminArray) {
            _adminArray=[[NSMutableArray alloc]init];
        }
        
        if (!_removeArray) {
            _removeArray=[[NSMutableArray alloc]init];
        }
        if (!_subDeleteArray) {
            _subDeleteArray=[[NSMutableArray alloc]init];
        }
    }
    
    if (!_picArray) {
        _picArray=[[NSMutableArray alloc]init];
    }
    [_picArray addObject:@""];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToken];
    _isShow=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _currentTableview=self.tableview;
    self.tableview.separatorStyle=1;
    self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self initData];
    [self initUI];
    NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:0];
    nameTableViewCell*cell=(nameTableViewCell*)[self.tableview cellForRowAtIndexPath:path];
    [cell.tx becomeFirstResponder];
    if (self.model) {
    [self setModel:self.model];
    }
    
    
    if (self.model.opinion) {
        self.opinion.text=[NSString stringWithFormat:@"审核意见:%@",self.model.opinion];
        self.labelHeight.constant=[self accountStringHeightFromString:[NSString stringWithFormat:@"审核意见:%@",self.model.opinion] Width:SCREEN_WIDTH-26 FrontSize:15];
    }else{
        self.labelHeight.constant=0;

    }
    
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    regiButton.layer.cornerRadius=10;
    regiButton.backgroundColor=COLOR(21, 168, 235, 1);
    [regiButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
}




-(void)confirm{
    
    UITextField*tx1=(id)[self.view viewWithTag:10];
    UITextView*tx2=(id)[self.view viewWithTag:11];
    [tx1 resignFirstResponder];
    [tx2 resignFirstResponder];
    if (self.type==0) {
    if (tx1.text.length==0) {
        [self.view makeToast:@"案例名称不能为空" duration:1 position:@"center"];
        [self flowHide];
        return;
    }
    if (tx2.text.length==0) {
        [self.view makeToast:@"案例说明不能为空" duration:1 position:@"center"];
        [self flowHide];
        return;
    }
    if (_picArray.count<=1) {
        [self.view makeToast:@"案例图片不能为空" duration:1 position:@"center"];
        return;
    }
        
    if (self.token==nil) {
            [self.view makeToast:@"当前网络不给力,请稍后重试" duration:1.5f position:@"center" Finish:^{
                [self requestToken];
            }];
            return;
        }
        
        [self flowShow];
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];;
        NSString*urlString=[self interfaceFromString:interface_uploadPhotos];
        [dict setObject:[_subDict objectForKey:@"caseName"] forKey:@"caseName"];
        [dict setObject:[_subDict objectForKey:@"introduce"] forKey:@"introduce"];
        [dict setObject:@"2" forKey:@"type"];
        [dict setObject:self.token forKey:@"token"];
        
        if (self.model) {
            urlString=[self interfaceFromString:interface_updateCase];
            [dict setObject:[NSString stringWithFormat:@"%lu",self.model.id] forKey:@"id"];
            NSString*removeID;
            for (NSInteger i=0; i<_removeArray.count; i++) {
                    caseDetail*tempModel=_removeArray[i];
                    if (tempModel.isDelete==YES) {
                        if (!removeID) {
                            removeID=[NSString stringWithFormat:@"%lu",tempModel.id];
                        }else{
                        
                            removeID=[NSString stringWithFormat:@"%@,%lu",removeID,tempModel.id];
                    }
                }
            }
            
            if (removeID) {
                [dict setObject:removeID forKey:@"removeFileId"];
            }
        }
        
        [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger temp=0;
        for (NSInteger i=1; i<_picArray.count; i++) {
            if ([_picArray[i] isKindOfClass:[caseDetail class]]==YES) {
                temp++;
                continue;
            }
            NSData*imageData=UIImageJPEGRepresentation(_picArray[i], 1);
              [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"files[%d].file",i-1-temp] fileName:[NSString stringWithFormat:@"%d.jpg",i-temp] mimeType:@"image/jpg"];
        }
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"提交成功" duration:1 position:@"center" Finish:^{
//                [self popWithnimation:self.navigationController];
                if (self.refershBlocl) {
                    self.refershBlocl();
                }
                for (UIViewController*vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[myCaseViewController class]]==YES) {
                        
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    
                }
                
            }];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self flowHide];
                [self.view makeToast:@"网络异常，请稍候重试" duration:1 position:@"center"];
        }];
    }
    if (self.type==1) {
        NSString*urlStrng=[self interfaceFromString:interface_adminProjecrCase];
    NSDictionary*dict=@{@"caseName":tx1.text,@"introduce":tx2.text,@"id":[NSString stringWithFormat:@"%lu",self.wordId]};
        [[httpManager share]POST:urlStrng parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"修改成功" duration:1 position:@"center" Finish:^{
                    
                        if (self.describChangeBlock) {
                            self.describChangeBlock(tx2.text);
                        }
                    
                    [self popWithnimation:self.navigationController];
                }];
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
        
    }

}


-(NSString*)requestToken{
    
    __block NSString*token;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self requestToken];
    }];
    return token;
}



-(void)initData{
   
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc]init];
    }
    UIImage*image=[UIImage imageNamed:@"增加图片"];
    [_imageArray addObject:image];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type==0) {
    return 3;
    }
    if (self.type==1) {
        return 2;
    }
    return 1;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==0||self.type==1) {
    if (indexPath.section<=1) {
        MyStartContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"MyStartContentTableViewCell"];
        if (!cell) {
            UINib*nib=[UINib nibWithNibName:@"MyStartContentTableViewCell" bundle:[NSBundle mainBundle]];
            [self.tableview registerNib:nib forCellReuseIdentifier:@"MyStartContentTableViewCell"];
            cell=[tableView dequeueReusableCellWithIdentifier:@"MyStartContentTableViewCell"];
        }
        cell.selectionStyle=0;
        cell.tx.delegate=self;
        if (indexPath.section==0) {
            cell.tx.tag=10;
            cell.name.text=@"案例名称";
            cell.tx.placeholder=_valueArray[indexPath.row];
            if ([_subDict objectForKey:@"caseName"]) {
                cell.tx.text=[_subDict objectForKey:@"caseName"];
            }
            return cell;
        }
        
        if(indexPath.section==1){
            cell.tx.tag=11;
            cell.name.text=@"案例说明";
            cell.tx.placeholder=_valueArray[indexPath.row];
            if ([_subDict objectForKey:@"introduce"]) {
                cell.tx.text=[_subDict objectForKey:@"introduce"];
            }
            cell.selectionStyle=0;
            return cell;
        }
      }
    }
    TableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[TableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    cell.picArray=_picArray;
    cell.isShow=_isShow;
    cell.block=^(NSInteger blockType,id objc){
        switch (blockType) {
            case 1:
            {
            //拍照
                
                [[PhotoManager share]getimageFromPhotosWithNavigation:self.navigationController];
                [PhotoManager share].delegate=self;
                
            }
                break;
                case 2:
            {
            //删除
                if ([objc isKindOfClass:[caseDetail class]]==YES) {
                    [_picArray removeObject:objc];
                    [_removeArray addObject:objc];
                    [self.tableview reloadData];
                    
                }else{
                UIImage*image=(UIImage*)objc;
                [self.picArray removeObject:image];
                NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:2];
                NSArray*array=@[path];
                [self.tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
                
                break;
            default:
                break;
        }
    
    };
    [cell reloadData];
    return cell;
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{

    switch (textView.tag) {
        case 10:
        {
            [_subDict setObject:textView.text forKey:@"caseName"];
            NSIndexPath*indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:0];
            [textView resignFirstResponder];
            
        }
            break;
            case 11:
        {
            [_subDict setObject:textView.text forKey:@"introduce"];
            NSIndexPath*indexpath=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:0];
            [textView resignFirstResponder];
        }
            break;
            
        default:
            break;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if ([_subDict objectForKey:@"caseName"]) {
                
                return   [self accountStringHeightFromString:[_subDict objectForKey:@"caseName"] Width:SCREEN_WIDTH-110 FrontSize:15]+16>44? [self accountStringHeightFromString:[_subDict objectForKey:@"caseName"] Width:SCREEN_WIDTH-110 FrontSize:15]+16:44;
            }
        }
            break;
        case 1:
            {
                if ([_subDict objectForKey:@"introduce"]) {
                    
                    return   [self accountStringHeightFromString:[_subDict objectForKey:@"introduce"] Width:SCREEN_WIDTH-110 FrontSize:15]+16>44?[self accountStringHeightFromString:[_subDict objectForKey:@"introduce"] Width:SCREEN_WIDTH-110 FrontSize:15]+16:44;
                }
                
            }
            
            break;
            case 2:
            {
            
                 NSInteger width=(SCREEN_WIDTH-30)/3;
                if (_picArray.count%3==0) {
                    return _picArray.count/3*(width+5)+10;
                }else{
                    
                    return (_picArray.count/3+1)*(width+5)+10;
                }
            }
            break;
            
        default:
            break;
    }
    return 44;

    
//    if (indexPath.section==0) {
//        if (self.type==2) {
//            if (_picArray.count%3==0) {
//                return _picArray.count/3*(width+5)+20;
//            }else{
//                
//                return (_picArray.count/3+1)*(width+5)+20;
//            }
//        }
//        return 54;
//    }else if (indexPath.section==1){
//    
//        return 60;
//    }else if (indexPath.section==2){
//        if (_picArray.count%3==0) {
//            return _picArray.count/3*(width+5)+10;
//        }else{
//        
//            return (_picArray.count/3+1)*(width+5)+10;
//        }
//    }
//    return 0;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 1;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor=COLOR(235, 235, 235, 1);
    return view;

}


-(void)dealPhontDictory:(NSMutableDictionary *)dict{
    
    UIImage*image=[UIImage imageWithData:[dict objectForKey:@"image"]];
    [_picArray addObject:image];
    [self.tableview reloadData];

}

- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }else  {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            
            switch (buttonIndex) {
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
            
        }else {
            
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }else {
                
                return;
            }
        }
        
        // 跳转到相机或相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //设置拍照后的图片可被编辑
        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"image info : %@",info);
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            CGFloat length;
            if (image.size.width>image.size.height) {
                length=image.size.height;
            }else{
                
                length=image.size.width;
            }
            CGSize imagesize = CGSizeMake(length, length);
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            [self.picArray insertObject:image atIndex:1];
            NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:2];
            NSArray*Array=@[path];
            [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
            //将图片转换成二进制
            
        }
    }];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
