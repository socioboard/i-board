

#import "ComposeViewController.h"
#import <sqlite3.h>
#import "SingletonClass.h"

@interface ComposeViewController ()
{
    UITextView * composeTextView;
    UIButton * timeButton,*dateButton;
    
}
@end

@implementation ComposeViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification"  object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    windowSize=[UIScreen mainScreen].bounds.size;
    
    [SingletonClass shareSinglton].notfyArr=[[NSMutableArray alloc]init];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 55)];
    
    self.headerView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:self.headerView];
    
    
    
    
    self.headerView.layer.shadowRadius = 5.0;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.6;
    self.headerView.layer.shadowOffset = CGSizeMake(0.0f,5.0f);
    self.headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.headerView.bounds].CGPath;
    
    UIButton * cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(15, 20, 50, 25);
    cancelButton.layer.cornerRadius=5;
    cancelButton.clipsToBounds=YES;
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
    
    UIButton * postButton=[UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame=CGRectMake(windowSize.width-70, 20, 50, 25);
    postButton.layer.cornerRadius=5;
    postButton.clipsToBounds=YES;
    [postButton setTitle:@"Post" forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:postButton];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    
    // Do any additional setup after loading the view from its nib.
}


// create UI for to compose message
-(void)createUI{
    CALayer * layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(0, 55, windowSize.width, windowSize.height/2+80);
    layer.backgroundColor=[UIColor colorWithRed:(CGFloat)3/255 green:(CGFloat)132/255 blue:(CGFloat)254/255 alpha:(CGFloat)1].CGColor;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 75, windowSize.width-60, windowSize.height/2-80)];
    imageView.image=self.img;
    imageView.layer.cornerRadius=5;
    imageView.clipsToBounds=YES;
    [self.view addSubview:imageView];
    
     composeTextView=[[UITextView alloc]initWithFrame:CGRectMake(105, windowSize.height/2, windowSize.width-140, 100)];
    composeTextView.font=[UIFont systemFontOfSize:12];
    composeTextView.textColor=[UIColor blackColor];
    composeTextView.text=@"Enter your caption here.";
    composeTextView.delegate=self;
    composeTextView.layer.borderWidth=0.7;
    composeTextView.layer.borderColor=[UIColor blackColor].CGColor;
    composeTextView.layer.cornerRadius=5;
    composeTextView.clipsToBounds=YES;
    [self.view addSubview:composeTextView];
    
    
    CAGradientLayer * glayer=[CAGradientLayer layer];
    glayer.frame=CGRectMake(0, 220, windowSize.width, 50);
    UIColor * firstColor=[UIColor colorWithRed:(CGFloat)55/255 green:(CGFloat)105/255 blue:(CGFloat)147/255 alpha:(CGFloat)1.0];
    UIColor * secColor=[UIColor colorWithRed:(CGFloat)80/255 green:(CGFloat)105/255 blue:(CGFloat)160/255 alpha:(CGFloat)1.0];
    glayer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor],(id)[secColor CGColor], nil];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 220, windowSize.width, 50)];
    [view.layer insertSublayer:glayer atIndex:0];
    
    
     dateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame=CGRectMake(10,windowSize.height/2+30, 80, 50);

    //[dateButton setBackgroundImage:[UIImage imageNamed:@"timer.png"] forState:UIControlStateNormal];
    [dateButton setTitle:@"Set date" forState:UIControlStateNormal];
    dateButton.layer.cornerRadius=5;
    dateButton.clipsToBounds=YES;
    dateButton.tag=2;
    dateButton.backgroundColor=[UIColor colorWithRed:(CGFloat)3/255 green:(CGFloat)132/255 blue:(CGFloat)254/255 alpha:(CGFloat)1];
    dateButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    dateButton.layer.borderColor=[UIColor whiteColor].CGColor;
    [dateButton addTarget:self action:@selector(pickDateAndTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateButton];
}


// Pick date
-(void)pickDateAndTime:(UIButton*)sender{
    [composeTextView resignFirstResponder];
    if (self.datePicker) {
         [self.datePicker removeFromSuperview];
        self.datePicker=nil;
       
    }
    self.datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, windowSize.height/2+20, windowSize.width, windowSize.height/2-20)];
    self.datePicker.frame=CGRectMake(0.0, windowSize.height-130,windowSize.width, 0);
    if ([sender tag]==2) {
        isDate=YES;
        [self creatBottomUI];
    }
    
    [self.view addSubview:self.datePicker];

}

-(void)cancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)creatBottomUI{
    if(self.tabView)
    {
        [self.tabView removeFromSuperview];
        self.tabView=nil;
    }
     self.tabView=[[UIView alloc]init ];
    self.tabView.frame =CGRectMake(0.0,windowSize.height-180, windowSize.width, 40);
    [self.view addSubview:self.tabView];
    self.tabView.hidden=NO;
    
    CAGradientLayer * glayer=[CAGradientLayer layer];
    glayer.frame=CGRectMake(0, 0, windowSize.width, 50);
    UIColor * firstColor=[UIColor colorWithRed:(CGFloat)55/255 green:(CGFloat)105/255 blue:(CGFloat)147/255 alpha:(CGFloat)1.0];
    UIColor * secColor=[UIColor colorWithRed:(CGFloat)80/255 green:(CGFloat)105/255 blue:(CGFloat)160/255 alpha:(CGFloat)1.0];
    glayer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor],(id)[secColor CGColor], nil];
   
    [self.tabView.layer insertSublayer:glayer atIndex:0];
    
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(windowSize.width-70, 15, 50, 25);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.clipsToBounds=YES;
    doneBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
    doneBtn.layer.borderWidth=0.7;
    doneBtn.layer.cornerRadius=5;
    [doneBtn addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabView addSubview:doneBtn];
    
    UIButton * cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(40, 15, 50, 25);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.clipsToBounds=YES;
    cancelButton.layer.borderColor=[[UIColor whiteColor]CGColor];
    cancelButton.layer.borderWidth=0.7;
    cancelButton.layer.cornerRadius=5;
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabView addSubview:cancelButton];
    
}
-(void)cancelButtonClicked:(UIButton *)sender{
    [self.tabView removeFromSuperview];
    self.tabView=nil;
    [self.datePicker removeFromSuperview];
    self.datePicker=nil;
}

-(void)doneButtonClicked:(UIButton *)sender{
    if (isDate==YES) {
        
    dateFire=self.datePicker.date;
  
    }
   
    [self.tabView removeFromSuperview];
    self.tabView=nil;
    [self.datePicker removeFromSuperview];
    self.datePicker=nil;
}

-(void)postButtonAction{
    if (dateFire==0) {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"Please select the date" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    unixTime=(time_t) [dateFire timeIntervalSince1970];
    localNotification.fireDate = dateFire ;
    localNotification.alertBody =@"i-board" ;
    localNotification.alertAction = @"Image is ready to post";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    NSString * unix_time=[NSString stringWithFormat:@"%ld",unixTime];
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];

    
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:unix_time, @"unixTime", access_token, @"access_token", nil];
    NSLog(@"%@ dictionary",userDict);
    [[SingletonClass shareSinglton].notfyArr addObject:userDict];
    localNotification.userInfo = userDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self createSqliteTable];
    
   }

//create UI after getting notication
-(void)firedNotification {
    
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClass shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        //[self.dic setAnnotation:@{@"InstagramCaption" :[SingletonClass shareSinglton].captionStr}];
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        [self.dic presentOpenInMenuFromRect:CGRectZero    inView:self.view animated: YES ];
        
    }
    
}



- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    
}


#pragma mark- textVie wdelegate method

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    composeTextView.text=@"";
    return YES;
}

//create sqlite Data base  to manage scheduled images.
-(void)createSqliteTable{
    
    NSArray * path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentoryPath=[path objectAtIndex:0];
    NSString *databasePath = [documentoryPath stringByAppendingPathComponent:@"board21.sqlite"];
    NSLog(@"database path %@",databasePath);
        
    NSString * firstTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"firstTime"];
    if (!firstTime) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
    
   // if([mgr fileExistsAtPath:databasePath]==NO)
   // {
        
        if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
            
            char * errormsg;
            const char *sqlStatement = "CREATE TABLE  Schedule (ID INTEGER PRIMARY KEY AUTOINCREMENT, ProfilePic TEXT,ImageId TEXT,Image BLOB,Time TEXT,AccessToken TEXT,Caption TEXT)";
            
            if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errormsg)!=SQLITE_OK) {
                NSLog(@"Failed to create table");
            }
            NSLog(@"Data base created");
        }
        sqlite3_close(database);
    }
    
    [self insertIntoTable];
    
}


#pragma mark- insert into table

-(void)insertIntoTable{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board21.sqlite"];
    
    sqlite3_stmt *statement;
    
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        
        
        NSData * data=UIImagePNGRepresentation(self.img);
        
        NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];

        
        NSString * path=[NSString stringWithFormat:@"%@",self.imgPath];
        NSString * unix_time=[NSString stringWithFormat:@"%ld",unixTime];
        NSString * composeText=composeTextView.text;
        if (!composeText) {
            composeText=@"";
        }
        
        NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO Schedule (ProfilePic,ImageId,Image,Time,AccessToken,Caption ) values(\"%@\",\"%@\",?,\"%@\",\"%@\",\"%@\")",path,self.imgId,unix_time,access_token,composeText];
        
        
        const char *insert_stmt=[insertSQL UTF8String];
        
        
        
        if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            sqlite3_bind_blob(statement, 1, [data bytes], [data length], NULL);
            
            
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
            }
        }
        else
        {
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    [self retreiveDataFromSqliteOfSchedule];
    
}

// Retrive Data from schedule table to show scheduled images
-(void)retreiveDataFromSqliteOfSchedule{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board21.sqlite"];
    
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *query = [NSString stringWithFormat:@"select * from Schedule where AccessToken =\"%@\"",accessToken];
    
    
    sqlite3_stmt *compiledStmt=nil;
    if(sqlite3_open([databasePath UTF8String], &database)!=SQLITE_OK)
        NSLog(@"error to open");
    {
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStmt, NULL)== SQLITE_OK)
        {
            NSLog(@"prepared");
            NSData * data=nil;
            
            [[SingletonClass shareSinglton].postData removeAllObjects];
            while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                
                char *profilepic = (char *) sqlite3_column_text(compiledStmt,1);
                
                char *imgId = (char *) sqlite3_column_text(compiledStmt,2);
                
                int length = sqlite3_column_bytes(compiledStmt, 3);
                data=[NSData dataWithBytes:sqlite3_column_blob(compiledStmt, 3) length:length];
                
                char * time=(char *) sqlite3_column_text(compiledStmt,4);
                char * caption=(char*)sqlite3_column_text(compiledStmt,6);
                
                NSString *profilePic  = [NSString stringWithUTF8String:profilepic];
                NSString *imageId  = [NSString stringWithUTF8String:imgId];
                NSString *uTime  = [NSString stringWithUTF8String:time];
                
                NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
                
                [temp setObject:profilePic forKey:@"profilePic"];
                
                [temp setObject:data forKey:@"image"];
                
                [temp setObject:uTime forKey:@"unixTime"];
                
                
                [[SingletonClass shareSinglton].postData addObject:temp];
                
                [SingletonClass shareSinglton].imagePath=profilePic;
                [SingletonClass shareSinglton].imageId=imageId;
            }
            
        }
        else{
            NSLog(@"ERROR %s",sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(database);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"scheduleReload" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"scheduleReload" object:nil];
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
