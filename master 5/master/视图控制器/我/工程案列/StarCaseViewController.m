//
//  StarCaseViewController.m
//  master
//
//  Created by jin on 15/11/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "StarCaseViewController.h"
#import "StarCaseExample.h"
#import "MyStartContentTableViewCell.h"
#import "StarCaseExample.h"
#import "StarPhotosTableViewCell.h"
#import "PhotoManager.h"
#import "myCaseViewController.h"
#import "caseDetail.h"
@interface StarCaseViewController ()<UITextViewDelegate ,PhotoDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation StarCaseViewController
{

    __weak IBOutlet UIButton *registerButton;
    NSMutableArray*_valueArray;
    NSMutableArray*_ShowArray;
    NSInteger _index;
    NSMutableDictionary*_picDict;
    NSMutableDictionary*_subDict;
    __block NSString*_token;
    __weak IBOutlet NSLayoutConstraint *tableviewToTop;
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        if (!_valueArray) {
            _valueArray=[[NSMutableArray alloc]init];
        }
        [_valueArray addObject:@"请输入案例名称"];
        [_valueArray addObject:@"请输入案例说明"];
    }
    if (!_ShowArray) {
        _ShowArray=[[NSMutableArray alloc]init];
    }
    [_ShowArray addObject:@"0"];
    [_ShowArray addObject:@"0"];
    if (!_picDict) {
        _picDict=[[NSMutableDictionary alloc]init];
    }
    
    if (!_subDict) {
        _subDict=[[NSMutableDictionary alloc]init];
    }
    return self;

}


-(void)setEditable:(BOOL)Editable{
    _Editable=Editable;
    if (Editable==NO) {
        [registerButton setTitle:@"审核中" forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        registerButton.userInteractionEnabled=NO;
        
        
    }else{
    
        [registerButton setTitle:@"提交审核" forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerButton.userInteractionEnabled=YES;
        
    }
    if (self.model.applyFlg==2) {
        registerButton.hidden=YES;
    }

}


-(void)setModel:(peojectCaseModel *)model{

    _model=model;
    [_subDict setObject:model.introduce forKey:@"introduce"];
    [_subDict setObject:model.caseName forKey:@"caseName"];
    
    for (NSInteger i=0; i<3; i++) {
        caseDetail*temp=[[caseDetail alloc]init];
        [temp setValuesForKeysWithDictionary:model.projectCaseList[i]];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,temp.resource];
        if ([temp.category isEqualToString:@"masterWork"]==YES) {
            
            [_picDict setObject:urlString  forKey:[NSString stringWithFormat:@"url2"]];
 
        }
        
        if ([temp.category isEqualToString:@"operateArea"]==YES) {
            [_picDict setObject:urlString  forKey:[NSString stringWithFormat:@"url1"]];
            

        }
        if ([temp.category isEqualToString:@"siteFull"]==YES) {
            [_picDict setObject:urlString  forKey:[NSString stringWithFormat:@"url0"]];
            
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
    [self setEditable:self.Editable];
    [self requestToken];
    if (self.model.opinion) {
        self.opinion.text=[NSString stringWithFormat:@"审核意见:%@",self.model.opinion];
        self.labelHeight.constant=[self accountStringHeightFromString:[NSString stringWithFormat:@"审核意见:%@",self.model.opinion] Width:SCREEN_WIDTH-14 FrontSize:15];
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


-(void)requestToken{
    
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        _token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        return ;
        }else{
        
            [self requestToken];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self requestToken];
    }];
    
}



-(void)CreateUI{

    
    if (self.model.applyFlg==3) {
//    tableviewToTop.constant=tableviewToTop.constant+
    }
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    StarCaseExample*example=[[[NSBundle mainBundle]loadNibNamed:@"StarCaseExample" owner:nil options:nil] lastObject];
    example.firstLabel.text=[NSString stringWithFormat:@"%@\n%@",@"本人",@"现场施工照"];
    self.view.backgroundColor=COLOR(235, 235, 235, 1);
    self.tableview.backgroundColor=COLOR(235, 235, 235, 1);
    if (self.model.applyFlg==2) {
        self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    }else{
    self.tableview.tableFooterView=example;
    }
    registerButton.layer.cornerRadius=10;
    registerButton.backgroundColor=COLOR(21, 168, 235, 1);
    [registerButton addTarget:self action:@selector(ligin) forControlEvents:UIControlEventTouchUpInside];

}

//提交审核
-(void)ligin{

    if (_token==nil) {
        [self.view makeToast:@"当前网络繁忙,请稍后提交" duration:1 position:@"center"];
        return;
    }
    if ([_subDict objectForKey:@"caseName"]==nil) {
        [self.view makeToast:@"案例名称不能为空" duration:1 position:@"center"];
        return;
    }
    if ([_subDict objectForKey:@"introduce"]==nil) {
        [self.view makeToast:@"案例介绍不能为空" duration:1 position:@"center"];
        return;
    }
    
    if ([_subDict objectForKey:@"introduce"]==nil) {
        [self.view makeToast:@"案例介绍不能为空" duration:1 position:@"center"];
        return;
    }
    if ([_picDict objectForKey:@"image0"]==nil) {
        [self.view makeToast:@"本人现场施工找不能为空" duration:1 position:@"center"];
        return;
    }

    if ([_picDict objectForKey:@"image1"]==nil) {
        [self.view makeToast:@"工地全景照不能为空" duration:1 position:@"center"];
        return;
    }
    if ([_picDict objectForKey:@"image2"]==nil) {
        [self.view makeToast:@"防水施工面不能为空" duration:1 position:@"center"];
        return;
    }
     NSString*urlString=[self interfaceFromString:interface_uploadPhotos];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict  setObject:_token forKey:@"token"];
    [dict setObject:[_subDict objectForKey:@"caseName"] forKey:@"caseName"];
    [dict setObject:[_subDict objectForKey:@"introduce"] forKey:@"introduce"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:@"siteFull" forKey:@"files[0].category"];
    [dict setObject:@"operateArea" forKey:@"files[1].category"];
    [dict setObject:@"masterWork" forKey:@"files[2].category"];
    if (self.model) {
        [dict setObject:[NSString stringWithFormat:@"%lu",self.model.id] forKey:@"id"];
        urlString=[self interfaceFromString:interface_updateCase];
    }
    
    [self flowShow];
   
       [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i=0; i<3; i++) {
            [formData appendPartWithFileData:[_picDict objectForKey:[NSString stringWithFormat:@"image%d",i]] name:[NSString stringWithFormat:@"files[%d].file",i] fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        
        if ([[dict objectForKey:@"rspCode"]integerValue]==200) {
            [self.view makeToast:@"提交成功"  duration:1 position:@"center" Finish:^{
               
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

    }];

}


-(void)myProgressTask{



}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==2) {
        return 155;
    }
    
    switch (indexPath.row) {
        case 0:
            return 40;
            break;
        case 1:
            {
                if ([_subDict objectForKey:@"introduce"]) {
                    
                      NSLog(@"%lf", [self accountStringHeightFromString:[_subDict objectForKey:@"introduce"] Width:SCREEN_WIDTH-110 FrontSize:15]+16);
                    return   [self accountStringHeightFromString:[_subDict objectForKey:@"introduce"] Width:SCREEN_WIDTH-110 FrontSize:15]+16>44?[self accountStringHeightFromString:[_subDict objectForKey:@"introduce"] Width:SCREEN_WIDTH-110 FrontSize:15]+16:44;
                   
                }
                
            }
            
            break;
        default:
            break;
        }
    return 44;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyStartContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"MyStartContentTableViewCell"];
    if (!cell) {
        UINib*nib=[UINib nibWithNibName:@"MyStartContentTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:nib forCellReuseIdentifier:@"MyStartContentTableViewCell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"MyStartContentTableViewCell"];
    }

    cell.selectionStyle=0;
    cell.tx.delegate=self;
    if (indexPath.row==0) {
        cell.tx.tag=10;
        cell.name.text=@"案例名称";
        cell.tx.placeholder=_valueArray[indexPath.row];
        if ([_subDict objectForKey:@"caseName"]) {
            cell.tx.text=[_subDict objectForKey:@"caseName"];
        }
        if (self.Editable==NO) {
            cell.userInteractionEnabled=NO;
        }
            return cell;
    }
    
    if(indexPath.row==1){
        cell.tx.tag=11;
        cell.name.text=@"案例说明";
        cell.tx.placeholder=_valueArray[indexPath.row];
        cell.selectionStyle=0;
        if ([_subDict objectForKey:@"introduce"]) {
            cell.tx.text=[_subDict objectForKey:@"introduce"];
        }
        if (self.Editable==NO) {
            cell.userInteractionEnabled=NO;
        }
        return cell;
    }
    StarPhotosTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"StarPhotosTableViewCell"];
    if (!Cell) {
        UINib*nib=[UINib nibWithNibName:@"StarPhotosTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:nib forCellReuseIdentifier:@"StarPhotosTableViewCell"];
        Cell=[tableView dequeueReusableCellWithIdentifier:@"StarPhotosTableViewCell"];
    }
    
    
    Cell.selectionStyle=0;
    for (NSInteger i=0; i<3; i++) {
        if (![_picDict objectForKey:[NSString stringWithFormat:@"image%d",i]]) {
            if ([_picDict objectForKey:[NSString stringWithFormat:@"url%d",i]]) {
                if (i==0) {
                    NSString*urlString=[NSString stringWithFormat:@"%@",[_picDict objectForKey:[NSString stringWithFormat:@"url%d",i]]];                    [Cell.first.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            [Cell.first setImage:[UIImage imageNamed:headImageName] forState:UIControlStateNormal];
                        }else{
                        
                           [Cell.first setImage:image forState:UIControlStateNormal];
                             NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                            [_picDict setObject:imageData forKey:@"image0"];
                        }
                        
                    }];
                }else if (i==1){
                
                    NSString*urlString=[NSString stringWithFormat:@"%@",[_picDict objectForKey:[NSString stringWithFormat:@"url%d",i]]];
                    [Cell.second.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            [Cell.second setImage:[UIImage imageNamed:headImageName] forState:UIControlStateNormal];
                        }else{
                            
                            [Cell.second setImage:image forState:UIControlStateNormal];
                            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);

                            [_picDict setObject:imageData forKey:@"image1"];

                        }
                    }];
                }else if (i==2){
                
                    NSString*urlString=[NSString stringWithFormat:@"%@",[_picDict objectForKey:[NSString stringWithFormat:@"url%d",i]]];
                    [Cell.third.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            [Cell.third setImage:[UIImage imageNamed:headImageName] forState:UIControlStateNormal];
                        }else{
                            
                            [Cell.third setImage:image forState:UIControlStateNormal];
                            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                            [_picDict setObject:imageData forKey:@"image2"];

                        }
                    }];
                }
            }
        }else{
        
            switch (i) {
                case 0:
                    [Cell.first setImage:[UIImage imageWithData:[_picDict objectForKey:[NSString stringWithFormat:@"image%d",i]]] forState:UIControlStateNormal];
                    
                    break;
                    case 1:
                    [Cell.second setImage:[UIImage imageWithData:[_picDict objectForKey:[NSString stringWithFormat:@"image%d",i]]] forState:UIControlStateNormal];
                    break;
                    case 2:
                    [Cell.third setImage:[UIImage imageWithData:[_picDict objectForKey:[NSString stringWithFormat:@"image%d",i]]] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }
    [Cell.first addTarget:self action:@selector(postfirst) forControlEvents:UIControlEventTouchUpInside];
    [Cell.second addTarget:self action:@selector(postsecond) forControlEvents:UIControlEventTouchUpInside];
    [Cell.third addTarget:self action:@selector(postThird) forControlEvents:UIControlEventTouchUpInside];
    Cell.firstLabel.text=[NSString stringWithFormat:@"%@\n%@",@"本人",@"现场施工照"];
    Cell.selectionStyle=0;
    return Cell;
    
}


-(void)postfirst{
    _index=0;
    if (self.Editable==NO) {
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:_index inSection:0];
    StarPhotosTableViewCell*cell=[self.tableview cellForRowAtIndexPath:indexPath];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObject:[_picDict objectForKey:@"url0"]];
    [array addObject:[_picDict objectForKey:@"url1"]];
    [array addObject:[_picDict objectForKey:@"url2"]];
        UIImageView*imagevie=[[UIImageView alloc]init];
    [self displayPhotosWithIndex:_index Tilte:self.model.caseName describe:self.model.introduce ShowViewcontroller:self UrlSarray:array ImageView:imagevie];
        return;
    }
     [[PhotoManager share]getimageFromPhotosWithNavigation:self.navigationController];
    [PhotoManager share].delegate=self;
    
}




-(void)postsecond{
    _index=1;
    if (self.Editable==NO) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:_index inSection:0];
        StarPhotosTableViewCell*cell=[self.tableview cellForRowAtIndexPath:indexPath];
        NSMutableArray*array=[[NSMutableArray alloc]init];
        [array addObject:[_picDict objectForKey:@"url0"]];
        [array addObject:[_picDict objectForKey:@"url1"]];
        [array addObject:[_picDict objectForKey:@"url2"]];
        UIImageView*imageview=[[UIImageView alloc]init];
        [self displayPhotosWithIndex:_index Tilte:self.model.caseName describe:self.model.introduce ShowViewcontroller:self UrlSarray:array ImageView:imageview];
        return;
    }
    [[PhotoManager share]getimageFromPhotosWithNavigation:self.navigationController];
    [PhotoManager share].delegate=self;


}

-(void)postThird{
    
    _index=2;
    if (self.Editable==NO) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:_index inSection:0];
        StarPhotosTableViewCell*cell=[self.tableview cellForRowAtIndexPath:indexPath];
        NSMutableArray*array=[[NSMutableArray alloc]init];
        [array addObject:[_picDict objectForKey:@"url0"]];
        [array addObject:[_picDict objectForKey:@"url1"]];
        [array addObject:[_picDict objectForKey:@"url2"]];
        UIImageView*imageview=[[UIImageView alloc]init];

        [self displayPhotosWithIndex:_index Tilte:self.model.caseName describe:self.model.introduce ShowViewcontroller:self UrlSarray:array ImageView:imageview];
        return;
    }
    [[PhotoManager share]getimageFromPhotosWithNavigation:self.navigationController];
    [PhotoManager share].delegate=self;

}


-(void)dealPhontDictory:(NSMutableDictionary *)dict{
    switch (_index) {
        case 0:
        {
            [_picDict setObject:[dict objectForKey:@"image"] forKey:@"image0"];
            
        }
            break;
            case 1:
        {
            [_picDict setObject:[dict objectForKey:@"image"] forKey:@"image1"];
 
        }
            break;
            case 2:
        {
            [_picDict setObject:[dict objectForKey:@"image"] forKey:@"image2"];

        }
            break;
        default:
            break;
    }
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    NSString*urlString=[self interfaceFromString:interface_uploadPhotos];
    

}


-(void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.tag==10) {
        [_subDict setObject:textView.text forKey:@"caseName"];
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        
        [_subDict setObject:textView.text forKey:@"introduce"];
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

-(void)textViewDidChange:(UITextView *)textView{

    
    }



@end
