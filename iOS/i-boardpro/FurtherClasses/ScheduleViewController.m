

#import "ScheduleViewController.h"
#import "ScheduleCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "SingletonClass.h"


@interface ScheduleViewController ()
{
    ComposeViewController * composeVC;
    NSString * localUrl;
    sqlite3 * database;
}
@end

@implementation ScheduleViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification"  object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scheduleReload) name:@"scheduleReload" object:nil];
      
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchSchedule) name:@"schedulePhoto" object:nil];
    
    [SingletonClass shareSinglton].postData=[[NSMutableArray alloc]init];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)fetchSchedule{
    dispatch_async(dispatch_get_global_queue(0, 0),^{
//        NSString * first=[[NSUserDefaults standardUserDefaults]objectForKey:@"checkFirst"];
//        if (!first) {
//            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"checkFirst"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            [self retreiveDataFromSqliteOfSchedule];
        //}
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self createTableUI];
        });
    });

}

-(void)scheduleReload{
    
    [scheduleTbl reloadData];
}


// create tableview and add button to show last scheduled
-(void)createTableUI{
    
    UIButton * addPhotoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.frame=CGRectMake(windowSize.width/2-20,windowSize.height-130, 50, 50);

    [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"blue_inner_follow.png"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addPhotoBtn];
    [scheduleTbl removeFromSuperview];
    if (scheduleTbl) {
        scheduleTbl=nil;
    }
    scheduleTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height-150)];
    scheduleTbl.delegate=self;
    scheduleTbl.dataSource=self;
    scheduleTbl.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scheduleTbl];
    
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 150)];
    footerView.backgroundColor=[UIColor whiteColor];
    scheduleTbl.tableFooterView=footerView;
    
    UILabel * topLabel=[[UILabel alloc]initWithFrame:CGRectMake(windowSize.width/2-60, 10, (windowSize.width-(windowSize.width/2-60)), 25)];
    topLabel.text=@"Schedule Photos";
    topLabel.textColor=[UIColor blackColor];
    topLabel.font=[UIFont boldSystemFontOfSize:12];
    [footerView addSubview:topLabel];
    
    UILabel * bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(windowSize.width/2-60, 40, (windowSize.width-(windowSize.width/2-60)), 30)];
    bottomLabel.text=@"Queue your photos and we will remind you to post them at the best time.";
    bottomLabel.textColor=[UIColor blackColor];
    bottomLabel.font=[UIFont systemFontOfSize:10];
    bottomLabel.numberOfLines=0;
    bottomLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [footerView addSubview:bottomLabel];

    
}

// Tableview delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([SingletonClass shareSinglton].postData.count<1) {
        return 0;
    }
    else{
        return [SingletonClass shareSinglton].postData.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScheduleCell * cell=[tableView dequeueReusableCellWithIdentifier:@"schedule"];
    
    if (!cell) {
        cell=[[ScheduleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"schedule"];
    }
    NSMutableDictionary * dict=[[SingletonClass shareSinglton].postData objectAtIndex:indexPath.row];
    cell.cellImgView.image=[UIImage imageWithData:[dict objectForKey:@"image"]];
    
    NSMutableDictionary * timeDict=[[SingletonClass shareSinglton].postData objectAtIndex:indexPath.row];
    NSString * unixTimeStampStr =[timeDict objectForKey:@"unixTime"];
    double  unixTimeStamp=[unixTimeStampStr doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    cell.topLabel.text=dateString;
    
    return cell;
}

// add photo button
-(void)addPhotosAction
{
    
    if(self.imagePicker)
    {
        self.imagePicker=nil;
    }
    self.imagePicker=[[UIImagePickerController alloc]init];
    self.imagePicker.delegate=self;
    self.imagePicker.allowsEditing=YES;
    self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];

   }

// image picker delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    img = [info valueForKey: UIImagePickerControllerOriginalImage];
   NSData *imageData = UIImagePNGRepresentation(img);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.ig"]]; //add our image to the path
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
   
    
    
    
     NSURL * url = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString * urlStr=[url absoluteString];
    urlStr=[urlStr stringByReplacingOccurrencesOfString:@"JPG" withString:@"ig"];
    NSArray * parts = [urlStr componentsSeparatedByString: @"="];
   if ([urlStr rangeOfString:@"id="].location!=NSNotFound) {
        
         imgId = [parts objectAtIndex: 1];
       imgId=[imgId stringByReplacingOccurrencesOfString:@"&ext" withString:@""];
       localUrl=fullPath;
        localUrl = [NSString stringWithFormat:@"file://%@",localUrl];
        [self dismissViewControllerAnimated:YES completion:^{
            [self goToComposeVc];
           
        }];
    }
}

// Got to compose View controller
-(void)goToComposeVc{
    if (composeVC) {
        composeVC=nil;
    }
    composeVC=[[ComposeViewController alloc]initWithNibName:@"ComposeViewController" bundle:nil];
    composeVC.img=img;
    composeVC.imgId=imgId;
    composeVC.imgPath=[NSURL URLWithString:localUrl];
    
    [self presentViewController:composeVC animated:YES completion:nil];
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
        // [self.dic setAnnotation:[NSDictionary dictionaryWithObject:[SingletonClass shareSinglton].captionStr forKey:@"InstagramCaption"]];
            [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
        
    }
    
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
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(database);
    [scheduleTbl reloadData];
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
