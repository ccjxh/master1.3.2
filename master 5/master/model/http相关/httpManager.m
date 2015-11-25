//
//  httpManager.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "httpManager.h"
#import "OpenUDID.h"
#import "appInitManager.h"
//请求方法
typedef enum : NSUInteger {
    GET = 0,
    POST,
    PUT,
    DELETE
} RequestMethod;


@implementation httpManager
+(httpManager*)share
{
    static dispatch_once_t once;
    static httpManager*manager;
    dispatch_once(&once, ^{
        if (!manager) {
            manager=[[self alloc]initWithBaseURL:[NSURL URLWithString:changeURL]];
//            manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    }
    });

    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    if (self=[super initWithBaseURL:url]) {
        self.requestSerializer.timeoutInterval=timeout;
    }
    return self;

}


-(AFHTTPRequestOperation*)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure
{
    
    
    __block AFHTTPRequestOperation*finallyOperation;
    BOOL isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
//    if (!isReachable) {
//        NSError *error = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
//        failure(operation,error);
//    }
//    else
//    {
        //网络通畅
        NSError *error1 = [NSError errorWithDomain:@"请求参数不正确" code:500 userInfo:nil];
    finallyOperation =[super GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation1, id responseObject) {
           NSDictionary*dict=(NSDictionary*)responseObject;
           NSInteger rspcode=[[dict objectForKey:@"rspCode"] integerValue];
           switch (rspcode) {
               case 500:
                   success(operation1,responseObject);
                   break;
               case 200:
                   success(operation1,responseObject);
                   break;
               case 530:
               {
               
                   [self reLoginWithOldURL:URLString oldParameters:nil oldMethod:0 success:success failure:failure];
//
               }
                   break;
               case 503:
               {
                   AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                   if (delegate.isLogin==YES) {
                       delegate.isLogin=NO;
                   }
                   
               }
                   break;
               default:
                   success(operation1,responseObject);
                   break;
           }
        
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
           NSError *error2 = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
           failure(operation,error2);
           
       }];
    
    
//    }
    return finallyOperation;

}

-(AFHTTPRequestOperation*)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure
{
             __block AFHTTPRequestOperation*operation;
    
             operation=[super POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary*dict= (NSDictionary*)responseObject;
                 
                 
                 
            switch ([[dict objectForKey:@"rspCode"]integerValue]) {
                case 500:
                    success(operation,responseObject);
                    break;
                case 200:
                    success(operation,responseObject);
                    break;
                    case 530:
                {
                    
                    [self reLoginWithOldURL:URLString oldParameters:parameters oldMethod:1 success:success failure:failure];
                }
                    break;
                    case 503:
                {
                    [[appInitManager share]setupLoginView];
                
                }
                    break;
                default:
                    success(operation,responseObject);
                    break;
            }
                        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSError *error2 = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
            failure(operation,error2);
            
        }];
        
        
//    }
    return operation;

}


/*!
 * @discussion 重新登录 调用登录接口,30分钟过期
 */
- (AFHTTPRequestOperation *)reLoginWithOldURL:(NSString *)URLString
                                oldParameters:(id)parameters
                                    oldMethod:(RequestMethod)method
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    __block AFHTTPRequestOperation *operationFinal = nil;
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*username=[users objectForKey:@"username"];
    NSString*password;
    if (username) {
        password=[users objectForKey:username];
    }
    if (username&&password) {
        NSString* openUDID = [OpenUDID value];
        NSString*phoneType;
        if ([self getMyPhoneType]) {
            phoneType=[self getMyPhoneType];
        }else{
            
            phoneType=@"unKnowIphone";
        }
        
        NSDictionary*dict=@{@"mobile":username,@"password":password,@"machineType":phoneType,@"machineCode":openUDID};
        NSString*temp=[self interfaceFromString:interface_login];
    //用户登录
    operationFinal = [self POST:temp parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //重新请求之前失败的接口
        
        switch (method) {
            case GET:
                operationFinal = [weakSelf GET:URLString parameters:parameters success:success failure:failure];
                break;
            case POST:
            {
                operationFinal = [weakSelf POST:URLString parameters:parameters success:success failure:failure];
                
            }
                
                break;
            default:
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == 500){
            //            DDLogError(@"密码被修改或者账户关闭");
            //发送错误通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReLoginErrorNotification object:nil];
        }
    
        }];
    }else{
    
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
        NSString* openUDID = [OpenUDID value];
        [dict setObject:openUDID forKey:@"machineCode"];
        if ([self getMyPhoneType]) {
            [dict setObject:[self getMyPhoneType] forKey:@"machineType"];
        }else{
            
            [dict setObject:@"unknowIphone" forKey:@"machineType"];
        }
        NSString*accessToken=[users objectForKey:@"token"];
        NSString*openId=[users objectForKey:@"uid"];
        NSInteger thirdType=[[users objectForKey:@"loginType"] integerValue];
       [dict setObject:accessToken forKey:@"accessToken"];
       [dict setObject:openId forKey:@"openId"];
       [dict setObject:[NSString stringWithFormat:@"%lu",thirdType] forKey:@"thirdType"];
        NSString*temp=[self interfaceFromString:interface_qqLogin];
        //用户登录
        
        
        
        
        operationFinal = [self POST:temp parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //重新请求之前失败的接口
            NSDictionary*dict=(NSDictionary*)responseObject;
            
            
            
            switch (method) {
                case GET:
                    operationFinal = [weakSelf GET:URLString parameters:parameters success:success failure:failure];
                    break;
                case POST:
                {
                    operationFinal = [weakSelf POST:URLString parameters:parameters success:success failure:failure];
                    
                }
                    
                    break;
                default:
                    break;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(error.code == 500){
                //            DDLogError(@"密码被修改或者账户关闭");
                //发送错误通知
                //            [[NSNotificationCenter defaultCenter] postNotificationName:kReLoginErrorNotification object:nil];
                }
            
            }];
    
        }
    return operationFinal;
}

@end
