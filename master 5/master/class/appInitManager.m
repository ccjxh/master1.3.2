//
//  appInitManager.m
//  master
//
//  Created by jin on 15/10/21.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "appInitManager.h"
#import "XGPush.h"
#import <Bugly/CrashReporter.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SMS_SDK/SMSSDK.h>
#import "LoginViewController.h"
#import "guideViewController.h"
@implementation appInitManager
{
    CLLocationManager*_mapManager;//定位点点管理
    CLGeocoder*_geocoder;
    NSDictionary*_pushDictory;//推送字典
}

+(appInitManager*)share{

    static dispatch_once_t once;
    static appInitManager*manager;
    dispatch_once(&once, ^{
        if (!manager) {
            manager=[[appInitManager alloc]init];
        }
    });
    
    return manager;
}


-(void)initPrimaryThirdLibrary{
    
    [self setupServicePhone];
    
    [XGPush startApp:2200136520 appKey:@"I197YN27CXHD"];  //信鸽推送初始化
    
    [[CrashReporter sharedInstance] installWithAppId:@"900006644"];//bugly初始化
    
    [SMSSDK registerApp:@"93852832ce02"
             withSecret:@"a28d5c5bfbb3ddee35bf3a9585895472"];//短信验证初始化
    
    [self checkUpServicePhone]; //检测客服电话

    
    [self setupADImage];//设置启动图片用于遮挡自动登陆
    
    [[dataBase share]CreateAllTables]; //创建数据库
    
    
    if ([[USER_DEFAULT objectForKey:@"data"] integerValue]==0) {
        [self insertData];
    }
    
    [self dataBase];       //缓存默认的深圳市
    
    [self getAllOpenCity];  //缓存城市列表
    
    [self requestSkills];  //缓存技能列表
    
    [self setupMap];    //定位
    
    if ([[USER_DEFAULT objectForKey:@"first"] integerValue]==0) {
        [self setupguide];
    }else{
    [self setupRootView];
    }
    
    //分享初始化
    [ShareSDK registerApp:@"a8e3c1e1faa7" activePlatforms:@[@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformSubTypeQQFriend:
            {
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            }
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
            {
                [appInfo SSDKSetupQQByAppId:@"1104783970" appKey:@"P2826m1w7xJ8u9nE" authType:SSDKAuthTypeBoth];
            }
                break;
            case SSDKPlatformSubTypeQQFriend:
            {
                [appInfo SSDKSetupQQByAppId:@"1104783970" appKey:@"P2826m1w7xJ8u9nE" authType:SSDKAuthTypeBoth];
                
            }
                break;
            case SSDKPlatformTypeWechat:{
                
                [appInfo SSDKSetupWeChatByAppId:@"wxaa561e93e30b45ca" appSecret:@"c6a34cd399535499f8f77fb15cbe62d5"];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}



-(void)setupServicePhone{

    if ([USER_DEFAULT objectForKey:@"servicePhone"]==nil) {
        [USER_DEFAULT setObject:@"13924834100" forKey:@"servicePhone"];
        [USER_DEFAULT synchronize];
    }
    
}


-(void)checkUpServicePhone{

    NSString*urlString=[self interfaceFromString:interface_checkServicePhone];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSString*phone=[dict objectForKey:@"msg"];
            if (phone) {
                if ([phone isEqualToString:[USER_DEFAULT objectForKey:@"servicePhone"]]==NO) {
                    [USER_DEFAULT setObject:phone forKey:@"servicePhone"];
                    [USER_DEFAULT synchronize];
                }
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [USER_DEFAULT setObject:@"13510024086" forKey:@"servicePhone"];
    }];
}


//设置广告界面
-(void)setupADImage{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    niceView.image = [UIImage imageNamed:@"Default.png"];
    niceView.tag=10;
    //添加到场景
    [delegate.window addSubview:niceView];
    //放到最顶层;
    [delegate.window bringSubviewToFront:niceView];
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:delegate.window cache:YES];
    [UIView setAnimationDelegate:self];
    //這裡還可以設置回調函數;
    //    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone)];
    niceView.alpha = 0.99;
    [UIView commitAnimations];
    
}


/*
 
 移除启动图片
 
 **/
-(void)startupAnimationDone{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIImageView*imageview=(id)[delegate.window viewWithTag:10];
    [imageview removeFromSuperview];
}


/**
 *  已开通省市
 */
-(void)getAllOpenCity{
    
    NSString*urlString=[self interfaceFromString: interface_provinceList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[dataBase share]deleAllCityInformation];
            NSArray*array=[dict objectForKey:@"entities"];
            [[dataBase share]inserProvinceCity:array Pid:30000];
            }
        
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


//技能筛选项请求
-(void)requestSkills
{
    NSString*urlString=[self interfaceFromString:interface_skill];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSMutableArray*array =[self arrayFromJosn:responseObject Type:@"servicerSkills" Model:@"skillModel"];
        [[dataBase share]deleAllSkillInformation];
        for (NSInteger i=0; i<array.count; i++) {
            skillModel*model=array[i];
            [[dataBase share]addSkillModel:model];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


-(void)dataBase
{
    AreaModel*model=[[dataBase share]findWithCity:@"深圳市"];
    if (model.indexLetter==nil) {
        NSString*urlString=[self interfaceFromString: interface_cityList];
        [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*Array=[[NSArray alloc]initWithArray:[dict objectForKey:@"entities"]];
            [[dataBase share]addCityToDataBase:Array Pid:200000];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            //                NSLog(@"%@",error);
        }];
    }
}


/**
 *  定位
 */
-(void)setupMap{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _mapManager=[[CLLocationManager alloc]init];
    _geocoder=[[CLGeocoder alloc]init];
    _mapManager.delegate=self;
    _mapManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
    _mapManager.distanceFilter=distance;
    //启动跟踪定位
    [_mapManager startUpdatingLocation];
    if (![CLLocationManager locationServicesEnabled]) {
        [delegate.window makeToast:@"定位尚未打开，请检查设置" duration:1 position:@"center"];
    }else{
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if ([[UIDevice currentDevice].systemVersion integerValue]>=8) {
                
                [_mapManager requestWhenInUseAuthorization];
            }
            
        }else{
            _mapManager.delegate=self;
            _mapManager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance=10.0;//十米定位一次
            _mapManager.distanceFilter=distance;
            //启动跟踪定位
            [_mapManager startUpdatingLocation];
        }
    }
}


#pragma mark - CoreLocation 代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error||placemarks.count==0) {
            
         }else//编码成功
        {
            //显示最前面的地标信息
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            delegate.city=[firstPlacemark.addressDictionary objectForKey:@"City"];
                //经纬度
            NSString*Country=[firstPlacemark.addressDictionary objectForKey:@"Country"];
            NSString*city=[firstPlacemark.addressDictionary objectForKey:@"City"];
            if (city&&Country) {
                delegate.province=[[[firstPlacemark.addressDictionary objectForKey:@"FormattedAddressLines"][0] componentsSeparatedByString:Country][1] componentsSeparatedByString:city][0];
                
            }
            delegate.detailAdress=[firstPlacemark.addressDictionary objectForKey:@"SubLocality"];
            
                if (delegate.detailAdress) {
                if (delegate.cityChangeBlock) {
                    delegate.cityChangeBlock(delegate.city);
                }
             }

          }
    }];
    [_mapManager stopUpdatingLocation];
}


/**
 *  设置相应的界面
 */
-(void)setupViewcontroller{

    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"first"] integerValue]==1) {
        _pushDictory=[self.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
       
        [self setupRootView];
        
    }else{
        
        [self setupguide];
    }
    
}

-(void)setupRootView
{
    
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*username=[users objectForKey:@"username"];
    NSString*password;
    if (username) {
        password =[users objectForKey:username];  
    }
    if (username&&password) {
        
        [[loginManager share] loginWithUsername:username Password:password LoginComplite:^(id object) {
            NSDictionary*dict=(NSDictionary*)object;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                
            }else{
                
                [self setupLoginView];
                
            }

            }];
           
    }else if([[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]){
    
        [[loginManager share]loginWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] OpenId:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] Type:[[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] integerValue]];
        [loginManager share].block=^(id object){
            NSDictionary*dict=(NSDictionary*)object;
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                               
            }else{
            
                [self setupLoginView];

            }
        };
    
    }else{
        
        [USER_DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:loginStatus];
        [USER_DEFAULT synchronize];
        [self setupLoginView];
    }
}

/**
 *  将当前界面设置为登陆界面
 */
-(void)setupLoginView{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    LoginViewController*lvc=[[LoginViewController alloc]init];
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    nc.navigationBar.barStyle=1;
    nc.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    delegate.window.rootViewController=nc;
}


/**
 *  设置引导页
 */
-(void)setupguide{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    guideViewController*gvc=[[guideViewController alloc]init];
    delegate.window.rootViewController=gvc;
    [user setObject:@"1" forKey:@"first"];
    [user synchronize];
    
}



-(void)insertData{
    
    NSString*urlString=[self interfaceFromString:interface_allAddress];
    
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*array=[dict objectForKey:@"entities"];
            [[dataBase share]inserCity:array];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}



@end
