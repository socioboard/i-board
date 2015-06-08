

#import "FollwViewController.h"
#import "TableCustomCell.h"
#import "SingletonClass.h"
#import "UserProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface FollwViewController ()
{
    UserProfileViewController * userProfile;
    UIActivityIndicatorView * activityIndicator;
    UILabel * noInternetConnnection;
    CGSize winsowSize;
}
@end

@implementation FollwViewController
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
    //self.isAddMoreJokes = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    winsowSize=[UIScreen mainScreen].bounds.size;
   
    
    [SingletonClass shareSinglton].follower=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].full_name=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].profile_picture=[[NSMutableArray alloc]init];
    usreId=[[NSMutableArray alloc]init];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(winsowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor whiteColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createFollowByTable) name:@"loadAllFollowers" object:nil];

}


//create  follow Table View if Data available


-(void)createFollowByTable
{
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)128/255 green:(CGFloat)128/255 blue:(CGFloat)128/255 alpha:1.0];
    
    [followTableView removeFromSuperview];
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClass shareSinglton].isActivenetworkConnection==YES) {

    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self loadAllFollowers];// call LoadAllFollwers method
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            if ([SingletonClass shareSinglton].full_name.count<1) {
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
                followTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, winsowSize.width,winsowSize.height) style:UITableViewStylePlain];
                followTableView.dataSource=self;
                followTableView.delegate=self;
                followTableView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:followTableView];
                UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, winsowSize.width, 40)];
                view.backgroundColor=[UIColor clearColor];
                followTableView.tableFooterView=view;
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
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [cell.add_minusButton addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.add_minusButton.tag=indexPath.row;
        [cell.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
    }
      cell.commentBtn.hidden=YES;
     cell.likesBtn.hidden=YES;


    [cell.userImage sd_setImageWithURL:[[SingletonClass shareSinglton].profile_picture objectAtIndex:indexPath.row]];
    
    cell.userNameDesc.text=[[SingletonClass shareSinglton].full_name objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userProfile) {
        userProfile=nil;
    }
    userProfile=[[UserProfileViewController alloc]initWithNibName:@"UserProfileViewController" bundle:nil];
    userProfile.userId=[usreId objectAtIndex:indexPath.row];
    [self presentViewController:userProfile animated:YES completion:nil];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [SingletonClass shareSinglton].full_name.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark- unfollow action

// call unfollow api here
-(void)unfollowAction:(UIButton *)sender{
     int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * userIDStr=[usreId  objectAtIndex:tag];
    
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
    [self loadAllFollowers];
    [followTableView reloadData];
    
}





#pragma  mark-  load Followers
// get all following user
-(void)loadAllFollowers{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
    [[SingletonClass shareSinglton].follower removeAllObjects];
    [[SingletonClass shareSinglton].full_name removeAllObjects];
    [[SingletonClass shareSinglton].profile_picture removeAllObjects];
    [usreId removeAllObjects];
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
        [usreId addObject:[dict objectForKey:@"id"]];
    }
    
}



-(void)firedNotification {
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
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
