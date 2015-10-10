

#import "MutualFriendsViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import "TableCustomCell.h"
#import "UserProfileViewControllerIboard.h"
#import "UIImageView+WebCache.h"
#import "HelperClassIboard.h"

@interface MutualFriendsViewControllerrIboard ()
{
    NSMutableArray * userId,* full_name,*profilePic;
    UserProfileViewControllerIboard* userProfile;
     UIActivityIndicatorView * activityIndicator;
    UILabel * noInternetConnnection;
    NSMutableArray * mutaulfrnds;
}
@end

@implementation MutualFriendsViewControllerrIboard

- (void)viewDidLoad {
    [super viewDidLoad];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    full_name=[[NSMutableArray alloc]init];
    profilePic=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createUI) name:@"showMutualFrnds" object:nil];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    // Do any additional setup after loading the view from its nib.
}



-(void)createUI{
    mutaulfrnds = [[NSMutableArray alloc]init];
    //self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    [mutualTbl removeFromSuperview];
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {

        self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
        self.bannerView.frame =  CGRectMake(0, windowSize.height-105, windowSize.width, 50);
        self.bannerView.adUnitID = adMobId_iboard;
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
        
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ kGADSimulatorID ];
        [self.bannerView loadRequest:request];
        self.bannerView.hidden = NO;
       // [self.view addSubview:self.bannerView];
        
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self compareTogetMutualFrnds];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            [self creatTableForMutualFrnds];
        });
    });
    }
    else{
        [activityIndicator stopAnimating];
        if (noInternetConnnection) {
            [noInternetConnnection removeFromSuperview];
            noInternetConnnection=nil;
        }
        noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
        noInternetConnnection.text=@"Please check your InterNet connection.";
        noInternetConnnection.numberOfLines=0;
        noInternetConnnection.textAlignment=NSTextAlignmentCenter;
        noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noInternetConnnection];
    }

}


-(void)creatTableForMutualFrnds{
    if ( mutaulfrnds.count<1) {
        UILabel * label=[[UILabel alloc]init];
        label.frame=CGRectMake(40, 150, windowSize.width-60, 50);
        label.text=@"There is no fans";
        label.font=[UIFont boldSystemFontOfSize:15];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=0;
        label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    else{
    //mutualTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-105)];
    mutualTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-55)];
    
    mutualTbl.delegate=self;
    mutualTbl.dataSource=self;
    [self.view addSubview:mutualTbl];
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 40)];
        view.backgroundColor=[UIColor clearColor];
        mutualTbl.tableFooterView=view;
    }
    
}


#pragma mark- Table view delegate methods
#pragma mark- delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"notFeed";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.add_plusButton.hidden=YES;
        cell.add_minusButton.hidden=NO;
         [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"iboard-unfollow.png"] forState:UIControlStateNormal];
        [cell.add_minusButton addTarget:self action:@selector(unfollowActions:) forControlEvents:UIControlEventTouchUpInside];
         cell.topView.hidden = YES;
    }
    cell.commentBtn.hidden=YES;
     cell.likesBtn.hidden=YES;
    
//   [cell.userImage sd_setImageWithURL:[profilePic objectAtIndex:indexPath.row]];
//    
//    cell.userNameDesc.text=[full_name objectAtIndex:indexPath.row];
    cell.add_minusButton.tag=indexPath.row;
    UITapGestureRecognizer * tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserProfile:)];
    tapGesture.numberOfTouchesRequired =1;
    cell.userNameDesc.userInteractionEnabled = YES;
    [cell.userNameDesc addGestureRecognizer:tapGesture];

    NSDictionary * dict =[mutaulfrnds objectAtIndex:indexPath.row];
    
    [cell.userImage sd_setImageWithURL:[dict objectForKey:@"profile_picture"]];
    cell.userNameDesc.text=[dict objectForKey:@"username"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (userProfile) {
        userProfile=nil;
    }
    NSDictionary * dict =[mutaulfrnds objectAtIndex:indexPath.row];
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];

    [self presentViewController:userProfile animated:YES completion:nil];*/
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  mutaulfrnds.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}




#pragma mark- get all fans from here

-(void)compareTogetMutualFrnds{
    userId=[[NSMutableArray alloc]init];
    
  
        [self loadAllFollowedBy];
        [self loadAllFollowers];
  
    
    [full_name removeAllObjects];
    [profilePic removeAllObjects];
      /*  NSMutableArray * checkId=[[NSMutableArray alloc]init];
        NSMutableDictionary * followDict=[NSMutableDictionary dictionary];
        NSMutableDictionary * followedByDict=[NSMutableDictionary dictionary];
        
        NSLog(@"Follow Dic %@",[SingletonClassIboard shareSinglton].follower);
        NSLog(@"Follow By Dic %@",[SingletonClassIboard shareSinglton].followeBy);
        
        for (int i=0; i<[SingletonClassIboard shareSinglton].follower.count; i++) {
            BOOL isAvail=NO;
            followDict=[[SingletonClassIboard shareSinglton].follower objectAtIndex:  i];
            for (int j=0; j<[SingletonClassIboard shareSinglton].followeBy.count; j++) {
                
                
                followedByDict=[[SingletonClassIboard shareSinglton].followeBy objectAtIndex:j];
                
                if ([[followedByDict objectForKey:@"id"] isEqualToString:[followDict objectForKey:@"id"]]) {
                    isAvail=YES;
                    
                }
            }
            if (isAvail==YES) {
                if (![checkId containsObject:followDict]) {
                    [checkId addObject:followDict];
                    [full_name addObject:[followDict objectForKey:@"full_name"]];
                    [profilePic addObject:[followDict objectForKey:@"profile_picture"]];
                    [userId addObject:[followDict objectForKey:@"id"]];
                }
                
            }
            
        }*/
    
    NSArray *a = [NSArray arrayWithArray:[SingletonClassIboard shareSinglton].follower];
    NSArray *b = [NSArray arrayWithArray:[SingletonClassIboard shareSinglton].followeBy];
    
    NSMutableSet *setA = [NSMutableSet setWithArray:a];
    NSSet *setB = [NSSet setWithArray:b];
    [setA intersectSet:setB];
    NSLog(@"c: %@", [setA allObjects]);
    NSArray * arr =[setA allObjects];
     mutaulfrnds = [NSMutableArray arrayWithArray:arr];
    
    }
//}




#pragma  mark-  load Followers
-(void)loadAllFollowers{
    
   /* NSURLResponse * urlResponse;
    NSError * error;
    
    [[SingletonClassIboard shareSinglton].follower removeAllObjects];
    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    [userId removeAllObjects];

    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];*/
    id dictResponse =[HelperClassIboard loadAllFollowers:nil];
    if ([[[dictResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {

    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].follower addObject:dict];
        
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
        [userId addObject:[dict objectForKey:@"id"]];
    }
    }
    
}

#pragma  mark- load followed by

-(void)loadAllFollowedBy{
    /*NSURLResponse * urlResponse;
    NSError * error;
    
    [[SingletonClassIboard shareSinglton].followeBy removeAllObjects];
    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    [userId removeAllObjects];
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/followed-by?access_token=%@",accessToken]];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];*/
    
    
    id dictResponse =[HelperClassIboard loadAllFollowedBy:nil];
    if ([[[dictResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {

    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].followeBy addObject:dict];
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
         [userId addObject:[dict objectForKey:@"id"]];
    }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- unfollow action

// call unfollow api here
-(void)unfollowActions:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
   /* NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    //NSString * userIDStr=[userId  objectAtIndex:tag];
    
    NSString * userIDStr=[[mutaulfrnds objectAtIndex:tag]objectForKey:@"id"];
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
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];*/
    // NSLog(@"response of sollowing %@", response);
    NSString * userIDStr=[userId  objectAtIndex:tag];
    id response =[HelperClassIboard unfollowAction:userIDStr];
    
    if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
//        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"You are unfollowing this user" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        [mutaulfrnds removeObjectAtIndex:tag];
        
    }
    
    [[SingletonClassIboard shareSinglton].follower removeAllObjects];
    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    [userId removeAllObjects];
     [self compareTogetMutualFrnds];
    [mutualTbl reloadData];
    
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

#pragma mark-

-(void)showUserProfile:(UITapGestureRecognizer*)sender{
    if (userProfile) {
        userProfile=nil;
    }
    NSDictionary * dict =[mutaulfrnds objectAtIndex:[[sender view]tag]];
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
    [self presentViewController:userProfile animated:YES completion:nil];}



@end
