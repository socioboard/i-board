//
//  deatilsOfSearchInstaViewControllerIboard.m
//  i-boardpro
//
//  Created by Sumit Ghosh on 12/05/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "CopyFollowersViewControllerIboard.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "LMDropdownView.h"
#import "LMDefaultMenuItemCell.h"
#import "SingletonClassIboard.h"
#import "HelperClassIboard.h"

@interface CopyFollowersViewControllerIboard ()
{
    UITextField * searchBox;
    NSString * userId;
    NSMutableArray * profilePic,* username,* useridArr;
    UITableView * menuTable;
    NSArray * menuItmes;
    UIButton * menuList;
    UILabel * noLable;
    UILabel * noInternetConnnection;

}
@end

@implementation CopyFollowersViewControllerIboard

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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {

    
    if (username.count<1) {
        if (noLable) {
            [noLable removeFromSuperview];
            noLable=nil;
        }
         noLable =[[UILabel alloc]initWithFrame:CGRectMake(20, windowSize.height/2+40, windowSize.width-40, 50)];
        noLable.text =@"No followers";
        noLable.textAlignment =  NSTextAlignmentCenter;
        [self.view insertSubview:noLable aboveSubview:copyFollowerTbl];
        
        [UIView animateWithDuration:0.3 animations:^{
            noLable.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            noLable.transform = CGAffineTransformIdentity;
        }];
    }
    
    if (copyFollowerTbl) {
        copyFollowerTbl=nil;
    }
    
    copyFollowerTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height-55)];
    copyFollowerTbl.delegate=self;
    copyFollowerTbl.dataSource=self;
    [self.view addSubview:copyFollowerTbl];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, windowSize.width, 100)];
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
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"iboard-search_btn.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    
    
     menuList=[UIButton buttonWithType:UIButtonTypeCustom];
    menuList.frame=CGRectMake(windowSize.width/2-70, 60, (windowSize.width-(windowSize.width/2+50)), 30);
    [menuList setTitle:@"follows" forState:UIControlStateNormal];
     [menuList setBackgroundImage:[UIImage imageNamed:@"iboard-blank_btn.png"] forState:UIControlStateNormal];
    [menuList addTarget:self action:@selector(menuListView:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:menuList];
    
    self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
   self.bannerView.frame =  CGRectMake((windowSize.width - self.bannerView.frame.size.width)/2, windowSize.height-105, self.bannerView.frame.size.width, 50);
    self.bannerView.adUnitID = adMobId_iboard;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    
    GADRequest *request = [GADRequest request];
   // request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
    self.bannerView.hidden = NO;
    [self.view addSubview:self.bannerView];
     
    }
     else{
        
         if (noInternetConnnection) {
             [noInternetConnnection removeFromSuperview];
             noInternetConnnection=nil;
         }
         noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
         noInternetConnnection.text=@"Please check your InterNet connection.";
         noInternetConnnection.numberOfLines=0;
         noInternetConnnection.textAlignment=NSTextAlignmentCenter;
         noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
         [self.view insertSubview:noInternetConnnection aboveSubview:menuTable];
     }

}

#pragma mark- textField delgate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length !=0) {
        [self searchBtnAction:0];
    }
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
        cell=[[TableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notFeed"];
        
        cell.topView.hidden = YES;
        [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"iboard-follow_btn.png"] forState:UIControlStateNormal];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//        if (follow) {
//            [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
//            [cell.add_minusButton addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else{
     
       // }
        [cell.add_minusButton addTarget:self action:@selector(followActions:) forControlEvents:UIControlEventTouchUpInside];
    cell.add_minusButton.tag=indexPath.row;

     

        
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
        height=80;
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
    [searchBox resignFirstResponder];
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=%@",searchBox.text,client_id_iboard]];
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
    [profilePic removeAllObjects];
    [username removeAllObjects];
    [useridArr removeAllObjects];
  /*  NSURLResponse * urlResponse;
    NSError * error;
    
    
    
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/%@?access_token=%@",userid,choice,accessToken]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];*/
    
    id dictResponse;
//    if ([choice isEqualToString:@"follows"]) {
       dictResponse =[HelperClassIboard loadCopyFollowersList:userid choice:choice];
//    }
//    else{
//         dictResponse=[HelperClassIboard loadAllFollowedBy:nil];
//
//    }
        if ([[[dictResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
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
        }
    [copyFollowerTbl reloadData];
    

}


#pragma mark- unfollow action

// call unfollow api here
-(void)unfollowAction:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
     NSString * userIDStr=[useridArr  objectAtIndex:tag];
    /*NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
   
    
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
     */
    
   
    id response =[HelperClassIboard unfollowAction:userIDStr];
    
    if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        
      
        
//        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"You are unfollowing this user" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    }
    

    
    [copyFollowerTbl reloadData];
    
}
#pragma mark- follow action

-(void)followActions:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
      NSString * userIDStr=[useridArr  objectAtIndex:tag];
    /*NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
  
    
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
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];*/
    
    id response =[HelperClassIboard followActions:userIDStr];
    if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        
        [username removeObjectAtIndex:tag];
        [useridArr removeObjectAtIndex:tag];
        [profilePic removeObjectAtIndex:tag];
//        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"You are following this user" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    }
    
    
    [copyFollowerTbl reloadData];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- delegate methods of bannerview

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
    NSLog(@"Ad received");
}



/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    
    NSLog(@"Failed to receive");
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
