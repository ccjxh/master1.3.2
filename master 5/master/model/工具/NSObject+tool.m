//
//  NSObject+tool.m
//  master
//
//  Created by jin on 15/8/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+tool.h"
#import "PhotoBroswerVC.h"
#include <sys/signal.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "sys/sysctl.h"
#import <sys/utsname.h>


@implementation NSObject (tool)

//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView  SkillArray:(NSMutableArray*)skillArray{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    UIView*view=(id)[cell.contentView viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 10, 100, 20)];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.font=[UIFont systemFontOfSize:16];
    nameLabel.text=@"专业技能";
    [view addSubview:nameLabel];
    if (skillArray.count==0) {
        cell.detailTextLabel.textColor=[UIColor blackColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        return cell;
    }
    cell.detailTextLabel.text=@"";
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    NSInteger orginX = 0;
    for (NSInteger i=0; i<skillArray.count; i++) {
        skillModel*model=skillArray[i];
        NSInteger width=(SCREEN_WIDTH-110-30)/3;
        if (i!=0&&i%3==0) {
            orginX=0;
        }
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12, 10+i/3*30,model.name.length*12+5, 25)];
        if (i/3!=0) {
            label.frame=CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12, 10+i/3*30,model.name.length*12+5, 25);
        }
        
        if (label.frame.origin.x<100) {
            CGFloat tempWidth=SCREEN_WIDTH-orginX-30-5;
            label.frame=CGRectMake(100, label.frame.origin.y,tempWidth-100-5, label.frame.size.height);
        }
        orginX+=model.name.length*12+10;
        width=label.frame.origin.x+label.frame.size.width+5;
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.numberOfLines=0;
        label.layer.cornerRadius=4;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor blackColor];
        label.layer.borderColor=[UIColor blackColor].CGColor;
        label.layer.borderWidth=1;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [view addSubview:label];
        [cell.contentView addSubview:view];
    }
    return cell;
}



//计算技能的高度
-(CGFloat)accountSkillWithAllSkill:(NSMutableArray*)skillArray{
    
    if (skillArray.count<=2) {
        
        return 40;
    }
    else
    {
        if (skillArray.count%3==0) {
            
            return skillArray.count/3*30+10;
            
        }
        else
        {
            return (skillArray.count/3+1)*30+10;
        }
    }
}



//计算图片高度
-(CGFloat)accountPictureFromArray:(NSArray*)pictureArray{
    
    
    CGFloat height;
    NSInteger width=(SCREEN_WIDTH-40)/3;
    
    
    if (pictureArray.count==0) {
        return 30;
    }
    if (pictureArray.count%3==0) {
        height=pictureArray.count/3*width;
    }
    else{
        height=(pictureArray.count/3+1)*width;
    }
    
    
    
    return height;
    
}


//网络图片图片展示
-(void)displayPhotosWithIndex:(NSInteger)index Tilte:(NSString*)title describe:(NSString*)describe ShowViewcontroller:(UIViewController*)vc UrlSarray:(NSMutableArray*)UrlArray ImageView:(UIImageView*)imageview{
    
    [PhotoBroswerVC show:vc type:3 index:index photoModelBlock:^NSArray *{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:Array.count];
    for (NSUInteger i = 0; i< UrlArray.count; i++) {
        
        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = i + 1;
        pbModel.title =title;
        pbModel.desc = describe;
        pbModel.image_HD_U = UrlArray[i];

        pbModel.sourceImageView = imageview;
        [modelsM addObject:pbModel];
    }
    
        return modelsM;
    }];
}

//环信注册
-(void)regiloginWithUsername:(NSString *)name Password:(NSString *)password{

//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:name password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
//        NSDictionary*dict;
//        if (!error) {
//            dict=@{@"rspCode":@"200"};
//        }else{
//        
//           dict=@{@"rspCode":@"530"};
//        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"huanxinReLogin" object:nil userInfo:dict];
//    } onQueue:nil];

}


//环信登陆
-(void)HXLoginWithUsername:(NSString*)username Password:(NSString*)password{
    
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
//        NSDictionary*dict;
//        if (!error && loginInfo) {
//           
//            NSDictionary*dict=@{@"rspCode":@"200"};
//        }else{
//            NSDictionary*dict=@{@"rspCode":@"530"};
//
//        }
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"huanxinLogin" object:nil userInfo:dict];
//    } onQueue:nil];
    
}


- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    
    
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(13*15+25, CGFLOAT_MAX);
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
    
}



-(void)updateOpinionWithDict:(NSDictionary *)dict UrlString:(NSString *)urlString{

    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];

}


/**
 *  返回手机的机型
 *
 *  @return 手机的机型
 */
-(NSString*)getMyPhoneType{

    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    else if ([platform isEqualToString:@"iPhone1,2"]) platform= @"iPhone 3G ";
    else if ([platform isEqualToString:@"iPhone3,1"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) platform= @"iPhone 4";
    else  if ([platform isEqualToString:@"iPhone4,1"]) platform= @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) platform= @"iPhone 5";
    else  if ([platform isEqualToString:@"iPhone5,2"]) platform= @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) platform= @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone5,4"]) platform= @"iPhone 5c";
    else  if ([platform isEqualToString:@"iPhone6,1"]) platform= @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone6,2"]) platform= @"iPhone 5s";
    else  if ([platform isEqualToString:@"iPhone7,1"]) platform= @"iPhone 6 Plus ";
    else  if ([platform isEqualToString:@"iPhone7,2"]) platform= @"iPhone 6";
    else if ([platform isEqualToString:@"iPad2,5"])   platform= @"iPad Mini 1G (A1432)";
    else if ([platform isEqualToString:@"iPad2,6"])   platform= @"iPad Mini 1G (A1454)";
    else if ([platform isEqualToString:@"iPad2,7"])   platform= @"iPad Mini 1G (A1455)";
    else if ([platform isEqualToString:@"iPad3,1"])   platform= @"iPad 3 (A1416)";
    else if ([platform isEqualToString:@"iPad3,2"])   platform= @"iPad 3 (A1403)";
    else  if ([platform isEqualToString:@"iPad3,3"])   platform= @"iPad 3 (A1430)";
    else  if ([platform isEqualToString:@"iPad3,4"])   platform= @"iPad 4 (A1458)";
    else  if ([platform isEqualToString:@"iPad3,5"])   platform= @"iPad 4 (A1459)";
    else   if ([platform isEqualToString:@"iPad3,6"])   platform= @"iPad 4 (A1460)";
    else  if ([platform isEqualToString:@"iPad4,1"])   platform= @"iPad Air (A1474)";
    else  if ([platform isEqualToString:@"iPad4,2"])   platform= @"iPad Air (A1475)";
    else  if ([platform isEqualToString:@"iPad4,3"])   platform= @"iPad Air (A1476)";
    else  if ([platform isEqualToString:@"iPad4,4"])   platform= @"iPad Mini 2G (A1489)";
    else if ([platform isEqualToString:@"iPad4,5"])   platform= @"iPad Mini 2G (A1490)";
    else if ([platform isEqualToString:@"iPad4,6"])   platform= @"iPad Mini 2G (A1491)";
    
    else  if ([platform isEqualToString:@"i386"])      platform= @"iPhone Simulator";
    else if ([platform isEqualToString:@"x86_64"])    platform= @"iPhone Simulator";
    
    else{
        
        return [NSString stringWithFormat:@"%@的%@",userPhoneName,@"iphone6s/iphone6sPlus"];
    }
    return [NSString stringWithFormat:@"%@的%@",userPhoneName,platform];

}


/**
 *  拨打客服电话
 */
-(void)callServicePeople{

    NSString*phone=[USER_DEFAULT objectForKey:@"servicePhone"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


/**
 *  重新组装model的certaion
 *
 *  @param model PersonalDetailModel对象
 *
 *  @return <#return value description#>
 */
-(NSMutableDictionary*)getDictoryWithModel:(PersonalDetailModel*)model{

    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.personal] forKey:@"personal"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.personalState] forKey:@"personalState"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.company] forKey:@"company"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.companyState] forKey:@"companyState"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.skill] forKey:@"skill"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.skillOpinion] forKey:@"skillOpinion"];
    [dict setObject:[NSString stringWithFormat:@"%lu",model.skillState] forKey:@"skillState"];
    return dict;

}


/**
 *  根据年月日获得年龄
 *
 *  @param date 出生年月日
 *
 *  @return 年龄
 */
-(NSString*)getAgeFromDate:(NSString*)date{
    NSArray*birthdayArray=[date componentsSeparatedByString:@"-"];
    NSString*second=birthdayArray[1];
    NSString*first=birthdayArray[0];
    NSString*third=birthdayArray[2];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    NSString*Date=[formatter stringFromDate:[NSDate date]];
    NSArray*currentTimeArray=[Date componentsSeparatedByString:@"-"];
    NSString*currentFirst=currentTimeArray[0];
    NSString*currentSecond=currentTimeArray[1];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:nowDate];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    NSString*age;
    if (day>[third intValue]) {
        age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
        if (year==[first intValue]) {
            age=@"0岁";
        }
    }
    
    else  if ([currentSecond integerValue]>[second integerValue]){
        age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
        if (year==[first intValue]) {
            age=@"0岁";
        }
    }else{
        age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]+1];
        if (year==[first intValue]) {
            age=@"0岁";
            
        }
    }
    return age;
}


@end
