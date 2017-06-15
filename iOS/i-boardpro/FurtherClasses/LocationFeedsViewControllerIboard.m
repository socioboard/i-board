//
//  LocationFeedsViewControllerIboard.m
//  i-boardpro
//
//  Created by GBS-ios on 9/18/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "LocationFeedsViewControllerIboard.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "SingletonClassIboard.h"
#import "HelperClassIboard.h"
#import "UserProfileViewControllerIboard.h"
#import "CommentsViewController.h"

@interface LocationFeedsViewControllerIboard ()
{
    
    UITableView * detailTable;
    CGSize windowSize;
    UIActivityIndicatorView * activityIndicator,*loadActivityView;
    NSMutableArray * resultArr;
    UIImage * image;
    NSData * imagesSize;
    NSMutableArray * alreadyFollowingUser;
    UserProfileViewControllerIboard *userProfile;
    CommentsViewController * commentsVc;
    NSMutableArray * likesCount,*userLiked;
    UILabel * noInternetConnnection;
    
}
@property (nonatomic,strong)UIView * headerView;

@end

@implementation LocationFeedsViewControllerIboard

- (void)viewDidLoad {
    [super viewDidLoad];
   
    likesCount=[[NSMutableArray alloc]init];
    userLiked = [[NSMutableArray alloc]init];
    
    alreadyFollowingUser =[[NSMutableArray alloc]init];
    
    self.isAddMoreJokes = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    
    resultArr =[[NSMutableArray alloc]init];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 55)];
    
    self.headerView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:self.headerView];
    
    
    activityIndicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(windowSize.width/2-20, windowSize.height/2-50, 40, 40)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.alpha = 1.0;
    activityIndicator.color = [UIColor blackColor];
    [self.view addSubview:activityIndicator];
    
    self.headerView.layer.shadowRadius = 5.0;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.6;
    self.headerView.layer.shadowOffset = CGSizeMake(0.0f,5.0f);
    self.headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.headerView.bounds].CGPath;
    
    UILabel * titleLable =[[UILabel alloc]initWithFrame:CGRectMake(60, 20, windowSize.width-120, 30)];
    titleLable.text =[self.resultDict objectForKey:@"name"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    titleLable.textColor =[UIColor whiteColor];
    [self.headerView addSubview:titleLable];
    
    UIButton * cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(10, 25, 50, 25);
    cancelButton.layer.cornerRadius=5;
    cancelButton.clipsToBounds=YES;
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
   [self loadService];
    // Do any additional setup after loading the view.
}

#pragma mark- init Method
-(id)initWithDictionary:(NSDictionary*)dict{
    self =[super init];
    if (self) {
         self.resultDict =[[NSDictionary alloc]init];
        self.resultDict = dict;
    }
    return  self;
}



#pragma mark- createUI

-(void)loadService{
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self getAllFeedsBylocation];
        if (resultArr.count>0) {
            
            
            NSURL * urlFeed=[NSURL URLWithString:[[[[resultArr objectAtIndex:0]objectForKey:@"images"]objectForKey:@"low_resolution"]objectForKey:@"url"]];
            imagesSize =[NSData dataWithContentsOfURL:urlFeed];
            image = [UIImage imageWithData:imagesSize];
        }
        else{
            
            [activityIndicator stopAnimating];
            if (noInternetConnnection) {
                [noInternetConnnection removeFromSuperview];
                noInternetConnnection=nil;
            }
            noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
            noInternetConnnection.text=@"No media found.!";
            noInternetConnnection.textAlignment=NSTextAlignmentCenter;
            noInternetConnnection.numberOfLines=0;
            noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
            [self.view addSubview:noInternetConnnection];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            if (resultArr.count>0) {
                [self createUI];
            }
            
        });
    });
    
    
}

-(void)createUI{
    
    detailTable =[[UITableView alloc]initWithFrame:CGRectMake(20, 55,windowSize.width-40 ,windowSize.height-40)];
    detailTable.delegate = self;
    detailTable.dataSource = self;
    detailTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:detailTable];
    
    UIView * feedFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 20)];
    feedFooter.backgroundColor=[UIColor clearColor];
    detailTable.tableFooterView=feedFooter;
    
    
    
    loadActivityView =[[UIActivityIndicatorView alloc]init];
    loadActivityView.frame=CGRectMake(feedFooter.frame.size.width/2-20, 0, 40, 40);
    loadActivityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    loadActivityView.color=[UIColor blackColor];
    loadActivityView.alpha=1.0;
    [feedFooter addSubview:loadActivityView];
    
}


#pragma mark - tableDelegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  resultArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell =(TableCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.add_plusButton setBackgroundImage:[UIImage imageNamed:@"iboard-follow_btn.png"] forState:UIControlStateNormal];
        [cell.add_plusButton addTarget:self action:@selector(followActions:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.commentBtn addTarget:self action:@selector(opneCommentsPage:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.commentCnt addTarget:self action:@selector(opneCommentsPage:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.likesBtn addTarget:self action:@selector(likeFeedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (detailTable==tableView) {
        cell.add_plusButton.tag = indexPath.section;
        cell.commentBtn.tag  = indexPath.section;
        cell.commentCnt.tag = indexPath.section;
        cell.likesBtn.tag = indexPath.section;
        
        
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.shadowOpacity = 0.4f;
        cell.contentView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        cell.contentView.layer.shadowRadius = 10.0f;
        cell.contentView.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds];
        cell.layer.shadowPath = path.CGPath;
        
        
        NSURL * url=[NSURL URLWithString:[[[resultArr objectAtIndex:indexPath.section]objectForKey:@"user"]objectForKey:@"profile_picture"]];
        
        [cell.feedsUserImage sd_setImageWithURL:url];
        cell.feedsUsername.text=[[[resultArr objectAtIndex:indexPath.section]objectForKey:@"user"]objectForKey:@"username"];
        
        
        NSURL * urlFeed=[NSURL URLWithString:[[[[resultArr objectAtIndex:indexPath.section]objectForKey:@"images"]objectForKey:@"low_resolution"]objectForKey:@"url"]];
        
        
        [cell.feedImage sd_setImageWithURL:urlFeed];
        
        cell.likesBtn.tag=indexPath.section;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.likesCount.text=[NSString stringWithFormat:@"%@",[likesCount objectAtIndex:indexPath.section]];
        [cell.commentCnt setTitle:[NSString stringWithFormat:@"%@",[[[resultArr objectAtIndex:indexPath.section]objectForKey:@"comments"]objectForKey:@"count"]] forState:UIControlStateNormal];
        cell.add_minusButton.hidden=YES;
        
        cell.topView.frame = CGRectMake(0, 0, detailTable.frame.size.width, 50);
        cell.feedImage.frame = CGRectMake(20, 70, detailTable.frame.size.width-40, image.size.height-60);
        cell.bottomView.frame = CGRectMake(0, image.size.height+20, detailTable.frame.size.width, 30);
        cell.likesBtn.frame =CGRectMake(20, 7, 15, 15);
        cell.likesCount.frame=CGRectMake(38,  7, 50, 20);
        cell.commentBtn.frame = CGRectMake(detailTable.frame.size.width-60,7, 15, 20);
        cell.commentCnt.frame =CGRectMake(detailTable.frame.size.width-40, 7, 50, 20);
        cell.commentCnt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.add_plusButton.frame = CGRectMake(cell.topView.frame.size.width-50, 5, 40, 40);
        
   
        
        if ([[userLiked objectAtIndex:indexPath.section] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [cell.likesBtn setBackgroundImage:[UIImage imageNamed:@"iboard-like_active.png"] forState:UIControlStateNormal];
        }
        else{
            
            [cell.likesBtn setBackgroundImage:[UIImage imageNamed:@"iboard-like.png"] forState:UIControlStateNormal];
        }
        
        
        if (indexPath.section %5 == 0 ) {
            cell.bannerView.frame =  CGRectMake(0, image.size.height+20+30+10, detailTable.frame.size.width, 50);
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section % 5 == 0) {
       // return  image.size.height+110;
    }
    
    return image.size.height+50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewControllerIboard alloc]initWithNibName:@"UserProfileViewControllerIboard" bundle:nil];
    userProfile.userId=[[[resultArr objectAtIndex:indexPath.section]objectForKey:@"user"]objectForKey:@"id"];
    [self presentViewController:userProfile animated:YES completion:nil];
    
}

#pragma mark- get all feeds

-(void)getAllFeedsBylocation{

    id jsonResponse =[HelperClassIboard getAllRecentMediaFromLocation:pagination mediaId:[self.resultDict objectForKey:@"id"]];

    if ([[[jsonResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSArray * dataArr = [jsonResponse objectForKey:@"data"];
        for (int i =0; i< dataArr.count; i++) {
            [resultArr addObject:[dataArr objectAtIndex:i]];
            [likesCount addObject:[[[resultArr objectAtIndex:i]objectForKey:@"likes"]objectForKey:@"count"]];
            [userLiked addObject:[[resultArr objectAtIndex:i] objectForKey:@"user_has_liked"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark- likeFeedAction

-(void)likeFeedAction:(UIButton *)sender{
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    NSURL * url;
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    
    url=[NSURL  URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/media/%@/likes?",[[resultArr objectAtIndex:sender.tag]objectForKey:@"id"]]];
    
    NSMutableURLRequest * getRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    if ([[[resultArr objectAtIndex:sender.tag]objectForKey:@"user_has_liked"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        // if ([[userLiked objectAtIndex:sender.tag] isEqualToNumber:[NSNumber numberWithInt:1]]) {
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
        NSLog(@"%@",[[[resultArr objectAtIndex:sender.tag]objectForKey:@"likes"]objectForKey:@"count"]);
        int i =  [[likesCount objectAtIndex:[sender tag]]intValue];
        i = i+1;
        [likesCount replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:i]];
        [userLiked replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithInt:1]];
        
        [detailTable reloadData];
    }
    NSLog(@"Like  %@",response);
    
}

//Open comments page here
-(void)opneCommentsPage:(UIButton*)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
    
    NSString * captionId=[[resultArr objectAtIndex:tag]objectForKey:@"id"];
    
    if (commentsVc) {
        commentsVc=nil;
    }
    commentsVc=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    commentsVc.capId=captionId;
    commentsVc.feedImage = image;
    commentsVc.resultDict = [resultArr objectAtIndex:tag];
    commentsVc.index = tag;
    [self presentViewController:commentsVc animated:YES completion:nil];
}


#pragma mark- follow action

-(void)followActions:(UIButton *)sender{
    
    NSString * userIDStr=[[[resultArr objectAtIndex:sender.tag]objectForKey:@"user"]objectForKey:@"id"];
    
    NSString *username=[[[resultArr objectAtIndex:sender.tag]objectForKey:@"user"]objectForKey:@"username"];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Info !!!"
                                  message:[NSString stringWithFormat:@"Are you sure you want to follow  %@",username]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             id response=[HelperClassIboard followActions:userIDStr];
                             if ([[[response objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                                 
                                 [alreadyFollowingUser addObject:userIDStr];
                                 [resultArr removeObjectAtIndex:sender.tag];
                                 [detailTable reloadData];
                                 
                                 UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Now you are following %@ ",username] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 [alertView show];
                             }
                             
                             
                             else{
                                 
                                 UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alertView show];
                                 
                                 
                                 
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
