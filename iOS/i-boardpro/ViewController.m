//
//  ViewController.m
//  Board
//
//  Created by Sumit Ghosh on 21/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "CustomMenuViewController.h"
#import "FollwViewController.h"
#import "UnfollowViewController.h"
#import "ProfileViewController.h"
#import "WebViewViewController.h"
#import "FeedViewController.h"
#import "PhotosViewController.h"
#import "NonFollowerViewController.h"
#import "SingletonClass.h"
#import "ScheduleViewController.h"

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
    background.image=[UIImage imageNamed:@"main_view.png"];
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
        //[button setTitle:@"Instagram" forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"connect_with_instagram.png"] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor blueColor];
        button.layer.cornerRadius=5;
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
    if ([SingletonClass shareSinglton].isActivenetworkConnection==NO) {
        
    }
    else{
        WebViewViewController *  webviewVC=[[WebViewViewController alloc]initWithNibName:@"WebViewViewController" bundle:nil];
        [self presentViewController:webviewVC animated:YES completion:^{
        }];
    }
}

//Create  Custom menu list

-(void)loginCheckComplete
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginCheckComplete" object:nil];
    CustomMenuViewController * mainMenu=[ViewController goTOHomeView];
    [self presentViewController:mainMenu animated:YES completion:nil];
    
}

+(CustomMenuViewController*)goTOHomeView
{
    
    FollwViewController *follow = [[FollwViewController alloc]init];
    follow.title=@"Following";
    NSLog(@"Title =- %@",follow.title);
    
    UnfollowViewController *unfollow = [[UnfollowViewController alloc] init];
    unfollow.title = @"Followed-by";
    
    
    FeedViewController * feed =[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    feed.title=@"Feeds";
    
    
    PhotosViewController * photoVC=[[PhotosViewController alloc]initWithNibName:@"PhotosViewController" bundle:nil];
    photoVC.title=@"User photos";
    
    NonFollowerViewController * nonFollowVC=[[NonFollowerViewController alloc]initWithNibName:@"NonFollowerViewController" bundle:nil];
    nonFollowVC.title=@"Non Followers";
    
    ScheduleViewController * scheduleVC=[[ScheduleViewController alloc]initWithNibName:@"ScheduleViewController" bundle:nil];
    scheduleVC.title=@"Schedule";
    
    UINavigationController *followNavi = [[UINavigationController alloc] initWithRootViewController:follow];
    followNavi.navigationBar.hidden = YES;
    
    CustomMenuViewController *customMenuView =[[CustomMenuViewController alloc] init];
    customMenuView.numberOfSections = 1;
    customMenuView.viewControllers = @[follow,unfollow,feed,photoVC,nonFollowVC,scheduleVC];
    
    return customMenuView;
}

// Retreive all Loggedin user list
-(void)retreiveDataFromSqlite{
    
    [SingletonClass shareSinglton].allData=[[NSMutableArray alloc]init];
    
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
            
            [[SingletonClass shareSinglton].allData removeAllObjects];
            while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                char *userid = (char *) sqlite3_column_text(compiledStmt,1);
                char *userfullname = (char *) sqlite3_column_text(compiledStmt,2);
                char *profilepic = (char *) sqlite3_column_text(compiledStmt,3);
                char * accesstoken=(char *)sqlite3_column_text(compiledStmt,4);
                
                NSString *userId= [NSString  stringWithUTF8String:userid];
                
                NSString *userFullName  = [NSString stringWithUTF8String:userfullname];
                NSString *profilePic  = [NSString stringWithUTF8String:profilepic];
                NSString * accessToken=[NSString stringWithUTF8String:accesstoken];
                
                NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
                [temp setObject:userId forKey:@"userId"];
                [temp setObject:userFullName forKey:@"userFullName"];
                [temp setObject:profilePic forKey:@"profilePic"];
                [temp setObject:accessToken forKey:@"accessToken"];
                
                [[SingletonClass shareSinglton].allData addObject:temp];
            }
            
        }
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(database);
    NSLog(@"count from data base  %lu",[SingletonClass shareSinglton].allData.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
