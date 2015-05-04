//
//  NonFollowerViewController.m
//  Board
//
//  Created by Sumit Ghosh on 23/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "NonFollowerViewController.h"
#import "SingletonClass.h"
#import "TableCustomCell.h"
#import "UserProfileViewController.h"

@interface NonFollowerViewController ()
{
    NSMutableArray * userId;
    UserProfileViewController * userProfile;
    UIActivityIndicatorView * activityIndicator;
}
@end

@implementation NonFollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor whiteColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUI) name:@"loadNonFollower" object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI{
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    [nonFollowTbl removeFromSuperview];
    [activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        [self compareAndFetchNonFollowers];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            [self creatUI];
        });
        
    });
    
    
}

//create UI to show non followers
-(void)creatUI{
    
    if (full_name.count<1) {
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
    nonFollowTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height) style:UITableViewStylePlain];
    nonFollowTbl.dataSource=self;
    nonFollowTbl.delegate=self;
    nonFollowTbl.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nonFollowTbl];
    }
}



#pragma  mark- compareAndFetchNonFollowers
// get all non-followers
-(void)compareAndFetchNonFollowers{
    
    
    userId=[[NSMutableArray alloc]init];
    
    if ([SingletonClass shareSinglton].followeBy.count<1 &&  [SingletonClass shareSinglton].follower.count<1) {
        [self loadAllFollowedBy];
        [self loadAllFollowers];
        [self compareAndFetchNonFollowers];
    }
    else{
        NSMutableArray *  checkID=[[NSMutableArray alloc]init];
         full_name=[[NSMutableArray alloc]init];
         profilePic=[[NSMutableArray alloc]init];
        
        NSMutableDictionary * followDict=[NSMutableDictionary dictionary];
        NSMutableDictionary * followedByDict=[NSMutableDictionary dictionary];
        
        NSLog(@"Follow Dic %@",[SingletonClass shareSinglton].follower);
        NSLog(@"Follow By Dic %@",[SingletonClass shareSinglton].followeBy);
        
        for (int i=0; i<[SingletonClass shareSinglton].follower.count; i++) {
            followDict=[[SingletonClass shareSinglton].follower objectAtIndex:i];
            BOOL contain=NO;
            for (int j=0; j<[SingletonClass shareSinglton].followeBy.count; j++) {
                
                
                followedByDict=[[SingletonClass shareSinglton].followeBy objectAtIndex:j];
                
                if ([[followedByDict objectForKey:@"id"] isEqualToString:[followDict objectForKey:@"id"]]) {
                    contain=YES;
                }
               
            }
            if (contain==NO) {
                [full_name addObject:[followDict objectForKey:@"full_name"]];
                [profilePic addObject:[followDict objectForKey:@"profile_picture"]];
                [userId addObject:[followDict objectForKey:@"id"]];
            }
        }
        NSLog(@" count of non follow %lu",(unsigned long)full_name.count);
        
    }
}


#pragma  mark-  load Followers
-(void)loadAllFollowers{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
    [[SingletonClass shareSinglton].follower removeAllObjects];
    [[SingletonClass shareSinglton].full_name removeAllObjects];
    [[SingletonClass shareSinglton].profile_picture removeAllObjects];
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]];
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
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClass shareSinglton].follower addObject:dict];
        
        [[SingletonClass shareSinglton].full_name addObject:[dict objectForKey:@"full_name"]];
        [[SingletonClass shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
    }
    
}

#pragma  mark- load followed by

-(void)loadAllFollowedBy{
    NSURLResponse * urlResponse;
    NSError * error;
    
    [[SingletonClass shareSinglton].followeBy removeAllObjects];
    [[SingletonClass shareSinglton].full_name removeAllObjects];
    [[SingletonClass shareSinglton].profile_picture removeAllObjects];
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
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClass shareSinglton].followeBy addObject:dict];
        [[SingletonClass shareSinglton].full_name addObject:[dict objectForKey:@"full_name"]];
        [[SingletonClass shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
        
    }
}



#pragma mark- delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.add_minusButton.tag=indexPath.row;
        [cell.add_minusButton addTarget:self action:@selector(unfollowActions:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.commentBtn.hidden=YES;
    NSURL * url=[NSURL URLWithString:[profilePic objectAtIndex:indexPath.row]];
    NSData * imageData=[NSData dataWithContentsOfURL:url];
    cell.userImage.image=[UIImage imageWithData:imageData];
    
    cell.userNameDesc.text=[full_name objectAtIndex:indexPath.row];
    
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
    
    return full_name.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark- unfollow action

-(void)unfollowActions:(UIButton *)sender{
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * userIDStr=[userId  objectAtIndex:tag];
    
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
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@" response of unfollow %@",response);
    
    [self compareAndFetchNonFollowers];
    [nonFollowTbl reloadData];
    
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
