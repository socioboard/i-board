

#import "ViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "CustomMenuViewControllerIboard.h"
#import "FollwViewControllerIboard.h"
#import "FollowedByViewControllerIboard.h"
#import "ProfileViewControllerIboard.h"
#import "WebViewViewControllerIboard.h"
#import "FeedViewControllerIboard.h"
#import "PhotosViewControllerIboard.h"
#import "NonFollowerViewController.h"
#import "SingletonClassIboard.h"
#import "ScheduleViewControllerIboard.h"
#import "FansViewControllerIboard.h"
#import "MutualFriendsViewControllerIboard.h"
#import "deatilsOfSearchInstaViewControllerIboard.h"
#import "OverlappingViewController.h"
#import "SearchTagsViewControllerIboard.h"
#import "LocationSearchViewControllerIboard.h"

@interface ViewController ()
{
    CGSize  windowSize;
}
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    UIImageView * background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
    background.image=[UIImage imageNamed:@"iboard-main_view_new.png"];
    [self.view addSubview:background];
    
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if(access_token){
        NSLog(@"Accesstoken avail");
        [self retreiveDataFromSqlite];
        [self loginCheckComplete];
    }
    else{
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCheckComplete) name:@"loginCheckComplete" object:nil];
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20, self.view.frame.size.height-80, 290, 42);
        button.center= CGPointMake(CGRectGetMidX(self.view.frame), windowSize.height-80);
        
        
        [button setTitle:@"Connect to Instagram" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor blueColor];
        [button setBackgroundColor:[UIColor colorWithRed:(CGFloat)60/255 green:(CGFloat)111/255 blue:(CGFloat)151/255 alpha:(CGFloat)1]];
        button.layer.cornerRadius=7;
        button.clipsToBounds=YES;
        [button addTarget:self action:@selector(callWebView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


// Call WebView for login page


-(void)callWebView:(UIButton*)sender{
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==NO) {
        
    }
    else{
        WebViewViewControllerIboard *  webviewVC=[[WebViewViewControllerIboard alloc]init];
        [self presentViewController:webviewVC animated:YES completion:^{
        }];
    }
}

//Create  Custom menu list

-(void)loginCheckComplete
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginCheckComplete" object:nil];
    CustomMenuViewControllerIboard * mainMenu=[ViewController goTOHomeView];
    [self presentViewController:mainMenu animated:YES completion:nil];
    
}

+(CustomMenuViewControllerIboard*)goTOHomeView
{
    
    FollwViewControllerIboard *follow = [[FollwViewControllerIboard alloc]init];
    follow.title=@"Following";
    NSLog(@"Title =- %@",follow.title);
    
    FollowedByViewControllerIboard *followedby = [[FollowedByViewControllerIboard alloc] init];
    followedby.title = @"Followed-By";
    
    
    FeedViewControllerIboard * feed =[[FeedViewControllerIboard alloc]initWithNibName:@"FeedViewControllerIboard" bundle:nil];
    feed.title=@"My feeds";
    
    
    FansViewControllerIboard * fans=[[FansViewControllerIboard alloc]initWithNibName:@"FansViewControllerIboard" bundle:nil];
    fans.title=@"Fans";
    
    MutualFriendsViewControllerrIboard * mutualVc=[[MutualFriendsViewControllerrIboard alloc]init];
    mutualVc.title=@"Mutual ";

//    
//    PhotosViewControllerIboard * photoVC=[[PhotosViewControllerIboard alloc]initWithNibName:@"PhotosViewControllerIboard" bundle:nil];
//    photoVC.title=@"Photo Bucket";
    
    
    
    NonFollowerViewController * nonFollowVC=[[NonFollowerViewController alloc]initWithNibName:@"NonFollowerViewController" bundle:nil];
    nonFollowVC.title=@"Non followers";
    
    ScheduleViewControllerIboard * scheduleVC=[[ScheduleViewControllerIboard alloc]initWithNibName:@"ScheduleViewControllerIboard" bundle:nil];
    scheduleVC.title=@"Photo Que";
    
//    deatilsOfSearchInstaViewControllerIboard   * copyFollowVC=[[deatilsOfSearchInstaViewControllerIboard alloc]init];
//    copyFollowVC.title=@"Copy follows/followed-by";
    
    LocationSearchViewControllerIboard * locationVC = [[LocationSearchViewControllerIboard alloc]init];
    locationVC.title = @"Nearby feeds";
    
    SearchTagsViewControllerIboard   * searchHashTagVC=[[SearchTagsViewControllerIboard alloc]init];
    searchHashTagVC.title=@"Search # tags";
    
    UINavigationController *followNavi = [[UINavigationController alloc] initWithRootViewController:feed];
    followNavi.navigationBar.hidden = YES;
    
    CustomMenuViewControllerIboard *customMenuView =[[CustomMenuViewControllerIboard alloc] init];
    customMenuView.numberOfSections = 1;
    customMenuView.viewControllers = @[followNavi,follow,followedby,fans,mutualVc,nonFollowVC,scheduleVC,searchHashTagVC,locationVC];
    
    return customMenuView;
}

// Retreive all Loggedin user list
-(void)retreiveDataFromSqlite{
    
    [SingletonClassIboard shareSinglton].allData=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board7.sqlite"];
    NSString *query = [NSString stringWithFormat:@"select * from InstaBoard"];
    
    
    sqlite3_stmt *compiledStmt=nil;
    if(sqlite3_open([databasePath UTF8String], &database)!=SQLITE_OK)
        NSLog(@"error to open");
    {
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStmt, NULL)== SQLITE_OK)
        {
            NSLog(@"prepared");
            
            [[SingletonClassIboard shareSinglton].allData removeAllObjects];
            while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                char *userid = (char *) sqlite3_column_text(compiledStmt,1);
                char *userfullname = (char *) sqlite3_column_text(compiledStmt,2);
                char *profilepic = (char *) sqlite3_column_text(compiledStmt,3);
                char * accesstoken=(char *)sqlite3_column_text(compiledStmt,4);
                char * media=(char *)sqlite3_column_text(compiledStmt,5);
                char * followers=(char *)sqlite3_column_text(compiledStmt,6);
                char * following=(char *)sqlite3_column_text(compiledStmt,7);
                
                NSString *userId= [NSString  stringWithUTF8String:userid];
                
                NSString *userFullName  = [NSString stringWithUTF8String:userfullname];
                NSString *profilePic  = [NSString stringWithUTF8String:profilepic];
                NSString * accessToken=[NSString stringWithUTF8String:accesstoken];
                
                NSString *mediaCnt  = [NSString stringWithUTF8String:media];
                NSString *Followers  = [NSString stringWithUTF8String:followers];
                NSString * Following=[NSString stringWithUTF8String:following];
                
                NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
                [temp setObject:userId forKey:@"userId"];
                [temp setObject:userFullName forKey:@"userFullName"];
                [temp setObject:profilePic forKey:@"profilePic"];
                [temp setObject:accessToken forKey:@"accessToken"];
                [temp setObject:mediaCnt forKey:@"mediaCnt"];
                [temp setObject:Followers forKey:@"followers"];
                [temp setObject:Following forKey:@"following"];
                [[SingletonClassIboard shareSinglton].allData addObject:temp];
            }
            
        }
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(database);
    NSLog(@"count from data base  %@",[SingletonClassIboard shareSinglton].allData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
