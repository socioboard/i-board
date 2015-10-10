

#import "FeedViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "UserProfileViewControllerIboard.h"
#import "CommentsViewController.h"
#import "CustomCell.h"
#import "HelperClassIboard.h"

@interface FeedViewControllerIboard ()
{
    UIView * popView;
    NSMutableDictionary * commentsDic;
     UserProfileViewControllerIboard * userProfile;
    NSMutableArray * cmtTextArr,* cmtUserImgArr,* cmtUserName,*cmtMediaId,* userLiked;
    UITableView * commentsTbl;
    CommentsViewController * commentsVc;
    UILabel * noInternetConnnection;
    NSData * imagesSize;
    BOOL inAnimation;
    CALayer *waveLayer;
    UICollectionView * maincollection;
    UIImage * image;
   
}
@end

@implementation FeedViewControllerIboard
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
    pagination = nil;
       [SingletonClassIboard shareSinglton].commentsCount=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].likesCount=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].feedPic=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].feedUserPic=[[NSMutableArray alloc]init];
    [SingletonClassIboard shareSinglton].feedUserName=[[NSMutableArray alloc]init];
    userLiked = [[NSMutableArray alloc]init];
    cmtMediaId=[[NSMutableArray alloc]init];
    userId=[[NSMutableArray alloc]init];
   
    windowSize=[UIScreen mainScreen].bounds.size;
    
    activityView =[[UIActivityIndicatorView alloc]init];
    activityView.frame=CGRectMake(windowSize.width/2-20, windowSize.height/2-50, 40, 40);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityView.color=[UIColor blackColor];
    activityView.alpha=1.0;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUI:) name:@"loadFeeds" object:nil];
    NSString * firstRun=[[NSUserDefaults standardUserDefaults]objectForKey:@"firstRun"];
    if (!firstRun) {
        [self createUI];
         [activityView startAnimating];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [self createUI];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)createUI{
    [feedTableView removeFromSuperview];
    [activityView startAnimating];
    
    //self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    
    
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {
        
        dispatch_async(dispatch_get_global_queue(0, 0),^{
            [self loadFeeds];
            if([SingletonClassIboard shareSinglton].feedPic.count == 0)
            {
                
                [activityView stopAnimating];
                if (noInternetConnnection) {
                    [noInternetConnnection removeFromSuperview];
                    noInternetConnnection=nil;
                }
                noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
                noInternetConnnection.text=@"No content avalibale.";
                noInternetConnnection.textAlignment=NSTextAlignmentCenter;
                noInternetConnnection.numberOfLines=0;
                noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
                [self.view addSubview:noInternetConnnection];

            }
            else{
                NSURL * urlFeed=[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedPic objectAtIndex:0]];
                imagesSize =[NSData dataWithContentsOfURL:urlFeed];
                image = [UIImage imageWithData:imagesSize];
            }
                dispatch_async(dispatch_get_main_queue(),^{
                [activityView stopAnimating];
                
                [self creatUI];
                
            });
        });
        
    }
    else{
        [activityView stopAnimating];
        if (noInternetConnnection) {
            [noInternetConnnection removeFromSuperview];
            noInternetConnnection=nil;
        }
        noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
        noInternetConnnection.text=@"Please check your InterNet connection.";
        noInternetConnnection.textAlignment=NSTextAlignmentCenter;
        noInternetConnnection.numberOfLines=0;
        noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noInternetConnnection];
    }

}



-(void)loadUI:(NSNotification *)notify{
    
    if ([notify.object isEqualToString:@"userMenu"]) {
          pagination = nil;
            [[SingletonClassIboard shareSinglton].commentsCount removeAllObjects];
           [[SingletonClassIboard shareSinglton].likesCount removeAllObjects ];
           [[SingletonClassIboard shareSinglton].feedPic removeAllObjects];
           [[SingletonClassIboard shareSinglton].feedUserPic removeAllObjects];
           [[SingletonClassIboard shareSinglton].feedUserName removeAllObjects];
            [userLiked removeAllObjects];
            [cmtMediaId removeAllObjects];
            [userId removeAllObjects];

    }
    [self createUI];
    
}

-(void)creatUI{

   
    
    
    UICollectionViewFlowLayout * flowlayout =[[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 2.0;
    flowlayout.minimumLineSpacing= 2.0;
   // flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
    int height = windowSize.height;
    switch (height) {
        case 480:flowlayout.itemSize = CGSizeMake(73, 73);
            break;
        case 568 : flowlayout.itemSize = CGSizeMake(73, 73);
            break;
        case 667 : flowlayout.itemSize = CGSizeMake(83, 83);
            break;
        case 736 : flowlayout.itemSize = CGSizeMake(73, 73);
            break;
        default:
            break;
    }
    
    
    if (maincollection) {
        [maincollection removeFromSuperview];
        maincollection=nil;
    }
    
    maincollection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height-55) collectionViewLayout:flowlayout];
    maincollection.delegate = self;
    maincollection.dataSource = self;
    [self.view addSubview:maincollection];
    maincollection.backgroundColor=[UIColor whiteColor];
    
    [maincollection registerClass:[CustomCell class] forCellWithReuseIdentifier:@"collectionCell"];
    

    
    
    if(feedTableView)
    {
        [feedTableView removeFromSuperview];
        feedTableView=nil;
    }
    feedTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 3, windowSize.width-40,windowSize.height-40) style:UITableViewStylePlain];
    feedTableView.dataSource=self;
    feedTableView.delegate=self;
    feedTableView.backgroundColor=[UIColor whiteColor];
    feedTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:feedTableView];
    
    UIView * feedFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 20)];
    feedFooter.backgroundColor=[UIColor clearColor];
    feedTableView.tableFooterView=feedFooter;
    
    feedTableView.hidden =YES;
    
    loadActivityView =[[UIActivityIndicatorView alloc]init];
    loadActivityView.frame=CGRectMake(feedFooter.frame.size.width/2-20, 0, 40, 40);
    loadActivityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    loadActivityView.color=[UIColor blackColor];
    loadActivityView.alpha=1.0;
    [feedFooter addSubview:loadActivityView];
   // feedTableView.tableFooterView = loadActivityView;
    
}


#pragma mark-TableView delegate methods

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//       if (section%5 == 0) {
//           UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,40)];
//           footerView.backgroundColor=[UIColor clearColor];
//           
//           bannerAds =[[AdmobAdsViewController alloc]initWithFrame:CGRectMake(20, 5, windowSize.width-40,140)];
//           [footerView addSubview:bannerAds.view];
//
//    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell =(TableCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       

        [cell.commentBtn addTarget:self action:@selector(opneCommentsPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentCnt addTarget:self action:@selector(opneCommentsPage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likesBtn addTarget:self action:@selector(likeFeedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.commentBtn.tag  = indexPath.section;
    cell.commentCnt.tag = indexPath.section;
    cell.likesBtn.tag = indexPath.section;
    if (feedTableView==tableView) {
        cell.commentBtn.tag=indexPath.section;
        cell.commentCnt.tag=indexPath.section;

        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.shadowOpacity = 0.4f;
        cell.contentView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        cell.contentView.layer.shadowRadius = 10.0f;
        cell.contentView.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds];
        cell.layer.shadowPath = path.CGPath;
       
    
    NSURL * url=[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedUserPic objectAtIndex:indexPath.section]];

        [cell.feedsUserImage sd_setImageWithURL:url];
    cell.feedsUsername.text=[[SingletonClassIboard shareSinglton].feedUserName objectAtIndex:indexPath.section];

    
    NSURL * urlFeed=[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedPic objectAtIndex:indexPath.section]];

    
    [cell.feedImage sd_setImageWithURL:urlFeed];
    
        cell.likesBtn.tag=indexPath.section;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
    cell.likesCount.text=[NSString stringWithFormat:@"%@",[[SingletonClassIboard shareSinglton].likesCount objectAtIndex:indexPath.section]];
    [cell.commentCnt setTitle:[NSString stringWithFormat:@"%@",[[SingletonClassIboard shareSinglton].commentsCount objectAtIndex:indexPath.section]] forState:UIControlStateNormal];
    cell.add_minusButton.hidden=YES;
        
        cell.topView.frame = CGRectMake(0, 0, feedTableView.frame.size.width, 50);
        cell.feedImage.frame = CGRectMake(20, 70, feedTableView.frame.size.width-40, image.size.height-60);
        cell.bottomView.frame = CGRectMake(0, image.size.height+20, feedTableView.frame.size.width, 30);
        cell.likesBtn.frame =CGRectMake(20, 7, 15, 15);
        cell.likesCount.frame=CGRectMake(38,  7, 50, 20);
        cell.commentBtn.frame = CGRectMake(feedTableView.frame.size.width-60,7, 15, 20);
        cell.commentCnt.frame =CGRectMake(feedTableView.frame.size.width-40, 7, 50, 20);
        cell.commentCnt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSLog(@"userLiked number %@",[userLiked objectAtIndex:indexPath.section]);
        if ([[userLiked objectAtIndex:indexPath.section] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [cell.likesBtn setBackgroundImage:[UIImage imageNamed:@"iboard-like_active.png"] forState:UIControlStateNormal];
        }
        else{
            
            [cell.likesBtn setBackgroundImage:[UIImage imageNamed:@"iboard-like.png"] forState:UIControlStateNormal];
        }
        
        if (indexPath.section %5 == 0 ) {
            cell.bannerView.frame =  CGRectMake(0, image.size.height+20+30+10, feedTableView.frame.size.width, 50);
            cell.bannerView.adUnitID = adMobId_iboard;
            cell.bannerView.rootViewController = self;
            cell.bannerView.delegate = self;
            
            GADRequest *request = [GADRequest request];
          //  request.testDevices = @[ kGADSimulatorID ];
            [cell.bannerView loadRequest:request];
            cell.bannerView.hidden = NO;

        }
        else{
            cell.bannerView.hidden = YES;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[userId objectAtIndex:indexPath.section];
    [self presentViewController:userProfile animated:YES completion:nil];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [SingletonClassIboard shareSinglton].feedPic.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
      return 30;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section % 5 == 0) {
        //return  image.size.height+110;
    }
    
    return image.size.height+50;
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
        [feedTableView setContentInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [NSThread detachNewThreadSelector:@selector(loadFeeds) toTarget:self withObject:nil];
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
                [feedTableView setContentInset:(UIEdgeInsetsMake(0, 0, -50, 0))];
                
            });
            self.isAddMoreJokes = YES;
        }
    }
    
}


#pragma mark- collectionview delegate methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSURL * urlFeed=[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedPic objectAtIndex:indexPath.row]];
    
    
    [cell.profileImageView sd_setImageWithURL:urlFeed];

    return  cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [SingletonClassIboard shareSinglton].feedPic.count;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [maincollection removeFromSuperview];
    maincollection=nil;
    feedTableView.hidden=NO;
    [feedTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]
                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}



#pragma mark- load Feeds
// Api call for showing user home feeds

-(void)loadFeeds{

   
    
    /*NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    NSURL * url;
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (pagination) {
        url =  [NSURL URLWithString:pagination];
    }
    else{
    
     url=[NSURL  URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/users/self/feed?access_token=%@",access_token]];
    }
    NSMutableURLRequest * getRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Feeds  %@",response);*/
    
  id response =  [HelperClassIboard loadFeeds:pagination];
    
    NSMutableDictionary * dict=[response objectForKey:@"meta"];
    
    if ([[dict objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        pagination=[[response objectForKey:@"pagination"]objectForKey:@"next_url"];
        nextMaxId=[response objectForKey:@"next_max_id"];
        NSArray * dataArr=[response objectForKey:@"data"];
        commentsDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * likesDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * imagesDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * mainDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * fromDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * stdDic=[NSMutableDictionary dictionary];
    
        
       
        for (int i=0; i<dataArr.count; i++) {
            mainDic=[dataArr objectAtIndex:i];
            [userLiked addObject:[mainDic objectForKey:@"user_has_liked"]];
             //captionDic=[mainDic objectForKey:@"caption"];
                  //      if ( captionDic != [ NSNull null ]) {
               
               // fromDic=[mainDic objectForKey:@"from"];
                fromDic=[mainDic objectForKey:@"user"];
                [[SingletonClassIboard shareSinglton].feedUserPic addObject:[fromDic objectForKey:@"profile_picture"]];
                [[SingletonClassIboard shareSinglton].feedUserName addObject:[fromDic objectForKey:@"username"]];
                
                [userId addObject:[fromDic objectForKey:@"id"]];
            
                commentsDic=[mainDic objectForKey:@"comments"];
                [[SingletonClassIboard shareSinglton].commentsCount addObject:[commentsDic objectForKey:@"count"]];
             
                
                            
                //================= get all feed images and there respective id's.
                [cmtMediaId addObject:[mainDic objectForKey:@"id"]];

                imagesDic=[mainDic objectForKey:@"images"];
                stdDic=[imagesDic objectForKey:@"low_resolution"];
                
                [[SingletonClassIboard shareSinglton].feedPic addObject:[stdDic objectForKey:@"url"]];
                
                likesDic=[mainDic objectForKey:@"likes"];
                [[SingletonClassIboard shareSinglton].likesCount addObject:[likesDic objectForKey:@"count"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!feedTableView) {
                    
                }
                
                [feedTableView reloadData];
                [self stopActivityIndicator];
                //NSLog(@"Count == %d",self.alljokesArray.count);
            });
                          
           // }
        }
    }
    
 }

#pragma mark-

-(void)handleTapGestureToOpenCmt:(UIButton *)sender{
     int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * captionId=[cmtMediaId objectAtIndex:tag];
    
    if (commentsVc) {
        commentsVc=nil;
    }
    commentsVc=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    commentsVc.capId=captionId;
    commentsVc.feedImage = image;
    commentsVc.index = tag;
    [self presentViewController:commentsVc animated:YES completion:nil];

}


//Open comments page here
-(void)opneCommentsPage:(UIButton*)sender{
     int tag = (int)((UIButton *)(UIControl *)sender).tag;
   
    NSString * captionId=[cmtMediaId objectAtIndex:tag];
    
    if (commentsVc) {
        commentsVc=nil;
    }
    commentsVc=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    commentsVc.capId=captionId;
    commentsVc.feedImage = image;
    commentsVc.resultDict = nil;
    commentsVc.index = tag;
    [self presentViewController:commentsVc animated:YES completion:nil];
}



-(void)firedNotification {
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
         self.dic.annotation = [NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"];
        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
  
        //[self.dic presentPreviewAnimated:YES];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark- likeFeedAction

-(void)likeFeedAction:(UIButton *)sender{
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    NSURL * url;
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
   
//        https://api.instagram.com/v1/media/{media-id}/likes
    url=[NSURL  URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/media/%@/likes?",cmtMediaId[sender.tag]]];

    NSMutableURLRequest * getRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    if ([[userLiked objectAtIndex:sender.tag] isEqualToNumber:[NSNumber numberWithInt:1]]) {
         [getRequest setHTTPMethod:@"DELETE"];
    }
    else{
         [getRequest setHTTPMethod:@"POST"];
    }
   
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString * body =[NSString stringWithFormat:@"access_token=%@",access_token];
    [getRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
       // [self loadFeeds];
        NSLog(@"%@",[[SingletonClassIboard shareSinglton].likesCount objectAtIndex:[sender tag]]);
     int i  =[[[SingletonClassIboard shareSinglton].likesCount objectAtIndex:[sender tag]]intValue];
        i=  i+1;
        [[SingletonClassIboard shareSinglton].likesCount replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithInt:i]];
        [userLiked replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithInt:1]];
        [feedTableView reloadData];
    }
    NSLog(@"Like  %@",response);

}

#pragma mark- delegate methods of bannerview

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
    NSLog(@"Ad received");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    
    NSLog(@"Failed to receive");
}


@end
