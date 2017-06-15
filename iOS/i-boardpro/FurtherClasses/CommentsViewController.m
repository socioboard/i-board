

#import "CommentsViewController.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "SingletonClassIboard.h"

@interface CommentsViewController ()
{
    UILabel * noComments;
}
@end

@implementation CommentsViewController
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
    [super viewDidLoad];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    // Create header View and title and back button here.
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 55)];
    
    self.headerView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:self.headerView];
    self.headerView.layer.shadowRadius = 5.0;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.6;
    self.headerView.layer.shadowOffset = CGSizeMake(0.0f,5.0f);
    self.headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.headerView.bounds].CGPath;
    
    UILabel *titltLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 25, windowSize.width-120, 25)];
    titltLabel.text=@"Comments";
    titltLabel.textColor=[UIColor whiteColor];
    titltLabel.font=[UIFont boldSystemFontOfSize:15];
    titltLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titltLabel];
    
    UIButton * cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(15, 25, 50, 25);
    cancelButton.layer.cornerRadius=5;
    cancelButton.clipsToBounds=YES;
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
    
     self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self fetchComments:self.capId];
        dispatch_async(dispatch_get_main_queue(),^{
           
            [self createTable];
        });
    });
    // Do any additional setup after loading the view from its nib.
}

-(void)cancelButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// create comments Table here
-(void)createTable{
    [noComments removeFromSuperview];
    [commentsTbl removeFromSuperview];
   /* if (cmtTextArr.count<1) {
        noComments=[[UILabel alloc]initWithFrame:CGRectMake(40, windowSize.height/2-30, windowSize.width-60, 50)];
        noComments.text=@"No comments are there..!";
        noComments.textAlignment=NSTextAlignmentCenter;
        noComments.font=[UIFont boldSystemFontOfSize:13];
        noComments.textColor=[UIColor blackColor];
        [self.view addSubview:noComments];
    }
    else{*/
    
    if (commentsTbl) {
            commentsTbl=nil;
        }
        //commentsTbl=[[UITableView alloc]initWithFrame:CGRectMake(20, 55, windowSize.width-40,windowSize.height-105) style:UITableViewStylePlain];
    commentsTbl=[[UITableView alloc]initWithFrame:CGRectMake(20, 55, windowSize.width-40,windowSize.height-55) style:UITableViewStylePlain];
        commentsTbl.delegate=self;
        commentsTbl.dataSource=self;
        commentsTbl.separatorStyle=UITableViewCellSeparatorStyleNone;
        commentsTbl.showsVerticalScrollIndicator = NO;
        
    //if (cmtTextArr.count>3) {
        commentsTbl.scrollEnabled=YES;
   // }
   // else{
   //     commentsTbl.scrollEnabled=NO;
   // }

    [self.view addSubview:commentsTbl];
    
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

   // }
}


#pragma mark- Tableview delegate methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell =(TableCustomCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.shadowOpacity = 0.4f;
        cell.contentView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        cell.contentView.layer.shadowRadius = 10.0f;
        cell.contentView.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds];
        cell.layer.shadowPath = path.CGPath;
        cell.topView.hidden = NO;
    }
   
    if (indexPath.section == 0) {
        NSLog(@"index number %d", self.index);
        if (self.resultDict  != nil) {
            
            NSURL * url=[NSURL URLWithString:[[self.resultDict objectForKey:@"user"]objectForKey:@"profile_picture"]];
            
            [cell.feedsUserImage sd_setImageWithURL:url];
            cell.feedsUsername.text=[[self.resultDict objectForKey:@"user"]objectForKey:@"username"];
            
            
            NSURL * urlFeed=[NSURL URLWithString:[[[self.resultDict objectForKey:@"images"]objectForKey:@"low_resolution"]objectForKey:@"url"]];
            
            
            [cell.feedImage sd_setImageWithURL:urlFeed];
            cell.feedImage.frame = CGRectMake(20, 70, commentsTbl.frame.size.width-40, self.feedImage.size.height-60);
            cell.topView.frame = CGRectMake(0, 0, commentsTbl.frame.size.width, 50);


        }
        else{
        
        NSURL * url=[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedUserPic objectAtIndex:self.index]];
        [cell.feedsUserImage sd_setImageWithURL:url];
        
        cell.feedsUsername.text=[[SingletonClassIboard shareSinglton].feedUserName objectAtIndex:self.index];
        
        [cell.feedImage sd_setImageWithURL:[NSURL URLWithString:[[SingletonClassIboard shareSinglton].feedPic objectAtIndex:self.index]]];
        cell.feedImage.frame = CGRectMake(20, 70, commentsTbl.frame.size.width-40, self.feedImage.size.height-60);
        cell.topView.frame = CGRectMake(0, 0, commentsTbl.frame.size.width, 50);
        }
    }
    else{
        
        CGFloat   height = [self labelHeightWithText:[cmtTextArr objectAtIndex:indexPath.row]];
        if (height<75) {
            height=75;
        }
        cell.cmtTxtView.frame=CGRectMake(80, 20, windowSize.width-120, height);
        cell.cmtTxtView.text=[cmtTextArr objectAtIndex:indexPath.row];
        cell.cmtTxtView.backgroundColor=[UIColor clearColor];
        
        cell.commentBtn.hidden=YES;
        cell.likesBtn.hidden=YES;
    
        NSURL * url=[NSURL URLWithString:[cmtUserImgArr objectAtIndex:indexPath.row]];
        [cell.cmtUserImage sd_setImageWithURL:url];
        cell.add_minusButton.hidden=YES;
        cell.cmtUserName.text=[cmtUserName objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(section==0)
   {
       return 1;
   }
   else{
        if (cmtTextArr.count<1) {
            return 0;
        }
        return cmtTextArr.count;
   }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==  0) {
         return self.feedImage.size.height+50;
    }
    else{
       // set dynamic height of row
       CGFloat height = [self labelHeightWithText:[cmtTextArr objectAtIndex:indexPath.row]];
        if (height<100) {
            height=100;
        }
        return height;

    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,40)];
    footerView.backgroundColor=[UIColor colorWithRed:(CGFloat)180/255 green:(CGFloat)180/255 blue:(CGFloat)180/255 alpha:(CGFloat)1];
    
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return  0;
}

//Find dynamic heght of row

-(CGFloat)labelHeightWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    label.numberOfLines = 0;
    label.textAlignment=NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame = CGRectMake(0, 0, 280, 100);
    [label sizeToFit];
    // CGSize size  = [label sizeThatFits:CGSizeMake(280, FLT_MAX)];
    return label.frame.size.height;
}




// api call for fetching all commenets of selected feed on the basis of feed Id 
-(void)fetchComments:(NSString *)capId{
    NSError * error;
    NSURLResponse * urlResponse;
    
    cmtTextArr=[[NSMutableArray alloc]init];
    cmtUserImgArr=[[NSMutableArray alloc]init];
    cmtUserName=[[NSMutableArray alloc]init];
    
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments?access_token=%@",capId,accessToken]];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (!data) {
        return;
    }
    id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Data for comments %@",json);
    
    NSArray * cmtDataArr=[json objectForKey:@"data"];
    NSMutableDictionary * cmtTextDic=[NSMutableDictionary dictionary];
    NSMutableDictionary * cmtFromDic=[NSMutableDictionary dictionary];
    for (int i=0; i<cmtDataArr.count; i++) {
        cmtTextDic=[cmtDataArr objectAtIndex:i];
        [cmtTextArr addObject:[cmtTextDic objectForKey:@"text"]];
        
        cmtFromDic=[cmtTextDic objectForKey:@"from"];
        [cmtUserName addObject:[cmtFromDic objectForKey:@"username"]];
        [cmtUserImgArr addObject:[cmtFromDic objectForKey:@"profile_picture"]];
        
    }
    
}


-(void)firedNotification {
    
    [[SingletonClassIboard shareSinglton]shareImageToInstagramFromController:self];
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
//    
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
//    }
    
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
