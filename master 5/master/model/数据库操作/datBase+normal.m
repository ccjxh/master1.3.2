//
//  datBase+normal.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "datBase+normal.h"
#import"FMDatabaseAdditions.h"
@implementation dataBase (normal)

-(void)createTable
{
    if ([[USER_DEFAULT objectForKey:@"data"] integerValue]==0) {
        [self createCityTable];
        [self createskillTable];
        [self CreateInformation];
        [self createPayTable];
        [self createprimaryInfor];
        [self createProvices];
        [self creatAllAdressTable];
        [self addAttribueOnInformation];
    }
    
}

#pragma mark-城市信息表单
//创建表单
-(void)createCityTable
{

    NSString*sql=@"Create table if not exists city(name varchar(255) , cityID integer primary key , flag varchar(255) ,pid integer)";
    [self inDatabase:^(FMDatabase *db) {
        
        [db open];
        BOOL isSuccess= [db executeUpdate:sql];
        [db close];
        
    }];
}


//插入以及跟城市信息
-(void)inserCity:(NSArray*)array Pid:(NSInteger)pid{
    
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db open];
        [db beginTransaction];
        for (NSInteger i=0; i<array.count; i++) {
        NSString*sql=@"insert into city(name , cityID , flag , pid) values(?,?,?,?)";
        NSString*updateSql=@"update city set name = ?,flag = ? , pid = ? where  cityID = ?";
        NSDictionary*inforDic=array[i];
        AreaModel*cityModel=[[AreaModel alloc]init];
        NSDictionary*tempDict=[inforDic objectForKey:@"dataCatalog"];
        [cityModel setValuesForKeysWithDictionary:tempDict];
            
     BOOL isSuccess=[db executeUpdate:sql,cityModel.name,[self getnumberFromString:[NSString stringWithFormat:@"%lu",cityModel.id]],cityModel.indexLetter,[self getnumberFromString:[NSString stringWithFormat:@"%lu",pid]]];
            
        if (!isSuccess) {
        isSuccess= [db executeUpdate:updateSql,cityModel.name,cityModel.indexLetter,[self getnumberFromString:[NSString stringWithFormat:@"%lu",pid]],[self getnumberFromString:[NSString stringWithFormat:@"%lu",cityModel.id]]];
            }
            
        }
            [db commit];
            [db close];
        
    }];
}


//根据城市名字查找城市信息
-(AreaModel*)findWithCity:(NSString*)cityName
{
    __block AreaModel*model1=[[AreaModel alloc]init];
    NSString*sql=@"select * from city where name = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs=[db executeQuery:sql,cityName];
        while ([rs next]) {
            model1.name=cityName;
            model1.id=[rs intForColumn:@"cityID"];
            model1.indexLetter=[rs stringForColumn:@"flag"];
            
        }
        
    }];
    
    return model1;
}



//根据城市id查找改城市下的地区
-(NSMutableArray*)findWithPid:(NSInteger)pid
{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from city where pid = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql,[self getnumberFromString:[NSString stringWithFormat:@"%u",pid]]];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.indexLetter=[rs stringForColumn:@"flag"];
            [Array addObject:model];
        }
        
    }];
    
    return Array;
}




-(NSMutableArray*)findWith
{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from city  group by flag";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.indexLetter=[rs stringForColumn:@"flag"];
            [Array addObject:model];
        }
        
    }];
    
    return Array;
}


//根据首字母查找城市信息
-(NSMutableArray*)findWithFlag:(NSString *)flag
{
    
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from city where flag = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql,flag];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.indexLetter=[rs stringForColumn:@"flag"];
            [Array addObject:model];
        }
        
    }];
    
    return Array;
    
}


//删除所有城市信息
-(BOOL)deleAllCityInformation{
    __block BOOL isResult;
    NSString*sql=@"delete from city";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isResult= [db executeUpdate:sql];
        [db close];
    }];
    return isResult;
    
}


-(NSNumber*)getnumberFromString:(NSString*)integer
{
    
    NSNumberFormatter*formate=[[NSNumberFormatter alloc]init];
    return [formate numberFromString:integer];
    
}

-(NSString*)getStringFromNumber:(NSNumber*)number
{
    NSNumberFormatter*format=[[NSNumberFormatter alloc]init];
    return [format stringFromNumber:number];
}




#pragma mark-技能相关缓存
//创建技能表单
-(void)createskillTable
{
    
    NSString*sql=@"Create table if not exists skill(name varchar(255) , ID integer primary key )";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        BOOL isSuccess= [db executeUpdate:sql];
//        NSLog(@"技能表单创建%@",isSuccess?@"成功":@"失败");
        [db close];
    }];
}

//插入技能信息
-(BOOL)inserSkillModel:(skillModel*)model
{
    __block BOOL isSuccess;
    NSString*sql=@"insert into skill(name , ID ) values(?,?)";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isSuccess=[db executeUpdate:sql,model.name,[self getnumberFromString:[NSString stringWithFormat:@"%lu",model.id]]];
        [db close];
//        NSLog(@"数据插入%@",isSuccess?@"成功":@"失败");
    }];
    return isSuccess;
}


//跟新技能信息
-(BOOL)updateWintSkillModel:(skillModel*)model
{
    __block BOOL isSuccess;
    NSString*sql=@"update skill set name = ? where ID = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
    isSuccess=[db executeUpdate:sql,model.name,[self getnumberFromString:[NSString stringWithFormat:@"%lu",model.id]]];
        [db close];
    }];
    
    return isSuccess;
    
}


//查找所有技能信息
-(NSMutableArray*)findAllSkill
{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from skill  ";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql];
        while ([rs next]) {
            skillModel*model=[[skillModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"ID"] ;
            [Array addObject:model];
        }
        
    }];
    
    return Array;
}



//删除所有技能信息
-(BOOL)deleAllSkillInformation{
    __block BOOL isResult;
    NSString*sql=@"DELETE  from  skill ";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isResult=[db executeUpdate:sql];
        [db close];
    }];
    
    return isResult;

}

/**
 *  增加年龄和职位认证字段
 */
-(void)addAttribueOnInformation{

    [self inDatabase:^(FMDatabase *db) {
      [db open];
        if (![db columnExists:@"age" inTableWithName:@"information"]) {
          BOOL isResult=  [db executeUpdate:@"ALTER TABLE information add COLUMN age integer"];
        }
        if (![db columnExists:@"skillOpinion" inTableWithName:@"information"]) {
         BOOL isResult=   [db executeUpdate:@"ALTER TABLE information add COLUMN skillOpinion text"];
        }
        [db close];
    }];
}

#pragma mark-个人信息缓存
-(BOOL)CreateInformation
{
    __block BOOL isresult;
     NSString*sql=@"Create table if not exists information(realName text , icon text,personal integer,skill integer,company integer,id integer primary key,personalState integer,companyState integer,skillState integer,certifyType integer,qq, text,iconId integer,gendar text,mobile text,weChat text ,adress text)";
    //  ,  ,skill integer,id integer
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       isresult= [db executeUpdate:sql];
        [db close];
    }];
    return isresult;
}


-(void)updateInformationWithTable:(NSString*)table Id:(NSInteger)ID Attribute:(NSString *)attribute Content:(NSString *)content{

    __block BOOL isResult;
    NSString*sql=[NSString stringWithFormat:@"update %@ set %@ = ? where id = %lu",table,attribute,(long)ID];
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       isResult=[db executeUpdate:sql,content];
        if (isResult) {
            NSLog(@"%@更新成功",attribute);

        }else{
        NSLog(@"%@更新失败",attribute);
        }
        [db close];
    }];

}



-(BOOL)inserInformationWithPeopleInfoematin:(PersonalDetailModel*)model{
    __block BOOL isResult;
    
    NSString*sql=@"insert into information(realName,icon,personal,skill,company,id,personalState,companyState,skillState,certifyType,qq,iconId,gendar,mobile,weChat,adress,age,skillOpinion) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        [self inDatabase:^(FMDatabase *db) {
            [db open];
            NSString*personalState,*companyState,*skillState,*certifyType,*qq,*iconId,*gendar,*mobile,*weChat,*adress,*skillOpinion,*age;
            if ([model.certification objectForKey:@"personalState"]) {
                personalState=[model.certification objectForKey:@"personalState"];
            }else{
                personalState=@"0";
            }
            
            if ([model.certification objectForKey:@"skillOpinion"]) {
                skillOpinion=[model.certification objectForKey:@"skillOpinion"];
            }else{
            
                 skillOpinion=@"";
            }
            
            if (model.age) {
                age=model.age;
            }else{
            
                age=@"0";
            }
            
            if ([model.certification objectForKey:@"companyState"]) {
                companyState=[model.certification objectForKey:@"companyState"];
            }else{
                companyState=@"0";
            }
            if ([model.certification objectForKey:@"skillState"]) {
                skillState=[model.certification objectForKey:@"skillState"];
            }else{
                skillState=@"0";
            }
            if ([model.certification objectForKey:@"certifyType"]) {
                certifyType=[model.certification objectForKey:@"certifyType"];
            }else{
                certifyType=@"0";
            }
            if (model.qq) {
                qq=model.qq;
            }else{
            
                qq=@"";
            }
            if (model.weChat) {
                weChat=model.weChat;
            }else{
                weChat=@"";
            }
            if (model.gendar) {
                gendar=model.gendar;
            }else{
            gendar=@"";
            }
            if ([[model.nativeProvince objectForKey:@"name"] length]!=0) {
                adress=[NSString stringWithFormat:@"%@-%@-%@",[model.nativeProvince objectForKey:@"name"],[model.nativeCity objectForKey:@"name"],[model.nativeRegion objectForKey:@"name"]];
            }else{
                adress=@"";
            }
            if (model.mobile) {
                mobile=model.mobile;
            }else{
            
                mobile=@"";
            }
            if (model.iconId) {
                iconId=[NSString stringWithFormat:@"%u",model.iconId];
            }else{
                iconId=@"";
            
            }
            
       isResult=[db executeUpdate:sql,model.realName,model.icon,[model.certification objectForKey:@"personal"] ,[model.certification objectForKey:@"skill"],[model.certification objectForKey:@"company"],model.id,personalState,companyState,skillState,certifyType,qq,iconId,gendar,mobile,weChat,adress,age,skillOpinion];
            NSLog(@"个人信息插入%@",isResult?@"成功":@"失败");
        if (isResult==YES) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
            
            
            }
            
    }];
    
    return isResult;
}

-(PersonalDetailModel*)findPersonInformation:(NSInteger)ID{
    PersonalDetailModel*model=[[PersonalDetailModel alloc]init];
    NSString*sql=@"select * from information where id = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*set=[db executeQuery:sql,[NSString stringWithFormat:@"%lu",ID]];
        while ([set next]) {
            model.realName=[set stringForColumn:@"realName"];
            model.icon=[set stringForColumn:@"icon"];
            model.id=[NSNumber numberWithInteger:ID];
            model.personal=[set intForColumn:@"personal"];
            model.company=[set intForColumn:@"company"];
            model.skill=[set intForColumn:@"skill"];
            model.personalState=[set intForColumn:@"personalState"];
            model.companyState=[set intForColumn:@"companyState"];
            model.skillState=[set intForColumn:@"skillState"];
            model.certifyType=[set intForColumn:@"certifyType"];
            model.qq=[set stringForColumn:@"qq"];
            model.iconId=[NSString stringWithFormat:@"%u",[set intForColumn:@"iconId"]];
            model.mobile=[set stringForColumn:@"mobile"];
            model.weChat=[set stringForColumn:@"weChat"];
            model.adress=[set stringForColumn:@"adress"];
            model.gendar=[set stringForColumn:@"gendar"];
            model.age=[set stringForColumn:@"age"];
            model.skillOpinion=[set stringForColumn:@"skillOpinion"];
          }
        
        [db close];
    }];
    return model;
}

-(BOOL)updateInformationWithWithPeopleInfoematin:(PersonalDetailModel*)model{
    
    __block BOOL isResult;
    NSString*personalState,*companyState,*skillState,*certifyType,*skillOpinion,*age;
    if ([model.certification objectForKey:@"personalState"]) {
        personalState=[model.certification objectForKey:@"personalState"];
    }else{
        personalState=@"0";
    }
    
    if ([model.certification objectForKey:@"companyState"]) {
        companyState=[model.certification objectForKey:@"companyState"];
    }else{
        companyState=@"0";
    }
    if ([model.certification objectForKey:@"skillState"]) {
        skillState=[model.certification objectForKey:@"skillState"];
    }else{
        skillState=@"0";
    }
    if ([model.certification objectForKey:@"certifyType"]) {
        certifyType=[model.certification objectForKey:@"certifyType"];
    }else{
        certifyType=@"0";
    }
    
    if ([model.certification objectForKey:@"skillOpinion"]) {
        skillOpinion=[model.certification objectForKey:@"skillOpinion"];
    }else{
        
        skillOpinion=@"";
    }
    if (model.age) {
        age=model.age;
    }else{
        
        age=@"0";
    }
    
       NSString*sql=@"update information SET  realName = ?,icon = ? , personal = ? ,skill = ?,company = ?,personalState = ?,companyState = ?,skillState = ?,certifyType= ?, age=?, skillOpinion=?  where id = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       isResult=[db executeUpdate:sql,model.realName,model.icon,[model.certification objectForKey:@"personal"] ,[model.certification objectForKey:@"skill"],[model.certification objectForKey:@"company"],personalState,companyState,skillState,certifyType,age,skillOpinion,model.id];
         NSLog(@"个人信息数据更新%@",isResult?@"成功":@"失败");
        [db close];
    }];
    return isResult;
}




-(BOOL)deleInformationWithID:(NSInteger)ID{
    __block BOOL isResult;
    NSString*sql=@"DELETE FROM information WHERE id = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
   isResult=[db executeUpdate:sql,[NSString stringWithFormat:@"%lu",ID]];
        [db close];
    }];
    return isResult;
}


#pragma mark-支付集合缓存
-(BOOL)createPayTable{
    NSString*sql=@"Create table if not exists pay(id integer primary key, name text ,remark text )";
    __block BOOL isResult;
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       BOOL isResult= [db executeUpdate:sql];
//        NSLog(@"支付集合表单创建%@",isResult?@"成功":@"失败");
        [db close];
    }];
    return NO;

}


//插入支付数据
-(BOOL)insertPayFromTable:(payModel*)model{
    __block BOOL isResult;
    NSString*sql=@"insert into pay(id , name,remark) values(?,?,?)";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       isResult= [db executeUpdate:sql,[self getnumberFromString:[NSString stringWithFormat:@"%lu",model.id]],model.name,model.remark];
    }];
    
    
    return isResult;
}


//跟新支付数据
-(BOOL)updatePayFromTable:(payModel*)model{
    NSString*sql=@"update pay set name = ?,remark = ? where id = ?";
    __block BOOL isResult;
    [self inDatabase:^(FMDatabase *db) {
        [db open];
       isResult= [db executeUpdate:sql,model.name,model.remark,[self getnumberFromString:[NSString stringWithFormat:@"%lu",model.id]]];
    }];
    return isResult;

}

//查找全部支付
-(NSMutableArray*)findAllPay{
    __block NSMutableArray*array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from pay ";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
      FMResultSet*Set=[db executeQuery:sql];
        while ([Set next]) {
            payModel*model=[[payModel alloc]init];
            model.name=[Set stringForColumn:@"name"];
            model.id=[Set intForColumn:@"id"];
            model.remark=[Set stringForColumn:@"remark"];
            [array addObject:model];
        }
        
    }];
    return array;
}

//删除支付
-(BOOL)deleAllPay{
    __block BOOL isResult;
    NSString*sql=@"DELETE FROM pay";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
     isResult=[db executeUpdate:sql];
        [db close];
    }];
    return isResult;
}


#pragma mark-重要信息更改
/**
 *  创建表单
 *
 *
 */
#pragma mark-登陆的基本信息
-(BOOL)createprimaryInfor{
        
    NSString*sql=@"Create table if not exists primaryInfor(id integer primary key, userPost integer ,integrity integer,integral integer,renewDay integer,totalIntegral integer,nextDayIntegral integer,todayIntegral integer,signState integer,inviteCode text)";
    
    //,detailAdress text,renewDay integer,totalIntegral integer,nextDayIntegral integer,todayIntegral integer,signState integer
    __block BOOL isResult;
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isResult= [db executeUpdate:sql];
        [db close];
        
    }];
    return isResult;
    
}

/**
 *  插入个人基本信息
 */

-(BOOL)insertprimaryInfor:(loginModel*)model {
    __block BOOL isResult;
    NSString*sql=@"insert into primaryInfor(id , userPost  ,integrity ,integral,renewDay ,totalIntegral ,nextDayIntegral,todayIntegral,signState,inviteCode) values(?,?,?,?,?,?,?,?,?,?)";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
    isResult= [db executeUpdate:sql,[NSString stringWithFormat:@"%d",model.id],model.userPost,model.integrity,model.integral,[model.signInfo objectForKey:@"renewDay"],[model.signInfo objectForKey:@"totalIntegral"],[model.signInfo objectForKey:@"nextDayIntegral"],[model.signInfo objectForKey:@"todayIntegral"],[model.signInfo objectForKey:@"signState"],model.inviteCode];
        
    }];
    
    return isResult;
}

-(BOOL)updatePrimaryInforWithModel:(loginModel*)model{

    NSString*sql=@"update primaryInfor set userPost = ?,integrity = ?,integral=?,renewDay=?,totalIntegral=?,nextDayIntegral=?,todayIntegral=?, signState=?";
    __block BOOL isResult;
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isResult= [db executeUpdate:sql,model.userPost,model.integrity,model.integral,model.renewDay,model.totalIntegral,model.nextDayIntegral,model.todayIntegral,model.signState];
        if (isResult) {
         NSLog(@"签到信息更新成功");
        }
        
    }];
    return isResult;



}

-(loginModel*)findLoginInformationWithID:(NSInteger)ID{
    __block loginModel*model;
        [self inDatabase:^(FMDatabase *db) {
    NSString*sql=@"select * from primaryInfor where id = ?";
    model=[[loginModel alloc]init];
        [db open];
        FMResultSet*set=[db executeQuery:sql,[NSNumber numberWithInteger:ID]];
        while ([set next]) {
            model.id=ID;
            model.userPost=[set stringForColumn:@"userPost"];
            model.integral=[set stringForColumn:@"integral"];
            model.integrity=[set stringForColumn:@"integrity"];
            model.inviteCode=[set stringForColumn:@"inviteCode"];
            model.mobile=[set stringForColumn:@"mobile"];
            model.signState=[set stringForColumn:@"signState"];
            model.renewDay=[set stringForColumn:@"renewDay"];
            model.todayIntegral=[set stringForColumn:@"todayIntegral"];
            model.totalIntegral=[set stringForColumn:@"totalIntegral"];
            model.nextDayIntegral=[set stringForColumn:@"nextDayIntegral"];
        }
            [db close];
        }];
    
    return model;
       
}


/**
 *  删除个人签到信息
 *
 *  @return 返回是否成功
 */
-(BOOL)delePrimaty{


    __block BOOL isResult;
    NSString*sql=@"DELETE FROM primaryInfor";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        isResult=[db executeUpdate:sql];
        [db close];
    }];
    return isResult;

}


#pragma mark-建立索引





#pragma mark-省份表单
/**
 *  储存全国省份列表
 */
-(void)createProvices{
    
    NSString*sql=@"Create table if not exists provices(name varchar(255) , cityID integer primary key , flag varchar(255) ,pid integer)";
    
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        BOOL isSuccess= [db executeUpdate:sql];
    }];
    
}

/**
 *  插入全国省份
 *
 *  @param db       省份数组
 *  @param rollback pid
 *
 *  @return void
 */
-(void)inserProvinceCity:(NSArray*)array Pid:(NSInteger)pid{
    
    [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db open];
        [db beginTransaction];
        for (NSInteger i=0; i<array.count; i++) {
            NSString*sql=@"insert into provices(name , cityID , flag , pid) values(?,?,?,?)";
            NSString*updateSql=@"update provices set name = ?,flag = ? , pid = ? where  cityID = ?";
            NSDictionary*inforDic=array[i];
            AreaModel*cityModel=[[AreaModel alloc]init];
            NSDictionary*tempDict=[inforDic objectForKey:@"dataCatalog"];
            [cityModel setValuesForKeysWithDictionary:tempDict];
            
            BOOL isSuccess=[db executeUpdate:sql,cityModel.name,[self getnumberFromString:[NSString stringWithFormat:@"%u",cityModel.id]],cityModel.indexLetter,[self getnumberFromString:[NSString stringWithFormat:@"%u",pid]]];
            if (!isSuccess) {
                isSuccess= [db executeUpdate:updateSql,cityModel.name,cityModel.indexLetter,[self getnumberFromString:[NSString stringWithFormat:@"%u",pid]],[self getnumberFromString:[NSString stringWithFormat:@"%u",cityModel.id]]];
                
            }
            
        }
        [db commit];
        [db close];
        
    }];
}


/**
 *  查找所有的省
 *
 *  @return 省数组
 */
-(NSMutableArray*)findAllProvinces
{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from provices";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.indexLetter=[rs stringForColumn:@"flag"];
            [Array addObject:model];
        }
        
        [db open];
    }];
    
    return Array;
}



/**
 *  //根据首字母查找城市信息
 *
 *  @param NSMutableArray flag  为城市的首字母
 *
 *  @return
 */
-(NSMutableArray*)findProviceWithFlag:(NSString *)flag
{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from provices where flag = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql,flag];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.indexLetter=[rs stringForColumn:@"flag"];
            [Array addObject:model];
        }
        
    }];
    
    return Array;
}


-(BOOL)creatAllAdressTable{

    __block BOOL isResult;
     NSString*sql=@"Create table if not exists allAdress(name text , cityID integer primary key , ucode varchar(255) , pid integer)";
   [self inDatabase:^(FMDatabase *db) {
       [db open];
      isResult=[db executeUpdate:sql];
       NSLog(@"表单创建%@",isResult?@"成功":@"失败");
       [db close];
   }];

    return isResult;

}



-(void)inserCity:(NSArray *)array{
    
    
    [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db open];
        [db beginTransaction];
        NSString*sql=@"insert into allAdress(name , cityID , ucode , pid) values(?,?,?,?)";
        for (NSInteger i=0; i<array.count; i++) {
            AreaModel*model=[[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:[array[i] objectForKey:@"TreeDTO"]];
            [db executeUpdate:sql,model.text,[NSString stringWithFormat:@"%lu",model.id],model.ucode,@"500000"];
            for (NSInteger j=0; j<model.children.count; j++) {
                AreaModel*childModel=[[AreaModel alloc]init];
                [childModel setValuesForKeysWithDictionary:model.children[j]];
                BOOL isSuccess=  [db executeUpdate:sql,childModel.text,[NSString stringWithFormat:@"%lu",childModel.id],childModel.ucode,[NSString stringWithFormat:@"%lu",model.id]];
                for (NSInteger z=0; z<childModel.children.count; z++) {
                    AreaModel*thirdModel=[[AreaModel alloc]init];
                    [thirdModel setValuesForKeysWithDictionary:childModel.children[z]];
                    BOOL isSuccess=  [db executeUpdate:sql,thirdModel.text,[NSString stringWithFormat:@"%lu",thirdModel.id],thirdModel.ucode,[NSString stringWithFormat:@"%lu",childModel.id]];
                    
                    if (isSuccess) {
                        [USER_DEFAULT setObject:@"1" forKey:@"data"];
                        [USER_DEFAULT synchronize];
                    }
                    
                }
            }
        }
        [db commit];
        [db close];
        
    }];
    
}


-(NSMutableArray*)findCityInformationWithPid:(NSInteger)pid{

    __block NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSString*sql=@"select * from allAdress where pid = ?";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql,[NSString stringWithFormat:@"%lu",pid]];
        while ([rs next]) {
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.ucode=[rs stringForColumn:@"ucode"];
            model.pid=[rs intForColumn:@"pid"];
            [Array addObject:model];
        }
        
    [db close];
 
    }];
    
    return Array;
}

-(NSMutableArray*)findcityWithKeyWord:(NSString*)keyWord{
   __block NSMutableArray*valueArray=[[NSMutableArray alloc]init];
    NSString*sql=[NSString stringWithFormat:@"select * from allAdress where name like '%@%%'",keyWord];
       [self inDatabase:^(FMDatabase *db) {
        [db open];
       FMResultSet*rs= [db executeQuery:sql];
        while ([rs next]) {
            
            AreaModel*model=[[AreaModel alloc]init];
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.ucode=[rs stringForColumn:@"ucode"];
            model.pid=[rs intForColumn:@"pid"];
            [valueArray addObject:model];
        }
        [db close];
        
    }];
   
    return valueArray;

}

-(AreaModel*)findCityWithCityId:(NSInteger)Id{

    __block AreaModel*model=[[AreaModel alloc]init];
    NSString*sql=@"select * from allAdress";
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet*rs= [db executeQuery:sql];
        while ([rs next]) {
            if ([rs intForColumn:@"cityID"]==Id) {
            model.name=[rs stringForColumn:@"name"];
            model.id=[rs intForColumn:@"cityID"];
            model.pid=[rs intForColumn:@"pid"];
            model.ucode=[rs stringForColumn:@"ucode"];
            }
        }
    }];

    return model;

}


@end
