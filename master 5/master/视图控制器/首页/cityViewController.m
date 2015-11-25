//
//  cityViewController.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "cityViewController.h"
#import "headCollectionReusableView.h"
#import "SecondCityViewController.h"
#import "findAddNewWorkViewController.h"
#import "thirdResignViewController.h"
@interface cityViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSArray*AZArray;
@end

@implementation cityViewController
{

    NSMutableArray*_currentArray;//装着已开通城市的数组
    NSMutableArray*_searchArray;
    UISearchBar*_search;
    UISearchDisplayController*_searchDisplay;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"省选择";
    [self initData];
    [self customNavigation];
//    [self initUI];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initUI{

    if (!_searchArray) {
        _searchArray=[[NSMutableArray alloc]init];
    }
    _search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _search.delegate=self;
    self.tableview.tableHeaderView=_search;
    for (UIView *subview in _search.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;  
        }
    }
    _search.placeholder = @"请输入的要查询的地区名字";
    _searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:_search contentsController:self];
    _searchDisplay.searchResultsDataSource = self;
    _searchDisplay.searchResultsDelegate = self;

    

}
    

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [_searchArray removeAllObjects];
    NSMutableArray*Array=[[dataBase share]findcityWithKeyWord:_search.text];
    [_searchArray addObject:Array];

}
    

-(void)initData
{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    _AZArray=@[@"定位",@"",@"A"];

    NSArray*temparray=@[@"定位"];
    NSArray*allCount=@[@"全国"];
    [_dataArray addObject:temparray];
    if (self.type==0||self.type==1) {
        [_dataArray addObject:allCount];
    }
    for (NSInteger i=2; i<_AZArray.count; i++) {
        NSMutableArray*array1=[[dataBase share]findCityInformationWithPid:500000];
        [_dataArray addObject:array1];
    }
    [_tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if (tableView==self.tableview) {
        return _dataArray.count;
 
    }else{
    
        
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.tableview) {
        return [_dataArray[section] count];
        
    }else{
        
        if (_searchArray.count==0) {
            return 0;
        }
        return [_searchArray[0] count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }
    if (tableView== self.tableview) {
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
   
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    AreaModel*model=_dataArray[indexPath.section][indexPath.row];
    
    if (indexPath.section==0) {
        
        if (delegate.city) {
            if (delegate.detailAdress) {
                cell.textLabel.text=[NSString stringWithFormat:@"%@-%@-%@",delegate.province,delegate.city,delegate.detailAdress];
                
            }
        }else{
            
            cell.textLabel.text=@"定位失败(请检查定位是否开启)";
            
        }
        return cell;
    }else if (indexPath.section==1) {
        if (self.type==0||self.type==1) {
        cell.textLabel.text=@"全国";
        return cell;
        }else{
            cell.textLabel.text=model.name;
        }
    }else{
    cell.textLabel.text=model.name;
    }
    return cell;
    }
    AreaModel*model=_searchArray[indexPath.section][indexPath.row];
    cell.textLabel.text=model.name;
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.type==2) {
        if (section>0) {
            return _AZArray[section+1];
        }
    }
    return _AZArray[section];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==2) {
        return 0;
    }
    return 30;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tableview) {
        
    if (indexPath.section==0) {
        //定位
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if (delegate.province&&delegate.city&&delegate.detailAdress) {
         
            AreaModel*provinceModel=[[dataBase share]findcityWithKeyWord:delegate.province][0];
            AreaModel*cityModel=[[dataBase share]findcityWithKeyWord:delegate.city][0];
            AreaModel*resiModel=[[dataBase share]findcityWithKeyWord:delegate.detailAdress][0];
            NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:provinceModel,cityModel,resiModel, nil];
            if (self.type==0||self.type==1) {
                NSDictionary*dict=@{@"array":array};
                    NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter]postNotification:notication];
                    [self popWithnimation:self.navigationController];
                    return;
            }else{
            
                AreaModel*provinceModel=[[dataBase share]findcityWithKeyWord:delegate.province][0];
                AreaModel*cityModel=[[dataBase share]findcityWithKeyWord:delegate.city][0];
                 AreaModel*regionModel=[[dataBase share]findcityWithKeyWord:delegate.detailAdress][0];
                NSDictionary*dict=@{@"model":regionModel,@"type":@"thirdLocation",@"province":provinceModel,@"city":cityModel};
                NSNotification*notication=[[NSNotification alloc]initWithName:@"workPlace" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter]postNotification:notication];
                for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
                    if ([viewcontroller isKindOfClass:[findAddNewWorkViewController class]]==YES) {
                        
                        [self.navigationController popToViewController:viewcontroller animated:YES];
                    }
                    
                }
            }
            return;
        }
    }else{
    
        if (self.type==0||self.type==1) {
            NSMutableArray*array=[[NSMutableArray alloc]init];
            
            if (indexPath.section==1) {
                AreaModel*model=[[AreaModel alloc]init];
                model.name=@"全国";
                model.id=0;
                [array addObject:model];
                NSDictionary*dict=@{@"array":array};
                NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter]postNotification:notication];
                [self popWithnimation:self.navigationController];
                return;
            }
        }
    AreaModel*model=_dataArray[indexPath.section][indexPath.row];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObject:model];
    SecondCityViewController*svc=[[SecondCityViewController alloc]initWithNibName:@"SecondCityViewController" bundle:nil];
    svc.province=model;
    svc.addressArray=array;
    svc.count=self.count;
    svc.type=self.type;
        
        
    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
       }
    }else{
    
        if (self.type==0||self.type==1) {
        AreaModel*model=_searchArray[indexPath.section][indexPath.row];
        if (model.pid==500000) {
            NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model, nil];
            NSDictionary*dict=@{@"array":array};
            NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notication];
            [self popWithnimation:self.navigationController];
            return;
        }else{
           AreaModel*secondModel=[[dataBase share]findCityWithCityId:model.pid];
            if (secondModel.pid==500000) {
                NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model,secondModel, nil];
                NSDictionary*dict=@{@"array":array};
                NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter]postNotification:notication];
                [self popWithnimation:self.navigationController];
                return;
 
            }else{
                AreaModel*thirdModel=[[dataBase share]findCityWithCityId:secondModel.pid];
                NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model,secondModel,thirdModel,nil];
                NSDictionary*dict=@{@"array":array};
                NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter]postNotification:notication];
                [self popWithnimation:self.navigationController];
                return;
                }
            
            }
        }else{
        
            
            AreaModel*model=_searchArray[indexPath.section][indexPath.row];
            if (model.pid==500000) {
                SecondCityViewController*svc=[[SecondCityViewController alloc]initWithNibName:@"SecondCityViewController" bundle:nil];
                svc.type=self.type;
                svc.province=model;
                [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
                
                return;
            }else{
                AreaModel*secondModel=[[dataBase share]findCityWithCityId:model.pid];
                if (secondModel.pid==500000) {
                    thirdResignViewController*tvc=[[thirdResignViewController alloc]initWithNibName:@"thirdResignViewController" bundle:nil];
                    tvc.type=self.type;
                    tvc.province=secondModel;
                    tvc.cityModel=model;
                    [self pushWinthAnimation:self.navigationController Viewcontroller:tvc];
                    
                    return;
                    
                }else{
                    AreaModel*thirdModel=[[dataBase share]findCityWithCityId:secondModel.id];
    
                NSDictionary*dict=@{@"model":thirdModel,@"type":@"thirdLocation",@"province":thirdModel,@"city":secondModel};
                    NSNotification*notication=[[NSNotification alloc]initWithName:@"workPlace" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter]postNotification:notication];
                    for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
                        if ([viewcontroller isKindOfClass:[findAddNewWorkViewController class]]==YES) {
                            
                            [self.navigationController popToViewController:viewcontroller animated:YES];
                        }
                        
                    }

                    [self popWithnimation:self.navigationController];
                    return;
                }
                
            }

        }
    
    }
}


-(void)customNavigation{

//    if (self.type==1) {
//    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [button addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font=[UIFont systemFontOfSize:16];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
//    }
}

-(void)certain{
    
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    NSString*str;
    for (NSInteger i=0; i<_currentArray.count; i++) {
        AreaModel*model=_currentArray[i];
        if (model.isselect==YES) {
            if (!str) {
                str=[NSString stringWithFormat:@"%lu",model.id];
            }else{
                str=[NSString stringWithFormat:@"%@,%lu",str,model.id];
            }
        }
    }
}


-(void)selected:(UIButton*)button{

    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}

-(NSInteger)accountCity{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    if (array.count%3==0) {
        return array.count/3*40+20;
    }else{
    
        return (array.count/3+1)*40+20;
    }
}

-(void)select:(UIButton*)button{
    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    AreaModel*model=array[indexPath.row];
    if (self.type==1){
        if (indexPath.section==1) {
            AreaModel*model=_currentArray[indexPath.row];
            if (model.isselect==NO) {
                model.isselect=YES;
            }else{
                
                model.isselect=NO;
            }
            [_currentArray replaceObjectAtIndex:indexPath.row withObject:model];
            [collectionView reloadData];;
            return;
        }
    }
    
    if (self.TBlock) {
        if (self.type==0) {
        if (indexPath.section==0) {
            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if (delegate.city) {
            AreaModel*model1=[[dataBase share]findWithCity:delegate.city];
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
            return;
        }else{
        
            [self.view makeToast:@"定位中" duration:1 position:@"center"];
            return;
            
            }
        }
        
        if (self.type==0) {
            self.TBlock(model);
            [self popWithnimation:self.navigationController];
            
            }
        }
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    headCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        NSArray*array=@[@"    GPS定位",@"    已开通的城市"];
    UILabel*label=(id)[collectionView viewWithTag:30+indexPath.section];
    if (label) {
        [label removeFromSuperview];
    }
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    label.backgroundColor=[UIColor whiteColor];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:13];
    label.text=array[indexPath.section];
    [view addSubview:label];
        return view;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(90, 35);
    }
    if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-60)/3, 35);
    }
    return CGSizeZero;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={SCREEN_WIDTH,35};
    return size;
}





@end
