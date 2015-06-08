//
//  CopyFollowersViewController.m
//  i-boardpro
//
//  Created by Sumit Ghosh on 12/05/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "CopyFollowersViewController.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "LMDropdownView.h"
#import "LMDefaultMenuItemCell.h"

@interface CopyFollowersViewController ()
{
    UITextField * searchBox;
    NSString * userId;
    NSMutableArray * profilePic,* username,* useridArr;
    UITableView * menuTable;
    NSArray * menuItmes;
    UIButton * menuList;
}
@end

@implementation CopyFollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    windowSize=[UIScreen mainScreen].bounds.size;
    profilePic =[[NSMutableArray alloc]init];
    useridArr=[[NSMutableArray alloc]init];
    username=[[NSMutableArray alloc]init];
    menuItmes=[NSArray arrayWithObjects:@"follows",@"followed-by" ,nil];
    choice=@"follows";
    [self createUI];
    // Do any additional setup after loading the view.
}


-(void)createUI{
    if (copyFollowerTbl) {
        copyFollowerTbl=nil;
    }
    
    copyFollowerTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
    copyFollowerTbl.delegate=self;
    copyFollowerTbl.dataSource=self;
    [self.view addSubview:copyFollowerTbl];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 100)];
    headerView.backgroundColor=[UIColor colorWithRed:(CGFloat)50/255 green:(CGFloat)50/255 blue:(CGFloat)50/255 alpha:(CGFloat)1];
    copyFollowerTbl.tableHeaderView=headerView;
    
    searchBox=[[UITextField alloc]initWithFrame:CGRectMake(10, 20, windowSize.width/2+50, 30)];
    searchBox.delegate=self;
    searchBox.layer.borderColor=[UIColor blackColor].CGColor;
    searchBox.layer.borderWidth=0.5f;
    searchBox.layer.cornerRadius=5;
    searchBox.clipsToBounds=YES;
    searchBox.placeholder=@" Enter username.";
    searchBox.font=[UIFont systemFontOfSize:12];
    searchBox.textColor=[UIColor blackColor];
    searchBox.backgroundColor=[UIColor whiteColor];
    searchBox.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:searchBox];
    
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(windowSize.width/2+70, 20, (windowSize.width-(windowSize.width/2+80)), 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    
    
     menuList=[UIButton buttonWithType:UIButtonTypeCustom];
    menuList.frame=CGRectMake(windowSize.width/2-70, 60, (windowSize.width-(windowSize.width/2+50)), 30);
    [menuList setTitle:@"follows" forState:UIControlStateNormal];
     [menuList setBackgroundImage:[UIImage imageNamed:@"blank_btn.png"] forState:UIControlStateNormal];
    [menuList addTarget:self action:@selector(menuListView:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:menuList];
}

#pragma mark- textField delgate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark- create Table for menu 

-(void)menuListView:(UIButton * )sender{
    if (menuTable) {
        [menuTable removeFromSuperview];
        menuTable=nil;
    }
    menuTable =[[UITableView alloc]init];
    [menuTable setFrame:CGRectMake(0, 55, self.view.bounds.size.width, menuItmes.count * 50)];
    menuTable.delegate=self;
    menuTable.dataSource=self;
    menuTable.scrollEnabled=NO;
    //[menuTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[menuTable reloadData];
    
    // Init dropdown view
    if (self.dropdownView)
    {
        self.dropdownView=nil;
    }
        self.dropdownView = [[LMDropdownView alloc] init];
        self.dropdownView.menuContentView = menuTable;
        self.dropdownView.menuBackgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self.dropdownView hide];
    }
    else
    {
       
        [self.dropdownView showInView:self.view withFrame:self.view.bounds];
    }

}

#pragma mark- table delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==copyFollowerTbl) {
        //if (username.count<1) {
         //   return 0;
        //}
        return  username.count;
    }
    if (tableView==menuTable) {
         return menuItmes.count;
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==copyFollowerTbl) {
        
    
    TableCustomCell * cell=(TableCustomCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Follow"];
    if (!cell) {
        cell=[[TableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Follow"];
        
        
        
    }
        if (follow) {
            [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
            [cell.add_minusButton addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
             [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"follow_btn.png"] forState:UIControlStateNormal];
            [cell.add_minusButton addTarget:self action:@selector(followActions:) forControlEvents:UIControlEventTouchUpInside];
        }
    cell.add_minusButton.tag=indexPath.row;
    cell.likesBtn.hidden=YES;
    cell.commentBtn.hidden=YES;
    cell.userNameDesc.text=[username objectAtIndex:indexPath.row];
    
    [cell.userImage sd_setImageWithURL:[profilePic objectAtIndex:indexPath.row]];
         return cell;
    }
    else{

       
        TableCustomCell * cell=(TableCustomCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"copy"];
        if (!cell) {
            cell=[[TableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"copy"];
        }
       
        cell.listCopy.text = [menuItmes objectAtIndex:indexPath.row];
         return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==copyFollowerTbl) {
        return  45;
    }
    else{
        return 0;
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=50;
    if (tableView==copyFollowerTbl) {
        height=100;
        return height;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==menuTable) {
        [menuList setTitle:[menuItmes objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        choice=[NSString stringWithFormat:@"%@",[menuItmes objectAtIndex:indexPath.row]];
    }
}

-(void)searchBtnAction:(UIButton *)sender{
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=%@",searchBox.text,client_id]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableDictionary * metaDict=[dictResponse objectForKey:@"meta"];
    if ([[metaDict objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        
        NSArray * values=[dictResponse objectForKey:@"data"];
        if (values.count<1) {
            return;
        }
        NSMutableDictionary * dict=[values objectAtIndex:0];
            userId=[dict objectForKey:@"id"];
        [self FindFollowers:userId];
    }
    
}

-(void)FindFollowers:(NSString *)userid{
    NSURLResponse * urlResponse;
    NSError * error;
    
    [profilePic removeAllObjects];
    [username removeAllObjects];
    [useridArr removeAllObjects];
    
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/%@?access_token=%@",userid,choice,accessToken]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];        
        [username addObject:[dict objectForKey:@"username"]];
        [useridArr addObject:[dict objectForKey:@"id"]];
        [profilePic addObject:[dict objectForKey:@"profile_picture"]];
    }
    if ([choice isEqualToString:@"follows"]) {
        follow=YES;
    }
    else{
        follow=NO;
    }
    [copyFollowerTbl reloadData];

}


#pragma mark- unfollow action

// call unfollow api here
-(void)unfollowAction:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * userIDStr=[useridArr  objectAtIndex:tag];
    
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship",userIDStr]];
    
    
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [request setHTTPMethod:@"POST"];
    NSString * body=[NSString stringWithFormat:@"access_token=%@&action=unfollow",accessToken];
    
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    [copyFollowerTbl reloadData];
    
}
#pragma mark- follow action

-(void)followActions:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * userIDStr=[useridArr  objectAtIndex:tag];
    
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship",userIDStr]];
    
    
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [request setHTTPMethod:@"POST"];
    NSString * body=[NSString stringWithFormat:@"access_token=%@&action=follow",accessToken];
    
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@" response of follow %@",response);
    
   
    [copyFollowerTbl reloadData];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
