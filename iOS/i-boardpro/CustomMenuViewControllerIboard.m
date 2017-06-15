


#import "CustomMenuViewControllerIboard.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "WebViewViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "ProfileViewControllerIboard.h"
#import <MessageUI/MessageUI.h>

@interface CustomMenuViewControllerIboard ()<UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSInteger updateValue;
     sqlite3 * database;
    UIImageView * viewLogo;
    UIImageView * selectedUserImg;
    UIButton * logOut;
    NSArray *accImageArray;
    NSArray *buttonTitleAccTable;
//    UIDocumentInteractionController *documectentationcontroller;
}
@property (nonatomic, strong) UIDocumentInteractionController *documentationcontroller;
@property (nonatomic,strong)UITabBar *customTabBar;
@end

@implementation CustomMenuViewControllerIboard
@synthesize viewControllers = _viewControllers;




#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    
   
}
-(void)viewDidAppear:(BOOL)animated
{
       [self.menuTableView reloadData];
}

#pragma mark -
-(void) setViewControllers:(NSArray *)viewControllers{
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *viewController in _viewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-140);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSecondSectionViewControllers:(NSArray *)secondSectionViewControllers{
    
    _secondSectionViewControllers = [secondSectionViewControllers copy];
    
    for (UIViewController *viewController in _secondSectionViewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSelectedViewController:(UIViewController *)selectedViewController{
    _selectedViewController = selectedViewController;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

-(NSArray *) getAllViewControllers{
    return self.viewControllers;
}
-(void) setSelectedSection:(NSInteger)selectedSection{
    _selectedSection = selectedSection;
}

#pragma mark-

// reload account Table
-(void)reloadAccountTbl{
   
    [self.accountTableView reloadData];
    
}

// Changing header image according to selected user.
-(void)changeHeaderImg{
//    if([[SingletonClassIboard shareSinglton].user_pic length] == 0){
//       
        NSString *urlstring = [[NSUserDefaults standardUserDefaults]objectForKey:@"userprofile_picture"];
        NSURL * url=[NSURL URLWithString:urlstring];
        //    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
        
        NSData * data=[NSData dataWithContentsOfURL:url];
        
        [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        selectedUserImg.image=[UIImage imageWithData:data];
        
//    }
//    
//    else{
//     NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
//    
//    NSData * data=[NSData dataWithContentsOfURL:url];
//    
//    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//    selectedUserImg.image=[UIImage imageWithData:data];
//    }
    
}


#pragma mark -
- (void)viewDidLoad
{
    
    
    menuImages=[NSArray arrayWithObjects:@"iboard-feeds.png",@"iboard-follow_new.png",@"iboard-followed_by_new.png",@"iboard-fan_new.png",@"iboard-mutual.png",@"iboard-non_follower.png",@"iboard-photo_que_new.png",@"iboard-search.png",@"iboard-nearby.png", nil];
    //--------
    accImageArray=[NSArray arrayWithObjects:@"add_acount_icon.png",@"feed_back_icon.png",nil];
      buttonTitleAccTable=[NSArray arrayWithObjects:@"Add Accounts",@"Feedback",nil];
    
    
    windowSize=[UIScreen mainScreen].bounds.size;
    [super viewDidLoad];
    self.dict=[NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAccountTbl) name:@"reloadData" object:nil];
    
    screenSize = [UIScreen mainScreen].bounds;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    
    self.screen_height = [UIScreen mainScreen].bounds.size.height;
    self.isSignIn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuTable:) name:@"UpdateMenuTable" object:nil];
    
    //Add View SubView;
    self.mainsubView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, self.screen_height-45)];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
    self.mainsubView.backgroundColor = [UIColor whiteColor];
    self.mainsubView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainsubView.layer.shadowOpacity = 0.4f;
    self.mainsubView.layer.shadowOffset = CGSizeMake(0.0f, 15.0f);
    self.mainsubView.layer.shadowRadius = 10.0f;
    self.mainsubView.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.mainsubView.bounds];
    self.mainsubView.layer.shadowPath = path.CGPath;
    [self.view addSubview:self.mainsubView];
    
    //Add Header View
    CGFloat hh;
    CGRect frame_b;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hh = 75;
        frame_b = CGRectMake(680, 30, 45, 25);
        
    }
    else{
        hh = 55;
        
        frame_b = CGRectMake(20, 20, 45, 25);

    }
    CGRect frame = CGRectMake(0, 0, screenSize.size.width, hh);
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor =[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.mainsubView addSubview:self.headerView];
    
    NSLog(@"Width menu== %f",screenSize.size.width);
    
    
    //=======================================
    // Add Container View
    frame = CGRectMake(0,55, screenSize.size.width, screenSize.size.height-55);
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];
    //------------------
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame =  CGRectMake(20, 20, 30, 25);;
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    self.menuButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"iboard-menu_icon.png"] forState:UIControlStateNormal];
    
    [self.headerView addSubview:self.menuButton];
    
    self.profileImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.profileImage.frame = CGRectMake(windowSize.width-60, 15, 35, 35);
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds=YES;

    NSString *urlstring = [[NSUserDefaults standardUserDefaults]objectForKey:@"userprofile_picture"];
    NSURL * url=[NSURL URLWithString:urlstring];
//    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
    NSData * data=[NSData dataWithContentsOfURL:url];

    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    [self.headerView addSubview:self.profileImage];
    UITapGestureRecognizer *tapgestureonprofilepic = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showaccounttableonclick:)];
    [self.profileImage addGestureRecognizer:tapgestureonprofilepic];
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, windowSize.width-120, 30)];
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.menuLabel.font = [UIFont boldSystemFontOfSize:20];
    self.menuLabel.textColor = [UIColor whiteColor];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    self.menuLabel.text = _selectedViewController.title;
    [self.headerView addSubview:self.menuLabel];
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
    [self updateViewContainer];
    [self createMenuTableView];
    [self createAccountTable];
    self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
    self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGestureLeft];
       self.swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight:)];
    self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainsubView addGestureRecognizer:self.swipeGestureRight];

}
#pragma mark -taponprofilepic
-(void)showaccounttableonclick:(UITapGestureRecognizer *)swipeGesture{
    if (self.mainsubView.frame.origin.x==0)
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-180, 0,screenSize.size.width, screenSize.size.height-45);
            self.accountTableView.hidden=NO;
            viewLogo.hidden=NO;
            logOut.hidden=NO;
        }completion:^(BOOL finish){
            
//            self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
//             self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
  
    
    
}

#pragma mark - handle swipe gesture

//Handle swipe gesture on right side
-(void)handleSwipeGestureRight:(UISwipeGestureRecognizer *)swipeGesture
{
    
    if (self.mainsubView.frame.origin.x==0) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.accountTableView.hidden=YES;
            viewLogo.hidden=YES;
            logOut.hidden=YES;
            self.mainsubView.frame = CGRectMake(200, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
//                self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            self.accountTableView.hidden=YES;
            viewLogo.hidden=YES;
            logOut.hidden=YES;
//            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
    }
}

//Handle swipe gesture on right side
-(void)handleSwipeGestureLeft:(UISwipeGestureRecognizer *)swipeGesture
{
    if (self.mainsubView.frame.origin.x==0)
    {
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-180, 0,screenSize.size.width, screenSize.size.height-45);
            self.accountTableView.hidden =NO;
            viewLogo.hidden=NO;
            logOut.hidden=NO;
        }completion:^(BOOL finish){
//             self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
//             self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
}

#pragma mark -
// onclick menu button move main subview to right side.
-(void) menuButtonClciked:(id)sender
{
    self.accountTableView.hidden=YES;
    viewLogo.hidden=YES;
    logOut.hidden=YES;
    if (self.mainsubView.frame.origin.x>=120) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
//            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(200, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
//            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
    }
    
    
}
#pragma mark -Create Table
//Create account Table for maintaing accounts
-(void)createAccountTable
{
    if (!self.accountTableView)
    {
        self.selectedIndex = 0;
        self.accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenSize.size.width-160, 150,180, self.screen_height-140) style:UITableViewStylePlain];
        
        self.accountTableView.backgroundColor =[UIColor whiteColor];
        
        self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.accountTableView.delegate = self;
        self.accountTableView.dataSource = self;
        self.accountTableView.showsVerticalScrollIndicator = NO;
        
        
    }
    else
    {
        [self.accountTableView reloadData];
    }
    
    [self.view insertSubview:self.accountTableView belowSubview:self.mainsubView];
    
    viewLogo=[[UIImageView alloc]init];
    viewLogo.frame=CGRectMake(screenSize.size.width-180, 0,200, 150);
    viewLogo.image = [UIImage imageNamed:@"iboard-headerbg.jpeg"];
    
    [self.view insertSubview:viewLogo belowSubview:self.mainsubView];
    
    UILabel * acounts=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 120, 150)];
    acounts.text=@"Accounts";
    acounts.font=[UIFont boldSystemFontOfSize:20];
    acounts.textColor=[UIColor whiteColor];
   // [viewLogo addSubview:acounts];
    NSString *urlstring = [[NSUserDefaults standardUserDefaults]objectForKey:@"userprofile_picture"];
    NSURL * url=[NSURL URLWithString:urlstring];
    
//    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    selectedUserImg=[[UIImageView alloc]initWithFrame:CGRectMake(viewLogo.frame.size.width/2-40, 50, 70, 70)];
    selectedUserImg.image=[UIImage imageWithData:data];
    selectedUserImg.layer.cornerRadius=selectedUserImg.frame.size.width/2;
    selectedUserImg.clipsToBounds=YES;
    [viewLogo addSubview:selectedUserImg];
    
   
 //------------------
    // Add Logout button
    //-----------------
     logOut=[[UIButton alloc]init];
    logOut.frame=CGRectMake(screenSize.size.width-150,screenSize.size.height-80 , 121, 29);
    [logOut setBackgroundImage:[UIImage imageNamed:@"iboard-add_account.png"] forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(addAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [logOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view insertSubview:logOut belowSubview:self.mainsubView];
    
}

// Onclick call webView for another account login
-(void)addAccountAction{
//    [SingletonClassIboard shareSinglton].fromAddAccount=YES;
//    if (webviewVC) {
//        webviewVC=nil;
//    }
//    webviewVC=[[WebViewViewControllerIboard alloc]initWithNibName:@"WebViewViewControllerIboard" bundle:nil];
//    [self presentViewController:webviewVC animated:YES completion:^{
//    }];

}

// Create menu Table for showing menu items
-(void) createMenuTableView
{
    
    if (!self.menuTableView)
    {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,200, self.screen_height-140) style:UITableViewStylePlain];
        self.menuTableView.backgroundColor=[UIColor whiteColor];
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.showsVerticalScrollIndicator = NO;
       
    }
    else
    {
      [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    
    UIView * viewLogo1=[[UIView alloc]init];
    viewLogo1.frame=CGRectMake(0,0,200, 55);
    viewLogo1.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    self.menuTableView.tableHeaderView = viewLogo1;
//    [self.view insertSubview:viewLogo1 belowSubview:self.mainsubView];
    

    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.4f;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, -10.0f);
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.mainsubView.bounds];
    self.view.layer.shadowPath = path.CGPath;

    
    UIImageView * logo=[[UIImageView alloc]initWithFrame:CGRectMake(15, self.screen_height-140, 150, 30)];
    logo.image=[UIImage imageNamed:@"iboardpro.png"];
    [self.view insertSubview:logo belowSubview:self.mainsubView];
     
    
}

#pragma mark -



#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==self.accountTableView)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.menuTableView)
    {
    if (section==0) {
        
        return self.viewControllers.count;
    }
    else if (section == 1){
        return self.secondSectionViewControllers.count;
    }
    }
    else if (tableView==self.accountTableView)
    {
   
        if(section==0){
        return [SingletonClassIboard shareSinglton].allData.count;
         }
        else if (section==1)
        {
            return 2;
        }
    }
    return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menuTable";
    
    TableCustomCell *cell = (TableCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //Check table name
    if(tableView==self.menuTableView)
    {
    NSString * title=[NSString stringWithFormat:@"%@",[(UIViewController *)[_viewControllers objectAtIndex:indexPath.row] title]];
    NSLog(@"Title = %@",title);
    
        cell.cellMenuTitle.text=title;
        cell.cellMenuTitle.font=[UIFont systemFontOfSize:14];
        cell.cellMenuTitle.numberOfLines=0;
        cell.cellMenuTitle.lineBreakMode=NSLineBreakByCharWrapping;
        cell.menuImages.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuImages objectAtIndex:indexPath.row]]];
        cell.settingButton.hidden=YES;
        
    }
    else if(tableView==self.accountTableView)
    {
        if(indexPath.section == 0){
        cell.settingButton.hidden=NO;
        _dict=[[SingletonClassIboard shareSinglton].allData objectAtIndex:indexPath.row];
        NSString * name=[self.dict objectForKey:@"userFullName"];
        cell.cellTitle.text=name;
        cell.cellTitle.numberOfLines=0;
        cell.cellTitle.lineBreakMode=NSLineBreakByCharWrapping;
        cell.cellTitle.font=[UIFont systemFontOfSize:12];
        
        NSURL * url=[self.dict objectForKey:@"profilePic"];
        [cell.profileImg sd_setImageWithURL:url];
        
        cell.settingButton.tag=indexPath.row;
        [cell.settingButton addTarget:self action:@selector(propfilePage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        else if (indexPath.section == 1){
//            cell.cellTitle.hidden=YES;
            cell.settingButton.hidden=YES;
            
            cell.cellTitle.text = [buttonTitleAccTable objectAtIndex:indexPath.row];
            cell.cellTitle.font=[UIFont systemFontOfSize:12];
            cell.profileImg.image = [UIImage imageNamed:[accImageArray objectAtIndex:indexPath.row]];
            
            
//            UIImageView * imgViewFooter=[[UIImageView alloc]init];
//            imgViewFooter.image=[UIImage imageNamed:[accImageArray objectAtIndex:indexPath.row]];
//            imgViewFooter.frame=CGRectMake(0, 5, 30, 30);
//
//            imgViewFooter.layer.cornerRadius=15;
//            [cell.contentView addSubview:imgViewFooter];
//            //------------
//            UILabel * title=[[UILabel alloc]init];
//            title.frame=CGRectMake(35, 0, 102, 40);
//            title.text=[buttonTitleAccTable objectAtIndex:indexPath.row];
//            title.textColor=[UIColor blackColor];
//            title.font=[UIFont systemFontOfSize:12];
//            [cell.contentView addSubview:title];
            
            
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.menuTableView) {
        
    
    
    //Dismiss Menu TableView with Animation
    [UIView animateWithDuration:.5 animations:^{
        
        self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height-45);
        
    }completion:^(BOOL finished){
        //After completion
        //first check if new selected view controller is equals to previously selected view controller
        UIViewController *newViewController = [_viewControllers objectAtIndex:indexPath.row];
        if ([newViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
        }
        
        if (indexPath.row==1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadAllFollowers" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadAllFollowers" object:nil];
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:1];
        }
        else if(indexPath.row==2){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadAllFollowedBy" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadAllFollowedBy" object:nil];
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:2];
            
        }
        else if (indexPath.row==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFeeds" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadFeeds" object:nil];
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
        }
        else if (indexPath.row==3)
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showFans" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showFans" object:nil];
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:3];
        }
        else if (indexPath.row==4)
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showMutualFrnds" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showMutualFrnds" object:nil];
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:4];
        }
        else if (indexPath.row==5)
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadNonFollower" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadNonFollower" object:nil];
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:6];
        }
        else if (indexPath.row==6)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"schedulePhoto" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"schedulePhoto" object:nil];
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:7];
        }
        if(indexPath.row==7)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"#Tags" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"#Tags" object:nil];
        }
        if(indexPath.row==8)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Location" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Location" object:nil];
        }
        if (indexPath.row ==9) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"#Tags" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"#Tags" object:nil];
        }
        if (indexPath.row ==10) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Location" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Location" object:nil];
        }
        
        _selectedSection = indexPath.section;
        _selectedIndex = indexPath.row;
        
        [self getSelectedViewControllers:newViewController];
        updateValue = 0;
    }];
    }
    else{
        
        if(indexPath.section==0)
        {
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finished){
            //After completion
            //first check if new selected view controller is equals to previously selected view controller
            UIViewController *newViewController = [_viewControllers objectAtIndex:0];
            if ([newViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
            }
            if (self.selectedIndex==indexPath.row  && self.selectedSection == indexPath.section) {
                //  return;
            }
            
            if (selectedUser) {
                selectedUser=nil;
            }
            selectedUser=[NSMutableDictionary dictionary];
            selectedUser=[[SingletonClassIboard shareSinglton].allData objectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:[selectedUser objectForKey:@"accessToken"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [SingletonClassIboard shareSinglton].user_pic=[selectedUser objectForKey:@"profilePic"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[SingletonClassIboard shareSinglton].user_pic forKey:@"userprofile_picture"];
            
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFeeds" object:@"userMenu"];
            
              [self changeHeaderImg];
            
            
           
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadFeeds" object:nil];
                self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
            
                     _selectedSection = indexPath.section;
            _selectedIndex = indexPath.row;
            
            [self getSelectedViewControllers:newViewController];
            updateValue = 0;
        }];
        
        
    }
    self.topicButton.hidden=YES;
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            [self addAccount];
        }
        else if (indexPath.row==1)
        {
            
            [self showEmail];
            
        }
    }

}


-(void)showEmail{
//    if (![MFMailComposeViewController canSendMail]) {
//        NSLog(@"Mail services are not available.");
//        return;
//    }
    
    NSString *url=@"";
    NSArray *objectsToShare = @[UIActivityTypeMessage,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[url, UIActivityTypeMessage,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];

//    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
//    composeVC.mailComposeDelegate = self;
//    // Configure the fields of the interface.
//    [composeVC setToRecipients:@[@"address@example.com"]];
//    [composeVC setSubject:@"Hello!"];
//    [composeVC setMessageBody:@"Hello from California!" isHTML:NO];
//    
//    // Present the view controller modally.
//    [self presentViewController:composeVC animated:YES completion:nil];
//
    
    
    
}
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark add new instagram user
-(void)addAccount{
    [SingletonClassIboard shareSinglton].fromAddAccount=YES;
    WebViewViewControllerIboard *  webviewVC=[[WebViewViewControllerIboard alloc]init];
    [self presentViewController:webviewVC animated:YES completion:^{
    }];
}
#pragma mark -
-(void) getSelectedViewControllers:(UIViewController *)newViewController{
    // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
        
        //Update Container View with selected view controller view
        [self updateViewContainer];
        //Check Delegate assign or not
    }
}
-(void) updateViewContainer
{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
    self.menuLabel.text=self.selectedViewController.title;
    NSLog(@"menu label -=- %@",self.menuLabel.text);
    
    [self.contentContainerView addSubview:self.selectedViewController.view];
    
}

// on click setting button show  user profile
-(void)propfilePage:(UIButton*)sender{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!!!"
                                  message:@"Are you sure you want to remove this account?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             
                             int tag = (int)((UIButton *)(UIControl *)sender).tag;
                             
                             if (selectedUser) {
                                 selectedUser=nil;
                             }
                             NSLog(@"%@",[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag]);
                             selectedUser=[NSMutableDictionary dictionary];
                             selectedUser=[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag];
                       
                        _removeuseraccessToken = [selectedUser objectForKey:@"accessToken"] ;
                             
                             [self disconnectAccount];
                             

                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

    
    
//    
//    int tag = (int)((UIButton *)(UIControl *)sender).tag;
//    
//    if (selectedUser) {
//        selectedUser=nil;
//    }
//    NSLog(@"%@",[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag]);
//    selectedUser=[NSMutableDictionary dictionary];
//    selectedUser=[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag];
//    
//    
//    ProfileViewController * profileVC=[[ProfileViewController alloc]init];
//    profileVC.accessToken=[selectedUser objectForKey:@"accessToken"] ;
//    
//    
//    
//    
//  
//    [self presentViewController:profileVC animated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getDataForProfile" object:nil];
    
}
-(void)disconnectAccount{
    
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentPath=[paths objectAtIndex:0];
    NSString * databasePath=  [documentPath stringByAppendingPathComponent:@"board7.sqlite"];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        
        NSString * query= [NSString stringWithFormat:@"DELETE FROM InstaBoard where AccessToken=\"%@\"",_removeuseraccessToken];
        
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

-(void)retreiveDataFromSqlite{
    
    [[SingletonClassIboard shareSinglton].allData removeAllObjects];
    
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
            
            [[SingletonClassIboard shareSinglton].allData removeAllObjects];
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
                
                [[SingletonClassIboard shareSinglton].allData addObject:temp];
            }
            
        }
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(database);
    
    
    if ([SingletonClassIboard shareSinglton].allData.count<1) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.modalPresentationStyle=UIModalTransitionStyleFlipHorizontal;
        [[self.presentingViewController presentingViewController]dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [SingletonClassIboard shareSinglton].customDismiss=YES;
    }
    else{
        
        NSString *profilestring = [[[SingletonClassIboard shareSinglton].allData lastObject]objectForKey:@"profilePic"];
        [[NSUserDefaults standardUserDefaults]setObject:profilestring forKey:@"userprofile_picture"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

//- (UIDocumentInteractionController *)controller {
//    
//    if (!_documentationcontroller) {
//        _documentationcontroller = [[UIDocumentInteractionController alloc]init];
//        _documentationcontroller.delegate = self;
//    }
//    return _documentationcontroller;
//}

#pragma mark-----
@end

static void * const kMyPropertyAssociatedStorageKey = (void*)&kMyPropertyAssociatedStorageKey;

@implementation UIViewController (CustomMenuViewControllerIboardItem)
@dynamic CustomMenuViewControllerIboard;

static char const * const orderedElementKey;

-(void) setCustomMenuViewControllerIboard:(CustomMenuViewControllerIboard *)CustomMenuViewControllerIboard{
    
    NSLog(@"cc==%@",CustomMenuViewControllerIboard.viewControllers);
    
    objc_setAssociatedObject(self, &orderedElementKey, CustomMenuViewControllerIboard,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CustomMenuViewControllerIboard *) CustomMenuViewControllerIboard{
    
    if (objc_getAssociatedObject(self, &orderedElementKey) != nil)
    {
        NSLog(@"Element: %@", objc_getAssociatedObject(self, orderedElementKey));
    }
    
    NSLog(@"Element: %@", objc_getAssociatedObject(self, &orderedElementKey));
    //    return objc_getAssociatedObject(self, @selector(CustomMenuViewControllerIboard));
    return objc_getAssociatedObject(self, orderedElementKey);
    //return  self.CustomMenuViewControllerIboard;
}
//-(void)dealloc
//{
//    NSLog(@"Dealloc Called");
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}



@end
