

#import "NonFollowerViewController.h"
#import "SingletonClassIboard.h"
#import "TableCustomCell.h"
#import "UserProfileViewControllerIboard.h"
#import "UIImageView+WebCache.h"
#import "HelperClassIboard.h"
#import "TWMessageBarManager.h"
@interface NonFollowerViewController ()
{
    NSMutableArray * userId;
    UserProfileViewControllerIboard * userProfile;
    UIActivityIndicatorView * activityIndicator;
    UILabel * noInternetConnnection;
    NSArray * mutaulfrnds;
  
}
@end

@implementation NonFollowerViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    full_name=[[NSMutableArray alloc]init];
    profilePic=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUI) name:@"loadNonFollower" object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI{
    
    //self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    [nonFollowTbl removeFromSuperview];
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {

//        self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
//        self.bannerView.frame =  CGRectMake(0, windowSize.height-105, windowSize.width, 50);
//        self.bannerView.adUnitID = adMobId_iboard;
//        self.bannerView.rootViewController = self;
//        self.bannerView.delegate = self;
//        
//        GADRequest *request = [GADRequest request];
//       // request.testDevices = @[ kGADSimulatorID ];
//        [self.bannerView loadRequest:request];
//        self.bannerView.hidden = NO;
//        [self.view addSubview:self.bannerView];
    
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        [self compareAndFetchNonFollowers];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            [self creatUI];
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

//create UI to show non followers
-(void)creatUI{
    
    if (mutaulfrnds.count<1) {
        UILabel * label=[[UILabel alloc]init];
        label.frame=CGRectMake(40, 150, windowSize.width-60, 50);
        label.text=@"There is no Non Follower";
        label.font=[UIFont boldSystemFontOfSize:15];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=0;
        label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    else{
    if(nonFollowTbl)
    {
        nonFollowTbl=nil;
    }
//    nonFollowTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-105) style:UITableViewStylePlain];
        nonFollowTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-55) style:UITableViewStylePlain];
    nonFollowTbl.dataSource=self;
    nonFollowTbl.delegate=self;
    nonFollowTbl.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nonFollowTbl];
        
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

        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 40)];
        view.backgroundColor=[UIColor clearColor];
        nonFollowTbl.tableFooterView=view;
    }
}



#pragma  mark- compareAndFetchNonFollowers
// get all non-followers
-(void)compareAndFetchNonFollowers{
    
    
    userId=[[NSMutableArray alloc]init];
    
   
        [self loadAllFollowedBy];
        [self loadAllFollowers];
   
    
    
    [full_name removeAllObjects];
    [profilePic removeAllObjects];
    [userId removeAllObjects];
   /*     NSMutableDictionary * followDict=[NSMutableDictionary dictionary];
        NSMutableDictionary * followedByDict=[NSMutableDictionary dictionary];
        
        NSLog(@"Follow Dic %@",[SingletonClassIboard shareSinglton].follower);
        NSLog(@"Follow By Dic %@",[SingletonClassIboard shareSinglton].followeBy);
        
        for (int i=0; i<[SingletonClassIboard shareSinglton].follower.count; i++) {
            followDict=[[SingletonClassIboard shareSinglton].follower objectAtIndex:i];
            BOOL contain=NO;
            for (int j=0; j<[SingletonClassIboard shareSinglton].followeBy.count; j++) {
                
                
                followedByDict=[[SingletonClassIboard shareSinglton].followeBy objectAtIndex:j];
                
                if ([[followedByDict objectForKey:@"id"] isEqualToString:[followDict objectForKey:@"id"]]) {
                    contain=YES;
                }
               
            }
            if (contain==NO) {
                [full_name addObject:[followDict objectForKey:@"username"]];
                [profilePic addObject:[followDict objectForKey:@"profile_picture"]];
                [userId addObject:[followDict objectForKey:@"id"]];
            }
        }*/
        NSLog(@" count of non follow %lu",(unsigned long)full_name.count);
    
    
    NSArray *a = [NSArray arrayWithArray:[SingletonClassIboard shareSinglton].follower];
    NSArray *b = [NSArray arrayWithArray:[SingletonClassIboard shareSinglton].followeBy];
    
    NSMutableSet *setA = [NSMutableSet setWithArray:a];
    NSMutableSet *setB = [NSMutableSet setWithArray:b];
    [setA minusSet:setB];
    mutaulfrnds =[setA allObjects];
    NSLog(@" count of non follow %@",mutaulfrnds);
   
}
//}


#pragma  mark-  load Followers
-(void)loadAllFollowers{
    
    [[SingletonClassIboard shareSinglton].follower removeAllObjects];
    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    
   /* NSURLResponse * urlResponse;
    NSError * error;
    
   
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
          pagination=[[dictResponse objectForKey:@"pagination"]objectForKey:@"next_url"];
         NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
         NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].follower addObject:dict];
        
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
    }
}
    
}

#pragma  mark- load followed by

-(void)loadAllFollowedBy{
    [[SingletonClassIboard shareSinglton].followeBy removeAllObjects];
    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    [userId removeAllObjects];

    
    /*NSURLResponse * urlResponse;
    NSError * error;
    
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
    
    
    id dictResponse = [HelperClassIboard loadAllFollowedBy:nil];
    if ([[[dictResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
        pagination=[[dictResponse objectForKey:@"pagination"]objectForKey:@"next_url"];
        NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].followeBy addObject:dict];
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
        
    }
    }
}



#pragma mark- delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"notFeed";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"iboard-unfollow.png"] forState:UIControlStateNormal];
        
    }
    [cell.add_minusButton addTarget:self action:@selector(unfollowActions:) forControlEvents:UIControlEventTouchUpInside];
    cell.add_minusButton.tag=indexPath.row;
    cell.userNameDesc.tag = indexPath.row;
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
    
    return mutaulfrnds.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark- unfollow action

-(void)unfollowActions:(UIButton *)sender{
  
   NSInteger tag = ((UIButton *)(UIControl *)sender).tag;

    NSString * userIDStr=[[mutaulfrnds  objectAtIndex:tag]objectForKey:@"id"];
    NSString *username = [[mutaulfrnds  objectAtIndex:tag]objectForKey:@"username"];
//    UIAlertController * alert=   [UIAlertController
//                                  alertControllerWithTitle:@"Info !!!"
//                                  message:[NSString stringWithFormat:@"Are you sure you want to unfollow  %@",username]
//                                  preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction
//                         actionWithTitle:@"Yes"
//                         style:UIAlertActionStyleDefault
//                         handler:^(UIAlertAction * action)
//                         {
    
                             id response =[HelperClassIboard unfollowAction:userIDStr];
                             
                             if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                                 
                                 [[SingletonClassIboard shareSinglton].follower removeAllObjects];
                                 [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
                                 [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
                                 [usreId removeAllObjects];
                                 [self compareAndFetchNonFollowers];
                                 [nonFollowTbl reloadData];
                                 [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"i-boardpro"
                                                                                description:[NSString stringWithFormat:@"You just unfollowed %@ ",username]
                                                                                       type:TWMessageBarMessageTypeInfo];

//                                 UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"You just unfollowed %@ ",username] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                                 [alertView show];
                             }
                             
                             
                             else{
                                 
                                 UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alertView show];
                                 
                                 
                                 
                             }
//                             [alert dismissViewControllerAnimated:YES completion:nil];
//                             
//                         }];
//    UIAlertAction* cancel = [UIAlertAction
//                             actionWithTitle:@"No"
//                             style:UIAlertActionStyleDefault
//                             handler:^(UIAlertAction * action)
//                             {
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                 
//                             }];
//    
//    [alert addAction:ok];
//    [alert addAction:cancel];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//
//    id response =[HelperClassIboard unfollowAction:userIDStr];
//    
//    if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
////        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"You are unfollowing this user" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////        [alertView show];
//    }
    
    
}

-(void)firedNotification {
    [[SingletonClassIboard shareSinglton]shareImageToInstagramFromController:self];
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
//    CGRect rect = CGRectMake(0 ,0 ,120, 60);
//    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        
//        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
//        self.dic.delegate = self;
//        self.dic.UTI = @"com.instagram.photo";
//        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
//         self.dic.annotation = [NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"];
//        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
//        
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-

-(void)showUserProfile:(UITapGestureRecognizer*)sender{
    if (userProfile) {
        userProfile=nil;
    }
    NSDictionary * dict =[mutaulfrnds objectAtIndex:[[sender view]tag]];
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    [self presentViewController:userProfile animated:YES completion:nil];
    
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
