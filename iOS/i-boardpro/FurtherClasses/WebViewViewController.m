//
//  WebViewViewController.m
//  Board
//
//  Created by Sumit Ghosh on 21/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "WebViewViewController.h"
#import "SingletonClass.h"
#import <sqlite3.h>

@interface WebViewViewController ()
{
    NSString * client_id ;
    NSString * redirectUri;
    NSString * client_screte;
}
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAllFollowedBy) name:@"loadAllFollowedBy" object:nil];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    headerView.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.view addSubview:headerView];
    
    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(15, 25, 50, 25);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:
     UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:cancelBtn];
    
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}


-(void)cancelButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// api call for login
-(void)createUI{
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    client_id = @"xxxxxxxxxxxxxxxxxxxxxxxxxx";
    redirectUri=@"http://xxxxxxxxxx.com";
    client_screte=@"xxxxxxxxxxxxxxxxxxxxxxxxxxx";

    
    NSString * url=[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=relationships",client_id,redirectUri];
    
    NSURL * instagramUrl=[NSURL URLWithString:url];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:instagramUrl];
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 55,windowSize.width,windowSize.height)];
    self.webView.delegate=self;
    [ self.webView loadRequest:req];
    [self.view addSubview: self.webView];
}

#pragma mark- delegate method of webView

// here we will get code after login
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * urlStr=[[request URL]absoluteString];
    
    NSString *orignalUrl =[request.URL absoluteString];
    NSArray* parts = [orignalUrl componentsSeparatedByString: @"="];
    if (parts.count>1&&[urlStr rangeOfString:@"code="].location!=NSNotFound) {
        NSLog(@"WebView URL %@",urlStr);
        
        NSString *  request_token = [parts objectAtIndex: 1];
        
        
        [[NSUserDefaults standardUserDefaults]                                                                                                                                               setObject:request_token forKey:@"code"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        [self getAccessToken];
        
        
        return NO;
    }
    return YES;
}

#pragma mark- get profile data

-(void)loadAllFollowers
{
    [SingletonClass shareSinglton].full_name=[[NSMutableArray alloc]init];
    [SingletonClass shareSinglton].profile_picture=[[NSMutableArray alloc]init];
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]]];
    // Here we can handle response as well
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    // NSLog(@"Response : %@",dictResponse);
    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClass shareSinglton].full_name addObject:[dict objectForKey:@"full_name"]];
        [[SingletonClass shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
    }
    
}

//api call for to get user accesstoken
-(void)getAccessToken{
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    client_id = @"585520b8070e49d49b50d59ff57ec463";
    redirectUri=@"http://www.socioboard.com";
    client_screte=@"4e61cfd6a80f426295c8b2d6d5b30e61";
   
    NSString * code=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"code"];
    
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"]];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString * body=[NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,client_screte,redirectUri,code];
    
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    
    NSData  * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    
    // Here we can handle response as well as get accesstoken.
    id dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:[dictResponse objectForKey:@"access_token"] forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    
    dict=[dictResponse objectForKey:@"user"];
    [SingletonClass shareSinglton].user_full_name=[dict objectForKey:@"full_name"];
    [SingletonClass shareSinglton].user_pic=[dict objectForKey:@"profile_picture"];
    [SingletonClass shareSinglton].user_name=[dict objectForKey:@"username"];
    [SingletonClass shareSinglton].userID=[dict objectForKey:@"id"];
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self loadAllFollowers];
    [self getUserProfileData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginCheckComplete" object:nil userInfo:nil];
    
}

-(void)getUserProfileData{
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@",access_token]];
    
    NSMutableURLRequest * getRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@" response of feeds %@",response);
    NSMutableDictionary * metaDic=[NSMutableDictionary dictionary];
    metaDic=[response objectForKey:@"meta"];
    if ([[metaDic objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSMutableDictionary * dataDic=[NSMutableDictionary dictionary];
        NSMutableDictionary * countsDic=[NSMutableDictionary dictionary];
        
        dataDic=[response objectForKey:@"data"];
        countsDic=[dataDic objectForKey:@"counts"];
        
        [SingletonClass shareSinglton].followed_by=[countsDic objectForKey:@"followed_by"];
        [SingletonClass shareSinglton].follows=[countsDic objectForKey:@"follows"];
        
        [self createSqliteTable];
        
    }
    
}

#pragma mark- create sqLite table

 -(void)createSqliteTable{
 
     NSArray * path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 
     NSString * documentoryPath=[path objectAtIndex:0];
     NSString *databasePath = [documentoryPath stringByAppendingPathComponent:@"board7.sqlite"];
     NSLog(@"database path %@",databasePath);
         NSFileManager *mgr=[NSFileManager defaultManager];
     
        if([mgr fileExistsAtPath:databasePath]==NO)// checks whether .sqlite file exists
                  {

             if (sqlite3_open([databasePath UTF8String], &_database)==SQLITE_OK) {
                 
                 char * errormsg;
                 const char *sqlStatement = "CREATE TABLE  InstaBoard (ID INTEGER PRIMARY KEY AUTOINCREMENT,UserId TEXT, UserFullName TEXT, ProfilePic TEXT,AccessToken TEXT)";
                 
                 if (sqlite3_exec(_database, sqlStatement, NULL, NULL, &errormsg)!=SQLITE_OK) {
                     NSLog(@"Failed to create table");
                 }
                 NSLog(@"Data base created");
             }
             sqlite3_close(_database);
         }

        [self insertIntoTable];
     
     }


#pragma mark- insert into table

-(void)insertIntoTable{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board7.sqlite"];
 
    sqlite3_stmt *statement;
 
 
 
 if(sqlite3_open([databasePath UTF8String], &_database)==SQLITE_OK)
 {
     // Query for checking user already exists in DB.
     NSString *querySQL=[NSString stringWithFormat:@"select Username from InstaBoard where UserId=\"%@\"",[SingletonClass shareSinglton].userID];
 
 
     const char *query_stmt=[querySQL UTF8String];
     NSLog(@"QuerySQL in signIN :%@",querySQL);
 
 
 if (sqlite3_prepare_v2(_database, query_stmt, -1, &statement, NULL)==SQLITE_OK);
     if(sqlite3_step(statement)==SQLITE_ROW)//Checks wheter user already exits in sqlite.
     {
         UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:nil message:@"USername is already  exist" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
         [alertview show];
     }
 
     else
     {
         NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
 
          NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO InstaBoard (UserId ,UserFullName ,ProfilePic ,AccessToken) values(\"%@\",\"%@\",\"%@\",\"%@\")",[SingletonClass shareSinglton].userID,[SingletonClass shareSinglton].user_full_name,[SingletonClass shareSinglton].user_pic,access_token];
 
 
 const char *insert_stmt=[insertSQL UTF8String];
         if (sqlite3_open([databasePath UTF8String], &_database)!=SQLITE_OK) {
             NSLog(@"Error to Open");
             return;
         }
 
         if (sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL)!=SQLITE_OK) {
             return;
         }
 
 
         if(sqlite3_step(statement)==SQLITE_DONE)
         {
             NSLog(@"You added successfully");
 
 
         }
 
     }
    }
    sqlite3_finalize(statement);
  sqlite3_close(_database);
    
    if ([SingletonClass shareSinglton].fromAddAccount==YES) {
        [self retreiveDataFromSqlite];
    }
 
 }

// retrive all stored  data from data base .
-(void)retreiveDataFromSqlite{
    
    [SingletonClass shareSinglton].fromAddAccount=NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board7.sqlite"];
    NSString *query = [NSString stringWithFormat:@"select * from InstaBoard"];
    
    
    sqlite3_stmt *compiledStmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_database)!=SQLITE_OK)
        NSLog(@"error to open");
    {
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &compiledStmt, NULL)== SQLITE_OK)
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
    sqlite3_close(_database);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
    NSLog(@"count from data base  %lu",[SingletonClass shareSinglton].allData.count);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
