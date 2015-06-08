

#import "MutualFriendsViewController.h"
#import "SingletonClass.h"
#import "TableCustomCell.h"
#import "UserProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface MutualFriendsViewController ()
{
    NSMutableArray * userId,* full_name,*profilePic;
    UserProfileViewController* userProfile;
     UIActivityIndicatorView * activityIndicator;
    UILabel * noInternetConnnection;
}
@end

@implementation MutualFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    full_name=[[NSMutableArray alloc]init];
    profilePic=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createUI) name:@"showMutualFrnds" object:nil];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor whiteColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    // Do any additional setup after loading the view from its nib.
}



-(void)createUI{
  
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    [mutualTbl removeFromSuperview];
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClass shareSinglton].isActivenetworkConnection==YES) {

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
    if (full_name.count<1) {
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
    mutualTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width,windowSize.height)];
    
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
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.add_plusButton.hidden=YES;
        cell.add_minusButton.hidden=YES;
        //cell.add_minusButton.tag=indexPath.row;
       // [cell.add_minusButton addTarget:self action:@selector(unfollowActions:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.commentBtn.hidden=YES;
     cell.likesBtn.hidden=YES;
    
   [cell.userImage sd_setImageWithURL:[profilePic objectAtIndex:indexPath.row]];
    
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
    
    return userId.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}




#pragma mark- get all fans from here

-(void)compareTogetMutualFrnds{
    userId=[[NSMutableArray alloc]init];
    
  
        [self loadAllFollowedBy];
        [self loadAllFollowers];
  
    
    [full_name removeAllObjects];
    [profilePic removeAllObjects];
        NSMutableArray * checkId=[[NSMutableArray alloc]init];
        NSMutableDictionary * followDict=[NSMutableDictionary dictionary];
        NSMutableDictionary * followedByDict=[NSMutableDictionary dictionary];
        
        NSLog(@"Follow Dic %@",[SingletonClass shareSinglton].follower);
        NSLog(@"Follow By Dic %@",[SingletonClass shareSinglton].followeBy);
        
        for (int i=0; i<[SingletonClass shareSinglton].follower.count; i++) {
            BOOL isAvail=NO;
            followDict=[[SingletonClass shareSinglton].follower objectAtIndex:  i];
            for (int j=0; j<[SingletonClass shareSinglton].followeBy.count; j++) {
                
                
                followedByDict=[[SingletonClass shareSinglton].followeBy objectAtIndex:j];
                
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
            
        }
        
    }
//}




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
        
        [[SingletonClass shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
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
        [[SingletonClass shareSinglton].full_name addObject:[dict objectForKey:@"username"]];
        [[SingletonClass shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
        
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
