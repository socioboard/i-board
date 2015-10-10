

#import "WebViewViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import <sqlite3.h>

@interface WebViewViewControllerIboard ()
{

    UILabel * noInternetConnnection;
}
@end

@implementation WebViewViewControllerIboard
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
- (void)viewDidLoad {
    [super viewDidLoad];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAllFollowedBy) name:@"loadAllFollowedBy" object:nil];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 55)];
    headerView.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, windowSize.width-120, 25)];
    titleLabel.text=@"Login";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    
    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(15, 25, 50, 25);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:
     UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:cancelBtn];
    
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {
        [self createUI];
    }
    else{
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


    
    NSString * url=[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=relationships+likes",client_id_iboard,redirectUri_iboard];
    
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

#pragma mark- loadAllFollowers data

-(void)loadAllFollowers
{
//    [SingletonClassIboard shareSinglton].full_name=[[NSMutableArray alloc]init];
//    [SingletonClassIboard shareSinglton].profile_picture=[[NSMutableArray alloc]init];
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]]];

    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
  
    
    NSArray * resultArr=(NSArray*)[dictResponse objectForKey:@"data"];
    NSLog(@"Result arr %@ ==--%lu",resultArr,(unsigned long)resultArr.count);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    for (int i=0; i<resultArr.count; i++) {
        dict=[resultArr objectAtIndex:i];
        [[SingletonClassIboard shareSinglton].full_name addObject:[dict objectForKey:@"full_name"]];
        [[SingletonClassIboard shareSinglton].profile_picture addObject:[dict objectForKey:@"profile_picture"]];
    }
    
}

//api call for to get user accesstoken
-(void)getAccessToken{
    
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    NSString * code=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"code"];
    
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"]];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString * body=[NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id_iboard,client_screte_iboard,redirectUri_iboard,code];
    
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
    [SingletonClassIboard shareSinglton].user_full_name=[dict objectForKey:@"full_name"];
    [SingletonClassIboard shareSinglton].user_pic=[dict objectForKey:@"profile_picture"];
    [SingletonClassIboard shareSinglton].user_name=[dict objectForKey:@"username"];
    [SingletonClassIboard shareSinglton].userID=[dict objectForKey:@"id"];
    
    
    
    
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
        
        
        [SingletonClassIboard shareSinglton].follows=[NSString stringWithFormat:@"%@",[countsDic objectForKey:@"follows"]];
        [SingletonClassIboard shareSinglton].followed_by=[NSString stringWithFormat:@"%@",[countsDic objectForKey:@"followed_by"]];
        [SingletonClassIboard shareSinglton].medaiCnt=[NSString stringWithFormat:@"%@",[countsDic objectForKey:@"media"]];
        
        [self setNotificationPerDay];
        
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
                 const char *sqlStatement = "CREATE TABLE  InstaBoard (ID INTEGER PRIMARY KEY AUTOINCREMENT,UserId TEXT, UserFullName TEXT, ProfilePic TEXT,AccessToken TEXT,Followers TEXT,Following TEXT,Media TEXT)";
                 
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
     NSString *querySQL=[NSString stringWithFormat:@"select Username from InstaBoard where UserId=\"%@\"",[SingletonClassIboard shareSinglton].userID];
 
 
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
 
          NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO InstaBoard (UserId ,UserFullName ,ProfilePic ,AccessToken,Followers,Following,Media) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[SingletonClassIboard shareSinglton].userID,[SingletonClassIboard shareSinglton].user_full_name,[SingletonClassIboard shareSinglton].user_pic,access_token,[SingletonClassIboard shareSinglton].follows,[SingletonClassIboard shareSinglton].followed_by,[SingletonClassIboard shareSinglton].medaiCnt];
 
 
 const char *insert_stmt=[insertSQL UTF8String];
         if (sqlite3_open([databasePath UTF8String], &_database)!=SQLITE_OK) {
             NSLog(@"Error to Open");
             return;
         }
 
         if (sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL)!=SQLITE_OK) {
               NSLog(@"ERRor %s",sqlite3_errmsg(_database));
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
    
    if ([SingletonClassIboard shareSinglton].fromAddAccount==YES) {
        [self retreiveDataFromSqlite];
    }
 
 }

// retrive all stored  data from data base .
-(void)retreiveDataFromSqlite{
    
    [SingletonClassIboard shareSinglton].fromAddAccount=NO;
    
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
    sqlite3_close(_database);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
    NSLog(@"count from data base  %@",[SingletonClassIboard shareSinglton].allData);
}



-(void)firedNotification {
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
         self.dic.annotation = [NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"];
        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
        //[self.dic presentPreviewAnimated:YES];
        
    }
    
}

#pragma mark- set loccal notifcation

-(void)setNotificationPerDay{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute =15;
    dateComponents.hour = 19;
    
    NSDate *fireDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];
    
    UILocalNotification * notify =[[UILocalNotification alloc]init];
    notify.fireDate = fireDate;
    notify.alertBody =@"You have new followers";
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setObject:@"follower" forKey:@"follower"];
    
    notify.userInfo = dict;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notify];
}

@end
