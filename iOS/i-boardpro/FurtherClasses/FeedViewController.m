//
//  FeedViewController.m
//  TwitterBoard
//
//  Created by Sumit Ghosh on 19/04/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

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
}
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    [SingletonClass shareSinglton].commentsCount=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].likesCount=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedPic=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedUserPic=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].feedUserName=[[NSMutableArray alloc]init];

    
   
    windowSize=[UIScreen mainScreen].bounds.size;
    
    activityView =[[UIActivityIndicatorView alloc]init];
    activityView.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityView.color=[UIColor whiteColor];
    activityView.alpha=1.0;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUI) name:@"loadFeeds" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI{
    
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self loadFeeds];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityView stopAnimating];
            [self creatUI];
        });
    });
    

}

-(void)creatUI{
    if(feedTableView)
    {
        feedTableView=nil;
    }
    feedTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-20) style:UITableViewStylePlain];
    feedTableView.dataSource=self;
    feedTableView.delegate=self;
    feedTableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:feedTableView];
}


#pragma mark-TableView delegate methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell =(TableCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
    }
    if (feedTableView==tableView) {
        
        [cell.commentBtn addTarget:self action:@selector(opneCommentsPage:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentBtn.tag=indexPath.row;
         
    
    NSURL * url=[NSURL URLWithString:[[SingletonClass shareSinglton].feedUserPic objectAtIndex:indexPath.row]];
    NSData * imageData=[NSData dataWithContentsOfURL:url];
    cell.userImage.image=[UIImage imageWithData:imageData];
    
    cell.userNameDesc.text=[[SingletonClass shareSinglton].feedUserName objectAtIndex:indexPath.row];

    
    NSURL * urlFeed=[NSURL URLWithString:[[SingletonClass shareSinglton].feedPic objectAtIndex:indexPath.row]];

    
    [cell.feedImage sd_setImageWithURL:urlFeed];
    
    
    cell.likesLbl.text=@"Likes";
    
     
    cell.likesCount.text=[NSString stringWithFormat:@"%@",[[SingletonClass shareSinglton].likesCount objectAtIndex:indexPath.row]];
    cell.commentCnt.text=[NSString stringWithFormat:@"%@",[[SingletonClass shareSinglton].commentsCount objectAtIndex:indexPath.row]];
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
    userProfile.userId=[userId objectAtIndex:indexPath.row];
    [self presentViewController:userProfile animated:YES completion:nil];
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==feedTableView)
    {
        return [SingletonClass shareSinglton].feedPic.count;
    }
   else if (tableView==commentsTbl) {
       if (cmtTextArr.count<1) {
           return 0;
       }
       return cmtTextArr.count;
    }
   else{
       return 0;
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (tableView==feedTableView) {
        height=250;
      return height;
    }
    
    return height;
}



#pragma mark- load Feeds
// Api call for showing user home feeds

-(void)loadFeeds{
    
   
    cmtMediaId=[[NSMutableArray alloc]init];
    userId =[[NSMutableArray alloc]init];
    
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
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
