//
//  myCaseViewController.m
//  master
//
//  Created by jin on 15/7/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myCaseViewController.h"
#import "projectCaseAddViewController.h"
#import "projectCastDetailViewController.h"
#import "MyCaseSelectedViewController.h"
#import "StarCaseViewController.h"
#define LABEL_TAG 200
@interface myCaseViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
@property(nonatomic)NSInteger currentIndex;//删除选中的索引；
@end

@implementation myCaseViewController
{

    NSDictionary*valueDict;
    BOOL isShowDelegate;
    NSInteger _totalPage;
}


-(void)dealloc{
[[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateUI" object:nil];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isRefersh=YES;
    [self requestProjectCase];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _rightStstus=@"管理";
    _currentPage=1;
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestProjectCase];
    };
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self customNV];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.backgroundColor=[UIColor whiteColor];
    label.tag=LABEL_TAG;
    self.tableview.tableFooterView=label;
     self.title=@"工程案例";
    [self setupHeaderWithTableview:self.tableview];
    [self setupFooter:self.tableview];
    [self CreateFlow];
    [self noData];
    [self netIll];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refershUI) name:@"updateUI" object:nil];
    
}


-(void)refershUI{

    self.isRefersh=YES;
    [self requestProjectCase];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求工程案例
-(void) requestProjectCase
{
    
    self.noDataView.hidden=YES;
    self.netIll.hidden=YES;
    [self flowShow];
    if (!_deleArray) {
        _deleArray=[[NSMutableArray alloc]init];
    }
    [_deleArray removeAllObjects];
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    NSString *urlString;
    if (self.type==1) {
        urlString=[self interfaceFromString:interface_projectCase];
        valueDict=@{@"pageNo":[NSString stringWithFormat:@"%d",_currentPage],@"pageSize":@"10"};
    }else{
        
        urlString = [self interfaceFromString:interface_projectCase];
        valueDict=@{@"pageNo":[NSString stringWithFormat:@"%d",_currentPage],@"pageSize":@"10"};
    }
    [[httpManager share]POST:urlString parameters:valueDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        _totalPage=[[objDic objectForKey:@"totalPage"] integerValue];
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        if (self.isRefersh==YES) {
            [_dataArray removeAllObjects];
            UILabel*label=(id)[self.view viewWithTag:LABEL_TAG];
            label.text=@"";
        }
        NSArray*array=[objDic objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*dict=array[i];
            peojectCaseModel*model=[[peojectCaseModel alloc]init];
            [model setValuesForKeysWithDictionary:[dict objectForKey:@"masterProjectCase"]];
            [_dataArray addObject:model];
        }
        
        if (_dataArray.count==0) {
            self.noDataView.hidden=NO;
        }else{
            self.noDataView.hidden=YES;

        }
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            [self.tableview reloadData];
             self.isRefersh=NO;
            [self flowHide];
        });
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        self.isRefersh=NO;
        [self flowHide];
        self.netIll.hidden=NO;
    }];
    
}



-(void)footerRefresh{
    
    if (_currentPage<_totalPage) {
        self.isRefersh=YES;
        [self requestProjectCase];
    }else{
        UILabel*label=(id)[self.view viewWithTag:LABEL_TAG];
        label.text=@"没有更多了";
        label.textColor=[UIColor lightGrayColor];
        label.font=[UIFont systemFontOfSize:15];
        label.textAlignment=NSTextAlignmentCenter;
        self.tableview.tableFooterView=label;
        [self.refreshFooter endRefreshing];
    }
    
}



-(void)customNV{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"新增" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}


-(void)add{
    
    MyCaseSelectedViewController*mvc=[[MyCaseSelectedViewController alloc]initWithNibName:@"MyCaseSelectedViewController" bundle:nil];
    [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
    
}


-(void)add:(UIButton*)button{
    
       if ([button.titleLabel.text isEqualToString:@"管理"]==YES) {
        UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"工程案例管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除案例",@"添加新案例", nil];
        [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    }
    if ([button.titleLabel.text isEqualToString:@"删除"]==YES) {
        if (_deleArray.count!=0) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除提示" message:@"是否删除这个工程案例" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }else{
            
            _rightStstus=@"管理";
            [self customNV];
            return;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        starCaseModel*model=self.dataArray[_currentIndex];
        if (model.applyFlg==1) {
            [self.view makeToast:@"审核中的案例不能删除" duration:1 position:@"center"];
            return;
        }
        
        //确认删除
        NSString*urlString=[self interfaceFromString:interface_deleProjectCase];
        NSDictionary*dict;
        dict=@{@"id":[NSString stringWithFormat:@"%lu",model.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*inforDic=(NSDictionary*)responseObject;
            if ([[inforDic objectForKey:@"rspCode"] integerValue]==200) {
                [_dataArray removeObject:model];
                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:_currentIndex inSection:0];
                [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
            }else{
                [self.view makeToast:[inforDic objectForKey:@"msg"] duration:1 position:@"center"];
                
            }
 
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
            _rightStstus=@"管理";
            _isshow=NO;
            [self customNV];
        }];

    }else if (buttonIndex==1){
        
        NSIndexPath*path=[NSIndexPath indexPathForRow:_currentIndex inSection:0];
        NSArray*Array=@[path];
        [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];

        
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    starTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        UINib*nib=[UINib nibWithNibName:@"starTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:nib forCellReuseIdentifier:@"Cell"];

    }
    cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    starCaseModel*model=_dataArray[indexPath.row];
    switch (model.applyFlg) {
        case 1:
        {
            cell.statusLabel.text=@"审核中";
            cell.statusLabel.textColor=[UIColor orangeColor];
        }
            break;
            
            case 2:
        {
            cell.statusLabel.text=@"已通过";
            cell.statusLabel.textColor=[UIColor greenColor];
            
        }
            break;
            case 3 :
        {
            cell.statusLabel.text=@"不审核";
            cell.statusLabel.textColor=[UIColor redColor];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=0;
    cell.model=model;
    [cell reloadData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count!=0) {
    starCaseModel*model=_dataArray[indexPath.row];
    if (model.type==1) {
        return NO;
        }
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除提示" message:@"是否删除这个工程案例" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        _currentIndex=indexPath.row;
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    _currentIndex=indexPath.row;
    peojectCaseModel*model=_dataArray[indexPath.row];
    if (model.type==1) {
        //明星工程
        StarCaseViewController*svc=[[StarCaseViewController alloc]initWithNibName:@"StarCaseViewController" bundle:nil];
        svc.model=model;
        if (model.applyFlg==1||model.applyFlg==2) {
            svc.Editable=NO;
        }else{
            svc.Editable=YES;
        }
        
        [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
        cell.selectionStyle=0;
        return;
        
    }else{
    
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backButtonItem;
        if (model.applyFlg==3||model.applyFlg==1) {
        projectCaseAddViewController*pvc=[[projectCaseAddViewController alloc]init];
        pvc.caseType=2;
        pvc.model=model;
        [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
            cell.selectionStyle=0;
        }else{
        
            projectCastDetailViewController*pvc=[[projectCastDetailViewController alloc]initWithNibName:@"projectCastDetailViewController" bundle:nil];
            pvc.id=model.id;
            pvc.isStars=YES;
            pvc.model=model;
            pvc.name=model.caseName;
            pvc.introlduce=model.introduce;
            [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
            cell.selectionStyle=0;
        }
        return;
    }
    
}

@end
