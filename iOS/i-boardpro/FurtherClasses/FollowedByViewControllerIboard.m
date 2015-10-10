

#import "FollowedByViewControllerIboard.h"
#import "TableCustomCell.h"
#import "SingletonClassIboard.h"
#import "UserProfileViewControllerIboard.h"
#import "UIImageView+WebCache.h"
#import "HelperClassIboard.h"

@interface FollowedByViewControllerIboard ()
{
    NSMutableArray * userId;
    UserProfileViewControllerIboard * userProfile;
    UILabel * noInternetConnnection;
    CGSize windowSize;
}

@end

@implementation FollowedByViewControllerIboard
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
    self.isAddMoreJokes = YES;
     self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    [SingletonClassIboard shareSinglton].followeBy=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].full_name=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].profile_picture=[[NSMutableArray alloc]init];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createFollowTable) name:@"loadAllFollowedBy" object:nil];
  
    // Do any additional setup after loading the view.
}

-(void)createFollowTable
{
    
   
    
    [followTableView removeFromSuperview];
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
       // request.testDevices = @[ kGADSimulatorID ];
        [self.bannerView loadRequest:request];
        self.bannerView.hidden = NO;
        //[self.view addSubview:self.bannerView];
        dispatch_async(dispatch_get_global_queue(0, 0),^{
            pagination = nil;
            [[SingletonClassIboard shareSinglton].followeBy removeAllObjects];
            [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
            [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];

            [self loadAllFollowedBy];
            dispatch_async(dispatch_get_main_queue(),^{
                [activityIndicator stopAnimating];
                if ([SingletonClassIboard shareSinglton].full_name.count<1) {
                    UILabel * label=[[UILabel alloc]init];
                    label.frame=CGRectMake(40, 150, windowSize.width-60, 50);
                    label.text=@"Currently there are no one is following you.";
                    label.font=[UIFont boldSystemFontOfSize:15];
                    label.lineBreakMode=NSLineBreakByWordWrapping;
                    label.numberOfLines=0;
                    label.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:label];
                }
                else{
                    
                   // followTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-105) style:UITableViewStylePlain];
                    followTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-55) style:UITableViewStylePlain];
                    followTableView.dataSource=self;
                    followTableView.delegate=self;
                    followTableView.backgroundColor=[UIColor whiteColor];
                    [self.view addSubview:followTableView];
                    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 40)];
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
        noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width, 50)];
        noInternetConnnection.text=@"Please check your InterNet connection.";
        noInternetConnnection.numberOfLines=0;
        noInternetConnnection.textAlignment=NSTextAlignmentCenter;
        noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noInternetConnnection];
    }
    
}

#pragma  mark Table View delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.topView.hidden = YES;
    }
     cell.likesBtn.hidden=YES;
    cell.commentBtn.hidden=YES;
    
     [cell.userImage sd_setImageWithURL:[[SingletonClassIboard shareSinglton].profile_picture objectAtIndex:indexPath.row]];
    cell.userNameDesc.text=[[SingletonClassIboard shareSinglton].full_name objectAtIndex:indexPath.row];
    cell.add_minusButton.hidden=YES;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[userId objectAtIndex:indexPath.row];
    [self presentViewController:userProfile animated:YES completion:nil];
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [SingletonClassIboard shareSinglton].full_name.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [NSThread detachNewThreadSelector:@selector(loadAllFollowedBy) toTarget:self withObject:nil];
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


#pragma  mark- load followed by
//call api for fetching all followed-by user list
-(void)loadAllFollowedBy{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
//    [[SingletonClassIboard shareSinglton].followeBy removeAllObjects];
//    [[SingletonClassIboard shareSinglton].full_name removeAllObjects];
//    [[SingletonClassIboard shareSinglton].profile_picture removeAllObjects];
    userId=[[NSMutableArray alloc]init];
    
  /*  NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl;
    if (pagination.length == 0) {
       getUrl =   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/followed-by?access_token=%@",accessToken]];
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
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];*/
    
    id dictResponse =[HelperClassIboard loadAllFollowedBy:pagination];
    
    if ([[[dictResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
    pagination = [[dictResponse objectForKey:@"pagination"]objectForKey:@"next_url"];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!followTableView) {
            
        }
        
        [followTableView reloadData];
        [self stopActivityIndicator];
    });
    }

}

-(void)firedNotification {
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
         self.dic.annotation = [NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"];
        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
        
        
    }
    
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

@end
