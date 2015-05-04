//
//  ProfileViewController.m
//  TwitterBoard
//
//  Created by GLB-254 on 4/18/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

#import "ProfileViewController.h"
#import "SingletonClass.h"
#import <sqlite3.h>
#import "CustomMenuViewController.h"
#import "FollwViewController.h"
#import "ViewController.h"

@interface ProfileViewController ()
{
    sqlite3 * database;
    UIActivityIndicatorView  * activityView;
    CustomMenuViewController * customMenu;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataFetch) name:@"getDataForProfile" object:nil];
    
    activityView=[[UIActivityIndicatorView alloc]init];
    activityView.frame=CGRectMake(windowSize.width/2-20, 150, 40,40);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityView.color=[UIColor whiteColor];
    activityView.alpha=1.0;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];
    //[self loadDataFetch]
    // Do any additional setup after loading the view.
}

-(void)loadDataFetch{
  
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self getDataForProfile :self.accessToken];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityView stopAnimating];
            [self createUIForProfile];
        });
    });
}

// create UI of  user prifle to user data.
-(void)createUIForProfile{
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)150/255 green:(CGFloat)150/255 blue:(CGFloat)150/255 alpha:(CGFloat)1];
    
    profile_pic=[[UIImageView alloc]init];
    profile_pic.frame=CGRectMake(15, 30, 50, 50);
    profile_pic.layer.cornerRadius=profile_pic.frame.size.width/2;
    profile_pic.clipsToBounds=YES;
    profile_pic.backgroundColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    profile_pic.layer.borderColor=[UIColor whiteColor].CGColor;
    profile_pic.layer.borderWidth=1.5;
   
    NSLog(@"%@",[SingletonClass shareSinglton].user_pic);
    NSURL * url=[NSURL URLWithString:[SingletonClass shareSinglton].user_pic];
    NSData * imageData=[NSData dataWithContentsOfURL:url];
    
    profile_pic.image=[UIImage imageWithData:imageData];
    [self.view addSubview:profile_pic];
    
     NSLog(@"%@",[SingletonClass shareSinglton].user_full_name);
    if (full_name) {
        full_name=nil;
    }
    full_name =[[UILabel alloc]init];
    full_name.frame=CGRectMake(80, 30, 150,20);
    full_name.text=[SingletonClass shareSinglton].user_full_name;
    full_name.font=[UIFont boldSystemFontOfSize:12];
    full_name.textColor=[UIColor whiteColor];
    [self.view addSubview:full_name];
    
     NSLog(@"%@",[SingletonClass shareSinglton].user_name);
    if (username) {
        username=nil;
    }
    username=[[UILabel alloc]init];
    username.frame=CGRectMake(80, 60, 150, 10);
    username.text=[SingletonClass shareSinglton].user_name;
    username.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:username];
    
    UIButton * closeBtn=[[UIButton alloc]init];
    closeBtn.frame=CGRectMake(self.view.frame.size.width-70, 30, 50, 25);
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    [closeBtn setBackgroundColor:[UIColor colorWithRed:(CGFloat)54/255 green:(CGFloat)54/255 blue:(CGFloat)54/255 alpha:(CGFloat)1]];
    closeBtn.layer.cornerRadius=7;
    closeBtn.clipsToBounds=YES;
     [closeBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
    UILabel * mediaCount=[[UILabel alloc]init];
    mediaCount.frame=CGRectMake(40, 120, 80, 10);
    mediaCount.text=@"Media";
    mediaCount.font=[UIFont boldSystemFontOfSize:10];
    mediaCount.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:mediaCount];
    
    UILabel * Follower=[[UILabel alloc]init];
    Follower.frame=CGRectMake(self.view.frame.size.width/2-20, 120, 80, 10);
    Follower.text=@"Followers";
    Follower.font=[UIFont boldSystemFontOfSize:10];
    Follower.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:Follower];
    
    UILabel * following=[[UILabel alloc]init];
    following.frame=CGRectMake(self.view.frame.size.width-80, 120, 80, 10);
    following.text=@"Following";
    following.font=[UIFont boldSystemFontOfSize:10];
    following.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:following];
    
  
    UIButton * disconnect=[UIButton buttonWithType:UIButtonTypeCustom];
    disconnect.frame=CGRectMake(20, windowSize.height-100, windowSize.width-40, 40);
    [disconnect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disconnect setTitle:@"Discconnet Account" forState:UIControlStateNormal];
    [disconnect setBackgroundColor:[UIColor colorWithRed:(CGFloat)60/255 green:(CGFloat)111/255 blue:(CGFloat)151/255 alpha:(CGFloat)1]];
    disconnect.layer.cornerRadius=7;
    disconnect.clipsToBounds=YES;
    [disconnect addTarget:self action:@selector(disconnectAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disconnect];
}

-(void)closeAccount{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Deleting  user from DB
-(void)disconnectAccount{
    
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentPath=[paths objectAtIndex:0];
    NSString * databasePath=  [documentPath stringByAppendingPathComponent:@"board7.sqlite"];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
        
       NSString * query= [NSString stringWithFormat:@"DELETE FROM InstaBoard where AccessToken=\"%@\"",accessToken];
        
        const char *sql =[query UTF8String];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(database, sql,-1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_DONE){
               
            }else{
               
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
   
    [self retreiveDataFromSqlite ];
    
  }

// get user profile data here
-(void)getDataForProfile : (NSString *)accessToken{
    [SingletonClass shareSinglton].user_full_name=@" ";
    [SingletonClass shareSinglton].user_pic=@" ";
    [SingletonClass shareSinglton].userID=@" ";
    
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    
    
    for (int i=0; i<[SingletonClass shareSinglton].allData.count;i++) {
        dict=[[SingletonClass shareSinglton].allData objectAtIndex:i];
        if ([accessToken isEqualToString:[dict objectForKey:@"accessToken"]]) {
            [SingletonClass shareSinglton].user_full_name=[dict objectForKey:@"userFullName"];
            [SingletonClass shareSinglton].user_pic=[dict objectForKey:@"profilePic"];
            //[SingletonClass shareSinglton].user_name=[dict objectForKey:@"username"];
            [SingletonClass shareSinglton].userID=[dict objectForKey:@"userId"];
        }
    }
    
}




-(void)retreiveDataFromSqlite{
    
    [[SingletonClass shareSinglton].allData removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board7.sqlite"];
    NSString *query = [NSString stringWithFormat:@"select *  from InstaBoard"];
    
    
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
                
                [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
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
    
    
    if ([SingletonClass shareSinglton].allData.count<1) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.modalPresentationStyle=UIModalTransitionStyleFlipHorizontal;
        [[self.presentingViewController presentingViewController]dismissViewControllerAnimated:YES completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
        [SingletonClass shareSinglton].customDismiss=YES;
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

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
