//
//  PeoDetailViewController.m
//  master
//
//  Created by xuting on 15/7/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PeoDetailViewController.h"
#import "peopleDetailTableViewCell.h"
#import "peopleDetail2TableViewCell.h"
#import "peopleDetaileeTableViewCell.h"
#import "peopleDetail4TableViewCell.h"
#import "ReferrerCommentsCell.h"
#import "MasterDetailModel.h" //师傅详情model
#import "requestModel.h"
#import "OrderDetailViewController.h"
#import "projectCastDetailViewController.h"
#import "myProjectCaseViewController.h"
#import "InfoViewController.h"
#import "PeoCaseViewController.h"
#import "personDetailViewModel.h"
#import "InforView.h"
#define LABELTAG 300
@interface  PeoDetailViewController ()<personDetailDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

@end

@implementation PeoDetailViewController
{
    UIScrollView *scrollview; //底部滑动的scrollview
    NSInteger _cityID;    //城市id用于过滤服务区域
    peoplr*_valueModel;   //上级传来的数据模型
    NSInteger _favoriteFlag; //是否已标为喜欢
    UIButton*shareBtn;      //分享按钮
    NSString*shareUrl;      //分享的网址
    masterModel*recommModel; //分享的数据模型
    UIButton*collectBtn;   //收藏按钮
    BOOL _isCollect;//收藏状态
    InforView*_inforView;

    
}



-(instancetype)initWithCityId:(NSInteger)ID Peoplr:(peoplr *)model FavoriteFlag:(NSInteger)favoriteFlag IsCollect:(BOOL)isCollect{
    if (self=[super init]) {
        _cityID=city;
        _valueModel=model;
        _favoriteFlag=favoriteFlag;
        _isCollect=isCollect;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"详情";
    [self createUI];
    [self requestshare];
    [self createSlider];
    [self CreateFlow];

}



/**
 *  创建底部滑动模块
 */
-(void)createSlider{
    
    NSArray*array=@[@"基本信息",@"工程案例"];
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2-1, 44)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        UILabel*countLabel=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width/2+37, button.frame.size.height/2-10, 40, 20)];
        countLabel.font=[UIFont systemFontOfSize:16];
        countLabel.textColor=COLOR(0, 166, 237, 1);
        countLabel.enabled=YES;
        if ([[_valueModel.service objectForKey:@"projectCaseTotal"] integerValue]==0) {
            countLabel.text=nil;
        }else if ([[_valueModel.service objectForKey:@"projectCaseTotal"] integerValue]>99){
            countLabel.text=@"99+";

        }else{
         countLabel.text=[NSString stringWithFormat:@"(%lu)",[[_valueModel.service objectForKey:@"projectCaseTotal"] integerValue]];
        }
        countLabel.userInteractionEnabled=NO;
        if (i==1) {
            [button addSubview:countLabel];
        }
        [self.view addSubview:button];
        if (i==0) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width, 70, 1, 34)];
            view.backgroundColor=COLOR(205, 205, 205, 1);
            [self.view addSubview:view];
            UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 1)];
            view1.backgroundColor=COLOR(205, 205, 205, 1);
            [self.view addSubview:view1];
        }
    }
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH/2, 5)];
    label.backgroundColor=COLOR(22, 168, 233, 1);
    label.tag=LABELTAG;
    [self.view addSubview:label];
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, SCREEN_HEIGHT-112-49)];
    scrollview.delegate=self;
    scrollview.bounces=NO;
    scrollview.pagingEnabled=YES;
    scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-112-49);
    [self.view addSubview:scrollview];
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.pagingEnabled=YES;
    InfoViewController *avc = [[InfoViewController alloc] initWithCityId:_cityID Peoplr:_valueModel];
    PeoCaseViewController *wvc = [[PeoCaseViewController alloc] initWithID:_valueModel.id Navigation:self.navigationController];
    wvc.type=1;
    avc.title=@"基本信息";
    wvc.title=@"工程案例";
    [self addChildViewController:avc];
    [self addChildViewController:wvc];
    for (UIViewController*vc in self.childViewControllers) {
        if ([vc isKindOfClass:[InfoViewController class]]==YES) {
            vc.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, scrollview.frame.size.height);
            vc.view.backgroundColor=[UIColor blackColor];
            [scrollview addSubview:vc.view];
        }
        if ([vc isKindOfClass:[PeoCaseViewController class]]==YES) {
            vc.view.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollview.frame.size.height-49);
            [scrollview addSubview:vc.view];
        }
    }
    
    _inforView=[[InforView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    _inforView.name=_valueModel.realName;
    _inforView.mobile=_valueModel.mobile;
    _inforView.id=_valueModel.id;
    [self.view addSubview:_inforView];
}


-(void)change:(UIButton*)button{
    
    UILabel*label=(id)[self.view viewWithTag:LABELTAG];
    if ([button.titleLabel.text isEqualToString:@"基本信息"]==YES) {
        label.frame=CGRectMake(0, 108, SCREEN_WIDTH/2, 5);
        if (scrollview.contentOffset.x==0) {
            return;
        }else{
            
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }else{
        label.frame=CGRectMake(SCREEN_WIDTH/2, 108, SCREEN_WIDTH/2, 5);
        if (scrollview.contentOffset.x==SCREEN_WIDTH) {
            return;
        }else{
            
            [scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        }
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    UILabel*label=(id)[self.view viewWithTag:LABELTAG];
    label.frame=CGRectMake(scrollView.contentOffset.x/2, 108, SCREEN_WIDTH/2, 5);
    
}


/**
 *  定制导航栏
 */
-(void) createUI
{
    //导航栏右边按钮
    shareBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(210, 8, 17, 18);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_chare_normal"] forState:UIControlStateNormal];
    shareBtn.tag = 100;
    [shareBtn addTarget:self action:@selector(navRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    collectBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    collectBtn.frame = CGRectMake(250, 8, 21, 17);
    if (_favoriteFlag == 1)
    {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_great"] forState:UIControlStateNormal];
    }
    else
    {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_un_great"] forState:UIControlStateNormal];
    }
    collectBtn.tag = 101;
    [collectBtn addTarget:self action:@selector(navRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    NSArray *array = @[item2,item];
    self.navigationItem.rightBarButtonItems = array;
    
}


#pragma mark - 右侧导航栏按钮点击事件
-(void) navRight: (UIButton *)bt
{
    if (bt.tag == 101)
    {
        if (_favoriteFlag == 1)
        {
            [self flowShow];
            NSString*urlString=[self interfaceFromString:interface_delegateCollection];
            NSDictionary*dict=@{@"ids":[NSString stringWithFormat:@"%ld",_valueModel.id]};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                [self flowHide];
                if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                    [self.view makeToast:@"取消成功" duration:1 position:@"center" Finish:^{
                        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_un_great"] forState:UIControlStateNormal];
                        _favoriteFlag=0;
                    }];
                }else{
                    
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                
                [self flowHide];
               [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                
            }];
        }
        else
        {
            [self requestCollect];
            [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_great"] forState:UIControlStateNormal];
        }
        _isCollect = !_isCollect;
    }
    if (bt.tag==100) {
        [self selectShare];
    }
}



/**
 *  举报
 */
-(void)check{
    
    opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil Origin:nil Title:@"举报" Type:0 LimitCount:500 ID:_valueModel.id];
    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
}




#pragma mark - 添加收藏
-(void) requestCollect
{
    [self flowShow];
    NSString *urlString = [self interfaceFromString:interface_collectMaster];
    NSDictionary *dic = @{@"masterId":[NSNumber numberWithInteger:_valueModel.id]};
    [[httpManager share] POST:urlString parameters:dic success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        [self flowHide];
        if ([[objDic objectForKey:@"rspCode"]integerValue] == 200)
        {
            [self.view makeToast:@"收藏成功!" duration:2.0f position:@"center"];
            _favoriteFlag=1;
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络繁忙，请稍后重试" duration:1 position:@"center"];
        
    }];
}


/**
 *  分享的基础数据墨香设置
 */
-(void)requestshare{
    
    
    recommModel=[[masterModel alloc]init];
    recommModel.url=[NSString stringWithFormat:@"%@/admin/share/masterDetail?id=%ld",changeURL,_valueModel.id];
    recommModel.title=@"向您推荐一位宝师傅";
    recommModel.content=[NSString stringWithFormat:@"%@",_valueModel.realName];
    
    
}



#pragma mark-QQShare
-(void)setupQQShare{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [ShareSDK share:SSDKPlatformSubTypeQQFriend
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%u",_valueModel.id],@"shareType":@"1"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}


-(void)requestImageData{

    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,_valueModel.icon];
    [[httpManager share]POST:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

-(void)selectShare{
    
    UIActionSheet*actionsheet=[[UIActionSheet alloc]initWithTitle:@"请选择分享的地方" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到QQ" otherButtonTitles:@"分享到微信",@"分享到朋友圈",@"QQ空间", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionsheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        [self setupQQShare];
        
    }else if (buttonIndex==1){
    
        [self WeiChatShare];
        
    }else if (buttonIndex==2){
    
        [self shareWeichatCircle];
        
    }else if(buttonIndex==3){
        
        [self shareQzone];
    }
    
}



//分享到QQ空间
-(void)shareQzone{

     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    [ShareSDK share:SSDKPlatformSubTypeQZone
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",_valueModel.id],@"shareType":@"2"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];              
}

//微信分享
-(void)WeiChatShare{
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url] thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%ld",_valueModel.id],@"shareType":@"3"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

-(void)shareWeichatCircle{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url] thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%ld",_valueModel.id],@"shareType":@"4"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}


- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

-(void)share:(UIButton*)button{
    UIView*view=(id)[self.view viewWithTag:400];
    switch (button.tag) {
        case 300:
        {
            [view removeFromSuperview];
            [self setupQQShare];
        }
            break;
        case 301:
        {
            //微信分享
            [view removeFromSuperview];
            [self WeiChatShare];
        }
            break;
        case 302:
        {
            
            [view removeFromSuperview];
            
        }
            break;
        default:
            break;
    }
    
}



@end
