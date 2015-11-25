//
//  CollectViewController.m
//  master
//
//  Created by xuting on 15/6/4.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "CollectViewController.h"
#import "listRootTableViewCell.h"
#import "peoplr.h"
#import "requestModel.h"
#import "PeoDetailViewController.h"
@interface CollectViewController ()
{
    UITableView *collectTbView; //创建收藏table
    NSMutableArray *collectArr; //保存收藏列表数据
    
}
@end

@implementation CollectViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"收藏";
    if (self.index==1) {
        self.title=@"报名列表";
        
    }
    collectArr = [NSMutableArray array];
    collectTbView = [[UITableView alloc] init];
    collectTbView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>8) {
        collectTbView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }else{
    collectTbView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    collectTbView.delegate = self;
    collectTbView.dataSource = self;
    collectTbView.separatorStyle=0;
    [collectTbView registerNib:[UINib nibWithNibName:@"listRootTableViewCell" bundle:nil] forCellReuseIdentifier:@"listRootTableViewCell"];
    [self.view addSubview:collectTbView];
    [self CreateFlow];
    [self requestCollectList];
    
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestCollectList];
    };
    [self setupHeaderWithTableview:collectTbView];
    [self setupFooter:collectTbView];
    [self noData];
    [self net];
}


#pragma mark - 请求收藏列表
- (void) requestCollectList
{
    [self flowShow];
    self.netIll.hidden=YES;
    self.noDataView.hidden=YES;
    
    if (self.index==1) {
        NSString*urlString=[self interfaceFromString:interface_getapplyPerson];
        NSDictionary*dict=@{@"projectId":[NSString stringWithFormat:@"%lu",self.projectId],@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
        
        
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                if (self.isRefersh==YES) {
                    [collectArr removeAllObjects];
                    self.isRefersh=NO;
                }
                NSArray*array=[dict objectForKey:@"entities"];
                for ( NSInteger i=0; i<array.count; i++) {
                    NSDictionary*infordict=array[i];
                    peoplr *model = [[peoplr alloc]init];
                    [model setValuesForKeysWithDictionary:[infordict objectForKey:@"user"]];
                    [collectArr addObject:model];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.weakRefreshHeader endRefreshing];
                    [self.refreshFooter endRefreshing];
                    [collectTbView reloadData];
                    self.isRefersh=NO;
                    [self flowHide];
                });
                
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
 
        }];
        [collectTbView reloadData];
        return;
    }
    NSString *urlString = [self interfaceFromString:interface_collectMasterList];
    [[httpManager share] GET:[NSString stringWithFormat:@"%@?pageSize=%d&pageNo=%d",urlString,10,_currentPage] parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        NSDictionary *objDic = (NSDictionary *)responseObject;
        NSArray *array = [objDic objectForKey:@"entities"];
        if (array.count==0) {
            self.noDataView.hidden=NO;
        }else{
        
            self.noDataView.hidden=YES;
        }
        for (NSInteger i=0; i<array.count; i++)
        {
            NSDictionary *tempDict = array[i];
            peoplr *model = [[peoplr alloc]init];
            [model setValuesForKeysWithDictionary:[tempDict objectForKey:@"user"]];
            [collectArr addObject:model];
        }
        
        if (collectArr.count==0) {
            collectTbView.separatorStyle=0;
        }else{
            
            collectTbView.separatorStyle=1;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            [collectTbView reloadData];
            self.isRefersh=NO;
            [self flowHide];
        });
     
       } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
           self.netIll.hidden=YES;
           [self flowHide];
    }];
}


-(void)footerRefresh{
    _currentPage++;
    self.isRefersh=YES;
    [self requestCollectList];
    [collectTbView reloadData];
    
}


#pragma mark - UITableviewdelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return collectArr.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    listRootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[listRootTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"Cell"];
    }

    cell.selectionStyle=0;
    peoplr*model=collectArr[indexPath.row];
//    cell.typeLabel.text=self.type;
    cell.selectionStyle=0;
    cell.model=model;
     cell.typeLabel.text=self.type;
     if (model.userPost==3) {
         cell.typeLabel.text=@"工长";
         cell.type=2;
         
     }else if (model.userPost==2){
         cell.typeLabel.text=@"师傅";
         cell.type=3;
     }
    
    [cell reloadData];
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    peoplr *model = collectArr[indexPath.row];
    PeoDetailViewController*pvc=[[PeoDetailViewController alloc]initWithCityId:0 Peoplr:model FavoriteFlag:model.favoriteFlag IsCollect:YES];
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;

}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString*urlString=[self interfaceFromString:interface_delegateCollection];
        peoplr *model =collectArr[indexPath.row];
        NSDictionary*dict=@{@"ids":[NSString stringWithFormat:@"%d",model.id]};
        
        [self flowShow];
       
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self flowHide];
                [self.view makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
                    [self requestCollectList];
                    
                }];
                
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
           
                       [self flowHide];
            [self.view makeToast:@"当前网络故障，请稍后重试" duration:1 position:@"center"];

        }];
    }
}


@end
