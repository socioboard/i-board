

#import "FeedViewController.h"
#import "SingletonClass.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "UserProfileViewController.h"
#import "CommentsViewController.h"

@interface FeedViewController ()
{
    UIView * popView;
    NSMutableDictionary * commentsDic;
     UserProfileViewController * userProfile;
    NSMutableArray * cmtTextArr,* cmtUserImgArr,* cmtUserName,*cmtMediaId;
    UITableView * commentsTbl;
    CommentsViewController * commentsVc;
    UILabel * noInternetConnnection;
    
    BOOL inAnimation;
    CALayer *waveLayer;
}
@end

@implementation FeedViewController
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



-(void)waveAnimation:(CALayer*)aLayer
{
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = 1;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnimation.removedOnCompletion = YES;
    transformAnimation.fillMode = kCAFillModeRemoved;
    [aLayer setTransform:CATransform3DMakeScale( 10, 10, 1.0)];
    [transformAnimation setDelegate:self];
    
    CATransform3D xform = CATransform3DIdentity;
    xform = CATransform3DScale(xform, 40, 40, 1.0);
    transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
    [aLayer addAnimation:transformAnimation forKey:@"transformAnimation"];
    
    
    UIColor *fromColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:1];
    UIColor *toColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 1;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    [aLayer addAnimation:colorAnimation forKey:@"colorAnimationBG"];
    
    
    UIColor *fromColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
    UIColor *toColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation1 = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation1.duration = 1;
    colorAnimation1.fromValue = (id)fromColor1.CGColor;
    colorAnimation1.toValue = (id)toColor1.CGColor;
    
    [aLayer addAnimation:colorAnimation1 forKey:@"colorAnimation"];
}

-(void)startAnimation
{
    if (inAnimation == YES)
  {
        return;
    }
    inAnimation = YES;
    [self waveAnimation:waveLayer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    inAnimation = NO;
    [self performSelectorInBackground:@selector(startAnimation) withObject:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    waveLayer=[CALayer layer];
    waveLayer.frame = CGRectMake(150, 200, 10, 10);
    
    //waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius =5.0;
    [self.view.layer addSublayer:waveLayer];
    
    

    [SingletonClass shareSinglton].commentsCount=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].likesCount=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedPic=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedUserPic=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedUserName=[[NSMutableArray alloc]init];
    cmtMediaId=[[NSMutableArray alloc]init];
    userId=[[NSMutableArray alloc]init];
   
    windowSize=[UIScreen mainScreen].bounds.size;
    
    activityView =[[UIActivityIndicatorView alloc]init];
    activityView.frame=CGRectMake(windowSize.width/2-20, windowSize.height/2-50, 40, 40);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityView.color=[UIColor whiteColor];
    activityView.alpha=1.0;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
   
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUI) name:@"loadFeeds" object:nil];
    NSString * firstRun=[[NSUserDefaults standardUserDefaults]objectForKey:@"firstRun"];
    if (!firstRun) {
        [self loadUI];
         [activityView startAnimating];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [self loadUI];
    }
    // Do any additional setup after loading the view from its nib.
}




-(void)loadUI{
     [feedTableView removeFromSuperview];
     [activityView startAnimating];
   
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    //self.view.backgroundColor=[UIColor whiteColor];
   // waveLayer.hidden=NO;
   // inAnimation=NO;
   // [self startAnimation];
    

    
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClass shareSinglton].isActivenetworkConnection==YES) {
   
    dispatch_async(dispatch_get_global_queue(0, 0),^{
            [self loadFeeds];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityView stopAnimating];
            
            [self creatUI];
           // inAnimation=NO;
           // waveLayer.hidden=YES;
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

-(void)creatUI{

    
    if(feedTableView)
    {
        feedTableView=nil;
    }
    feedTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height-20) style:UITableViewStylePlain];
    feedTableView.dataSource=self;
    feedTableView.delegate=self;
    feedTableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:feedTableView];
    
    UIView * feedFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 20)];
    feedFooter.backgroundColor=[UIColor clearColor];
    feedTableView.tableFooterView=feedFooter;
}


#pragma mark-TableView delegate methods

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,40)];
    footerView.backgroundColor=[UIColor colorWithRed:(CGFloat)180/255 green:(CGFloat)180/255 blue:(CGFloat)180/255 alpha:(CGFloat)1];
    
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
            }
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
        //cell.contentView.layer.shadowPath=path.CGPath;
    
    NSURL * url=[NSURL URLWithString:[[SingletonClass shareSinglton].feedUserPic objectAtIndex:indexPath.section]];
    NSData * imageData=[NSData dataWithContentsOfURL:url];
    cell.feedsUserImage.image=[UIImage imageWithData:imageData];
    
    cell.feedsUsername.text=[[SingletonClass shareSinglton].feedUserName objectAtIndex:indexPath.section];

    
    NSURL * urlFeed=[NSURL URLWithString:[[SingletonClass shareSinglton].feedPic objectAtIndex:indexPath.section]];

    
    [cell.feedImage sd_setImageWithURL:urlFeed];
    
        cell.likesBtn.tag=indexPath.section;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
    cell.likesCount.text=[NSString stringWithFormat:@"%@",[[SingletonClass shareSinglton].likesCount objectAtIndex:indexPath.section]];
    [cell.commentCnt setTitle:[NSString stringWithFormat:@"%@",[[SingletonClass shareSinglton].commentsCount objectAtIndex:indexPath.section]] forState:UIControlStateNormal];
    cell.add_minusButton.hidden=YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewController alloc]initWithNibName:@"UserProfileViewController" bundle:nil];
    userProfile.userId=[userId objectAtIndex:indexPath.section];
    [self presentViewController:userProfile animated:YES completion:nil];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [SingletonClass shareSinglton].feedPic.count;
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
    CGFloat height;
    if (tableView==feedTableView) {
        if ([[UIScreen mainScreen] bounds].size.height == 736.0) {
            height=300;
        }
        else{
            height=250;
        }
      return height;
    }
    
    return height;
}



#pragma mark- load Feeds
// Api call for showing user home feeds

-(void)loadFeeds{
    [[SingletonClass shareSinglton].commentsCount removeAllObjects];
    [[SingletonClass shareSinglton].likesCount removeAllObjects ];
    [[SingletonClass shareSinglton].feedPic removeAllObjects];
    [[SingletonClass shareSinglton].feedUserPic removeAllObjects];
    [[SingletonClass shareSinglton].feedUserName removeAllObjects];

    [cmtMediaId removeAllObjects];
    [userId removeAllObjects];
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    NSURL * url;
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (pagination) {
         url=[NSURL  URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/users/self/feed?access_token=%@&next_max_id=%@",access_token,nextMaxId]];
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
    NSLog(@"Feeds  %@",response);
    NSMutableDictionary * dict=[response objectForKey:@"meta"];
     pagination=[response objectForKey:@"next_url"];
    nextMaxId=[response objectForKey:@"next_max_id"];
    if ([[dict objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSArray * dataArr=[response objectForKey:@"data"];
        commentsDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * likesDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * imagesDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * captionDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * mainDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * fromDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * stdDic=[NSMutableDictionary dictionary];
    
        
       
        for (int i=0; i<dataArr.count; i++) {
            mainDic=[dataArr objectAtIndex:i];
             captionDic=[mainDic objectForKey:@"caption"];
                        if ( captionDic != [ NSNull null ]) {
               
                fromDic=[captionDic objectForKey:@"from"];
                [[SingletonClass shareSinglton].feedUserPic addObject:[fromDic objectForKey:@"profile_picture"]];
                [[SingletonClass shareSinglton].feedUserName addObject:[fromDic objectForKey:@"full_name"]];
                
                [userId addObject:[fromDic objectForKey:@"id"]];
            
                commentsDic=[mainDic objectForKey:@"comments"];
                [[SingletonClass shareSinglton].commentsCount addObject:[commentsDic objectForKey:@"count"]];
             
                
                            
                //================= get all feed images and there respective id's.
                [cmtMediaId addObject:[mainDic objectForKey:@"id"]];

                imagesDic=[mainDic objectForKey:@"images"];
                stdDic=[imagesDic objectForKey:@"low_resolution"];
                
                [[SingletonClass shareSinglton].feedPic addObject:[stdDic objectForKey:@"url"]];
                
                likesDic=[mainDic objectForKey:@"likes"];
                [[SingletonClass shareSinglton].likesCount addObject:[likesDic objectForKey:@"count"]];
                          
            }
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
    [self presentViewController:commentsVc animated:YES completion:nil];
}



-(void)firedNotification {
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClass shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
        //[self.dic presentPreviewAnimated:YES];
        
    }
    
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
