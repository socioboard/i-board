

#import "FollwViewControllerIboard.h"
#import "TableCustomCell.h"
#import "SingletonClassIboard.h"
#import "UserProfileViewControllerIboard.h"
#import "UIImageView+WebCache.h"
#import "HelperClassIboard.h"
#import "TWMessageBarManager.h"
@interface FollwViewControllerIboard ()
{
    UserProfileViewControllerIboard * userProfile;
    UIActivityIndicatorView * activityIndicator,* loadActivityView;
    UILabel * noInternetConnnection;
    CGSize winsowSize;
    id response;
}
@end

@implementation FollwViewControllerIboard
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

- (void)viewDidLoad
{
    self.isAddMoreJokes = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    winsowSize=[UIScreen mainScreen].bounds.size;
    
    [SingletonClassIboard shareSinglton].follower=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].full_name=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].profile_picture=[[NSMutableArray alloc]init];
    usreId=[[NSMutableArray alloc]init];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(winsowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createFollowByTable) name:@"loadAllFollowers" object:nil];

}


//create  follow Table View if Data available


-(void)createFollowByTable
{
   // self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    [followTableView removeFromSuperview];
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {

//        self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
//        self.bannerView.frame =  CGRectMake(0, winsowSize.height-105, winsowSize.width, 50);
//        self.bannerView.adUnitID = adMobId_iboard;
//        self.bannerView.rootViewController = self;
//        self.bannerView.delegate = self;
//        
//        GADRequest *request = [GADRequest request];
//      //  request.testDevices = @[ kGADSimulatorID ];
//        [self.bannerView loadRequest:request];
//        self.bannerView.hidden = NO;
//        [self.view addSubview:self.bannerView];
        
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        pagination = nil;
            [[SingletonClassIboard shareSinglton].follower removeAllObjects];
            [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
            [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
            [usreId removeAllObjects];
        [self loadAllFollowers];// call LoadAllFollwers method
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            if ([SingletonClassIboard shareSinglton].full_name.count<1) {
                UILabel * label=[[UILabel alloc]init];
                label.frame=CGRectMake(40, 150, winsowSize.width-60, 50);
                label.text=@"You are not following anyone.";
                label.font=[UIFont boldSystemFontOfSize:15];
                label.lineBreakMode=NSLineBreakByWordWrapping;
                label.numberOfLines=0;
                label.textAlignment=NSTextAlignmentCenter;
                [self.view addSubview:label];
            }
            else{
              if(followTableView)
              {
                  followTableView=nil;
              }
              //  followTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, winsowSize.width,winsowSize.height-105) style:UITableViewStylePlain];
                followTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, winsowSize.width,winsowSize.height-55) style:UITableViewStylePlain];
                followTableView.dataSource=self;
                followTableView.delegate=self;
                followTableView.backgroundColor=[UIColor whiteColor];
                followTableView.showsVerticalScrollIndicator = NO;
                [self.view addSubview:followTableView];
                self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
                self.bannerView.frame =  CGRectMake((winsowSize.width - self.bannerView.frame.size.width)/2, winsowSize.height-105, self.bannerView.frame.size.width, 50);
                self.bannerView.adUnitID = adMobId_iboard;
                self.bannerView.rootViewController = self;
                self.bannerView.delegate = self;
                
                GADRequest *request = [GADRequest request];
                //  request.testDevices = @[ kGADSimulatorID ];
                [self.bannerView loadRequest:request];
                self.bannerView.hidden = NO;
                [self.view addSubview:self.bannerView];
                UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, winsowSize.width, 40)];
                view.backgroundColor=[UIColor clearColor];
                followTableView.tableFooterView=view;
                
                loadActivityView =[[UIActivityIndicatorView alloc]init];
                loadActivityView.frame=CGRectMake(view.frame.size.width/2-20, 0, 40, 40);
                loadActivityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
                loadActivityView.color=[UIColor blackColor];
                loadActivityView.alpha=1.0;
                [view addSubview:loadActivityView];
            }
            
           
        });
    });
}
    else{
        [activityIndicator stopAnimating];
        if (noInternetConnnection) {
            [noInternetConnnection removeFromSuperview];
            noInternetConnnection=nil;
        }
        noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, winsowSize.height/2-50, winsowSize.width-50, 50)];
        noInternetConnnection.text=@"Please check your InterNet connection.";
        noInternetConnnection.textAlignment=NSTextAlignmentCenter;
        noInternetConnnection.numberOfLines=0;
        noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noInternetConnnection];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

#pragma mark-TableView delegate methods

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
     cell.add_minusButton.tag=indexPath.row;
     [cell.add_minusButton addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
    //-----------------
    cell.userNameDesc.tag = indexPath.row;
    UITapGestureRecognizer * tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserProfile:)];
    tapGesture.numberOfTouchesRequired =1;
    cell.userNameDesc.userInteractionEnabled = YES;
    [cell.userNameDesc addGestureRecognizer:tapGesture];
    
    [cell.userImage sd_setImageWithURL:[[SingletonClassIboard shareSinglton].profile_picture objectAtIndex:indexPath.row]];
    
    cell.userNameDesc.text=[[SingletonClassIboard shareSinglton].full_name objectAtIndex:indexPath.row];
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[usreId objectAtIndex:indexPath.row];
    [self presentViewController:userProfile animated:YES completion:nil];*/
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SingletonClassIboard shareSinglton].full_name.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark -
#pragma mark ScrollView Delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        if (y > h+50) {
            
            if (self.isAddMoreJokes==YES) {
                [self addMoreRows];
            }
        }
        
    }
    else{
        return;
    }
}

-(void) addMoreRows{
    self.isAddMoreJokes = NO;
    if (pagination) {
        [loadActivityView startAnimating];
        [followTableView setContentInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [NSThread detachNewThreadSelector:@selector(loadAllFollowers) toTarget:self withObject:nil];
    }
    else{
        NSLog(@"No more Jokes");
    }
}

-(void)stopActivityIndicator{
    if (loadActivityView) {
        
        if (loadActivityView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadActivityView stopAnimating];
                [followTableView setContentInset:(UIEdgeInsetsMake(0, 0, -50, 0))];
            });
            self.isAddMoreJokes = YES;
        }
    }
}



#pragma mark- unfollow action

// call unfollow api here
-(void)unfollowAction:(UIButton *)sender{
   
    
    NSInteger tag = ((UIButton *)(UIControl *)sender).tag;
    NSString *username = [[SingletonClassIboard shareSinglton].full_name objectAtIndex:tag];
    NSLog(@"unfollow username is %@",username);
    NSString * userIDStr=[usreId  objectAtIndex:tag];
    
//    UIAlertController * alert=   [UIAlertController
//                                  alertControllerWithTitle:@"Alert !!!"
//                                  message:[NSString stringWithFormat:@"Are you sure you want to unfollow  %@",username]
//                                  preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction
//                         actionWithTitle:@"Yes"
//                         style:UIAlertActionStyleDefault
//                         handler:^(UIAlertAction * action)
//                         {
    
                               response=[HelperClassIboard unfollowAction:userIDStr];
                            
                             if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                                                                
                                 [[SingletonClassIboard shareSinglton].follower removeAllObjects];
                                 [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
                                 [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
                                 [usreId removeAllObjects];
                                 [self loadAllFollowers];
                                 [followTableView reloadData];
                                 [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"i-boardpro"
                                                                                description:[NSString stringWithFormat:@"You just unfollowed %@ ",username]
                                                                                       type:TWMessageBarMessageTypeInfo];
                             }
                             else{
                                 
                                 UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alertView show];
                                 
                                 
                                 
                             }
//
//                              [alert dismissViewControllerAnimated:YES completion:nil];
//                             
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
    
    
//    id response=[HelperClassIboard unfollowAction:userIDStr];
    
    NSLog(@"response of sollowing %@", response);
    
    
}





#pragma  mark-  load Followers
// get all following user
-(void)loadAllFollowers{
    
   /* NSURLResponse * urlResponse;
    NSError * error;
    

    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl;
    if (pagination.length == 0) {
       getUrl =   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]];
    }
    else{
        getUrl = [NSURL URLWithString:pagination];
    }
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];

    
    if (data==nil) {
        return;
    }
    id dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];*/
    id dictResponse =[HelperClassIboard loadAllFollowers:pagination];
    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    pagination = [[dictResponse objectForKey:@"pagination"]objectForKey:@"next_url"];
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].follower addObject:dict];
        
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
        [usreId addObject:[dict objectForKey:@"id"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!followTableView) {
            
        }
        
        [followTableView reloadData];
        [self stopActivityIndicator];
    });
    
    
}



-(void)firedNotification {
    [[SingletonClassIboard shareSinglton]shareImageToInstagramFromController:self];
    
    
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
//        
//    }
//    
}

#pragma mark-

-(void)showUserProfile:(UITapGestureRecognizer*)sender{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[usreId objectAtIndex:[sender view].tag];
    [self presentViewController:userProfile animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- delegate methods of bannerview

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
    NSLog(@"Ad received");
}
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
