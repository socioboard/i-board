//
//  OverlappingViewController.m
//  i-boardpro
//
//  Created by GBS-ios on 9/3/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "OverlappingViewController.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "SingletonClassIboard.h"

@interface OverlappingViewController ()
{
    CGSize windowSize;
    UIView * lineView;
    UIView * backView;
    UITextField * searchBox;
    UIView * userprofile,*otherUserProfile;
    NSMutableArray * reslutArr,*resultFollwerArr,* searchFollwers,* searchFollwedby;
    NSArray *commonFollwedby,* commonFollwers;
    UITableView * overlaperListTbl;
    int  page1;
    UIImageView * userImgeOtherUser;
  
}
@end

@implementation OverlappingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    windowSize = [UIScreen mainScreen].bounds.size;
 
    reslutArr =[[NSMutableArray alloc]init];
    resultFollwerArr =[[NSMutableArray alloc]init];
    
    searchFollwedby =[[NSMutableArray alloc]init];
    searchFollwers =[[NSMutableArray alloc]init];
    
    commonFollwedby =[[NSMutableArray alloc]init];
    commonFollwers =[[NSMutableArray alloc]init];
    
    page1 = 0;
    self.view.backgroundColor =[UIColor lightGrayColor];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAllServicesHere) name:@"ovelappingUser" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma create UI for overlapping followers

-(void)loadAllServicesHere{
 
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        [self loadAllFollowedBy:@"self"];
        [self loadAllFollowers:@"self"];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self overlappingUserList];
        });
    });
}


-(void)overlappingUserList{
    //self.view.backgroundColor =[UIColor whiteColor];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 00, windowSize.width, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UILabel * followersLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, windowSize.width/2-20, 30)];
    followersLbl.text = @"Followers";
    followersLbl.textColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    followersLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followersLbl];
    
    
    UILabel * followedByLbl =[[UILabel alloc]initWithFrame:CGRectMake(windowSize.width/2+10, 5, windowSize.width/2-20, 30)];
    followedByLbl.text = @"Followerd-By";
    followedByLbl.textColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    followedByLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followedByLbl];
    
    
    
    UIScrollView  * scrollView = [[UIScrollView alloc]init];
     scrollView.frame = CGRectMake(0, 50, windowSize.width, windowSize.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
   
    
    lineView =[[UIView alloc]init];
     lineView.frame= CGRectMake(0, 40, windowSize.width/2, 10);
    lineView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.view addSubview:lineView];
    
   
   
    for (int i = 0; i<2; i++) {
        CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
        backView =[[UIView alloc]init];
        backView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:backView];
       backView.frame= CGRectMake(x, 0, windowSize.width, scrollView.frame.size.height);
        
//        overlaperListTbl =[[UITableView alloc]init];
//        overlaperListTbl.frame = CGRectMake(0, backView.frame.size.height/2-50 , windowSize.width, windowSize.height/2-55);
//        overlaperListTbl.delegate = self;
//        overlaperListTbl.dataSource = self;
//        overlaperListTbl.showsVerticalScrollIndicator = NO;
//        overlaperListTbl.backgroundColor = [UIColor whiteColor];
//        [backView addSubview:overlaperListTbl];

    
//        userprofile =[[UIView alloc]init];
//        userprofile.frame= CGRectMake(10, 50, windowSize.width/2-20, windowSize.width/2-20);
//        userprofile.backgroundColor = [UIColor whiteColor];
//        [backView addSubview:userprofile];
//        
//        otherUserProfile =[[UIView alloc]init];
//        otherUserProfile.frame= CGRectMake(windowSize.width/2+10, 50, windowSize.width/2-20, windowSize.width/2-20);
//        otherUserProfile.backgroundColor = [UIColor whiteColor];
//        [backView addSubview:otherUserProfile];
        
    }
    
    searchBox =[[UITextField alloc]init];
    searchBox.frame = CGRectMake(10, 55, self.view.frame.size.width-20, 40);
    searchBox.backgroundColor = [UIColor whiteColor];
    searchBox.layer.borderColor = [UIColor blackColor].CGColor;
    searchBox.layer.borderWidth = 0.8;
    searchBox.layer.cornerRadius = 4;
    searchBox.clipsToBounds = YES;
    searchBox.delegate = self;
    searchBox.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:searchBox];
    
    scrollView.contentSize =  CGSizeMake(windowSize.width*2, windowSize.height);


    userprofile =[[UIView alloc]init];
    userprofile.frame= CGRectMake(10, 105, windowSize.width/2-20, windowSize.width/2-20);
    userprofile.backgroundColor = [UIColor whiteColor];
    userprofile.layer.cornerRadius = 4;
    userprofile.clipsToBounds = YES;
    [self.view addSubview:userprofile];
    
    UIImageView * userImge =[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 60, 60)];
    userImge.layer.cornerRadius = userImge.frame.size.width/2;
    userImge.clipsToBounds = YES;
    
    NSString *urlstring = [[NSUserDefaults standardUserDefaults]objectForKey:@"userprofile_picture"];
    NSURL * url=[NSURL URLWithString:urlstring];
//    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
    [userImge sd_setImageWithURL:url];
    [userprofile addSubview:userImge];
    
    
    
    otherUserProfile =[[UIView alloc]init];
    otherUserProfile.frame= CGRectMake(windowSize.width/2+10, 105, windowSize.width/2-20, windowSize.width/2-20);
    otherUserProfile.backgroundColor = [UIColor whiteColor];
    otherUserProfile.layer.cornerRadius = 4;
    otherUserProfile.clipsToBounds = YES;
    [self.view addSubview:otherUserProfile];
    
    
    userImgeOtherUser =[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 60, 60)];
    userImgeOtherUser.layer.cornerRadius = userImgeOtherUser.frame.size.width/2;
    userImgeOtherUser.clipsToBounds = YES;
    [otherUserProfile addSubview:userImgeOtherUser];
    
    
   overlaperListTbl =[[UITableView alloc]init];
    overlaperListTbl.frame = CGRectMake(10, windowSize.height/2 , windowSize.width-20, windowSize.height/2-60);
    overlaperListTbl.delegate = self;
    overlaperListTbl.dataSource = self;
    overlaperListTbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:overlaperListTbl];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    searchBox.frame = CGRectMake(0, 55, self.view.frame.size.width, 40);
    userprofile.frame= CGRectMake(10, 105, windowSize.width/2-20, windowSize.width/2-20);
    otherUserProfile.frame= CGRectMake(windowSize.width/2+10, 105, windowSize.width/2-20, windowSize.width/2-20);
    
//    userprofile.frame= CGRectMake(10, 50, windowSize.width/2-20, windowSize.width/2-20);
//    otherUserProfile.frame= CGRectMake(windowSize.width/2+10, 50, windowSize.width/2-20, windowSize.width/2-20);
    

    
     CGFloat pageWidth = scrollView.frame.size.width;
     page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(page1 == 0){
        [overlaperListTbl reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            lineView.frame = CGRectMake(0, 40, windowSize.width/2, 10);
        }];
    }
    else{
         [overlaperListTbl reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            lineView.frame = CGRectMake(pageWidth/2, 40, windowSize.width/2, 10);
            
        }];
    }

}


#pragma   mark- tableDelaget methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (page1 == 0) {
        
        return  commonFollwers.count;
    }
    else{
        return  commonFollwedby.count;
    }
//    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overlappingUser"];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"overlappingUser"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if (page1 == 0) {
        if (commonFollwers.count>0) {
            
        NSDictionary * dict =[commonFollwers objectAtIndex:indexPath.row];
        
        [cell.cmtUserImage sd_setImageWithURL:[dict objectForKey:@"profile_picture"]];
        cell.cmtUserName.text=[dict objectForKey:@"username"];
        }
    }
    else{
        if (commonFollwedby.count>0) {
        NSDictionary * dict =[commonFollwedby objectAtIndex:indexPath.row];
        
        [cell.cmtUserImage sd_setImageWithURL:[dict objectForKey:@"profile_picture"]];
        cell.cmtUserName.text=[dict objectForKey:@"username"];
        }
    }
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark- API methods
#pragma  mark- load followed by

-(void)loadAllFollowedBy:(NSString *)user{
    NSURLResponse * urlResponse;
    NSError * error;
    
  
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/followed-by?access_token=%@",user, accessToken]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray * resultArr1=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr1,(unsigned long)resultArr1.count);
    if (reslutArr.count>0) {
        
        for (int i=0; i<resultArr1.count; i++) {
            [searchFollwedby addObject:[resultArr1 objectAtIndex:i]];
            
        }

    }
    else{
        for (int i=0; i<resultArr1.count; i++) {
            [reslutArr addObject:[resultArr1 objectAtIndex:i]];
        
        }
    }
}

-(void)loadAllFollowers:(NSString *)user{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
   
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows?access_token=%@",user,accessToken]];
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
    
    if (resultFollwerArr.count>0) {
        for (int i=0; i<resultArr.count; i++)
        {
            [searchFollwers addObject:[resultArr objectAtIndex:i]];
        }
    }
    else
    {
        for (int i=0; i<resultArr.count; i++)
        {
            [resultFollwerArr addObject:[resultArr objectAtIndex:i]];
        }
    }
    
}


#pragma  mark- search API

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
        
       NSURL * url1=[NSURL URLWithString:[dict objectForKey:@"profile_picture"]];
       [userImgeOtherUser sd_setImageWithURL:url1];

      NSString*  userId=[dict objectForKey:@"id"];
        [self loadAllFollowedBy:userId];
        [self loadAllFollowers:userId];
        [self compareTogetMutualFrnds];
    }
    
}


#pragma mark- common users 

#pragma mark- get all fans from here

-(void)compareTogetMutualFrnds{
    
    NSMutableSet *setA = [NSMutableSet setWithArray:searchFollwedby];
    NSSet *setB = [NSSet setWithArray:reslutArr];
    [setA intersectSet:setB];
    commonFollwedby = [setA allObjects];
    
    
    NSMutableSet *setX = [NSMutableSet setWithArray:searchFollwers];
    NSSet *setY = [NSSet setWithArray:resultFollwerArr];
    [setX intersectSet:setY];
    commonFollwers = [setX allObjects];
    [overlaperListTbl reloadData];
}

#pragma mark- textField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchBtnAction:0];
    
    return YES;
}





@end
