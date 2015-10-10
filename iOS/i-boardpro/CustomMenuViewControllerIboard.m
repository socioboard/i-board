


#import "CustomMenuViewControllerIboard.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "WebViewViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "ProfileViewControllerIboard.h"

@interface CustomMenuViewControllerIboard ()
{
    NSInteger updateValue;
    WebViewViewControllerIboard * webviewVC;
    UIView * viewLogo;
    UIImageView * selectedUserImg;
    UIButton * logOut;
}
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
    return YES;
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
    
    
    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    selectedUserImg.image=[UIImage imageWithData:data];
    
}


#pragma mark -
- (void)viewDidLoad
{
    
    
    menuImages=[NSArray arrayWithObjects:@"iboard-feeds.png",@"iboard-follow_new.png",@"iboard-followed_by_new.png",@"iboard-fan_new.png",@"iboard-mutual.png",@"iboard-photo_bucket.png",@"iboard-non_follower.png",@"iboard-photo_que_new.png",@"iboard-copy.png",@"iboard-search.png",@"iboard-nearby.png", nil];
    
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
    self.mainsubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.screen_height-45)];
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
    self.profileImage.frame = CGRectMake(windowSize.width-60, 15, 30, 30);
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds=YES;

    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    [self.headerView addSubview:self.profileImage];
    
    
    //===================================
    
    //Add Menu Lable
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, windowSize.width-120, 30)];
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.menuLabel.font = [UIFont boldSystemFontOfSize:20];
    self.menuLabel.textColor = [UIColor whiteColor];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    self.menuLabel.text = _selectedViewController.title;
    [self.headerView addSubview:self.menuLabel];
    
    //====================================
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
    [self updateViewContainer];
    [self createMenuTableView];
    [self createAccountTable];
    //Adding Swipr Gesture
    
          //===============
    self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
    self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGestureLeft];
    //===============
    self.swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight:)];
    self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainsubView addGestureRecognizer:self.swipeGestureRight];

}
#pragma mark -
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
    
  viewLogo=[[UIView alloc]init];
    viewLogo.frame=CGRectMake(screenSize.size.width-160, 0, 180, 150);
    viewLogo.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"iboard-headerbg.jpeg"]];
    
    [self.view insertSubview:viewLogo belowSubview:self.mainsubView];
    
    UILabel * acounts=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 120, 150)];
    acounts.text=@"Accounts";
    acounts.font=[UIFont boldSystemFontOfSize:20];
    acounts.textColor=[UIColor whiteColor];
   // [viewLogo addSubview:acounts];
    
    NSURL * url=[NSURL URLWithString:[SingletonClassIboard shareSinglton].user_pic];
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
    [self.view insertSubview:logOut belowSubview:self.mainsubView];
    
}

// Onclick call webView for another account login
-(void)addAccountAction{
    [SingletonClassIboard shareSinglton].fromAddAccount=YES;
    if (webviewVC) {
        webviewVC=nil;
    }
    webviewVC=[[WebViewViewControllerIboard alloc]initWithNibName:@"WebViewViewControllerIboard" bundle:nil];
    [self presentViewController:webviewVC animated:YES completion:nil];
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
    viewLogo1.frame=CGRectMake(0, self.screen_height-140, 150, 55);
    viewLogo1.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
   // [self.view insertSubview:viewLogo1 belowSubview:self.mainsubView];
    

    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.4f;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, -10.0f);
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.mainsubView.bounds];
    self.view.layer.shadowPath = path.CGPath;

    
    UIImageView * logo=[[UIImageView alloc]initWithFrame:CGRectMake(15, self.screen_height-120, 150, 30)];
    logo.image=[UIImage imageNamed:@"iboardpro.png"];
    [self.view insertSubview:logo belowSubview:self.mainsubView];
     
    
}

#pragma mark -

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
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
}

//Handle swipe gesture on right side
-(void)handleSwipeGestureLeft:(UISwipeGestureRecognizer *)swipeGesture
{
       if (self.mainsubView.frame.origin.x==0)
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-160, 0,screenSize.size.width, screenSize.size.height-45);
            self.accountTableView.hidden=NO;
            viewLogo.hidden=NO;
            logOut.hidden=NO;
        }completion:^(BOOL finish){
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
          

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
            
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(200, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
    }
    
    
}

#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
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
        return [SingletonClassIboard shareSinglton].allData.count;
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
        cell.cellMenuTitle.font=[UIFont systemFontOfSize:12];
        cell.cellMenuTitle.numberOfLines=0;
        cell.cellMenuTitle.lineBreakMode=NSLineBreakByCharWrapping;
        cell.menuImages.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuImages objectAtIndex:indexPath.row]]];
        cell.settingButton.hidden=YES;
        
    }
    else if(tableView==self.accountTableView)
    {
        cell.settingButton.hidden=NO;
        self.dict=[[SingletonClassIboard shareSinglton].allData objectAtIndex:indexPath.row];
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
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getUserPhotos" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getUserPhotos" object:nil];
             self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:5];
        }
        else if (indexPath.row==6)
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadNonFollower" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadNonFollower" object:nil];
             self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:6];
        }
        if(indexPath.row==7)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"schedulePhoto" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"schedulePhoto" object:nil];
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:7];
        }
        if(indexPath.row==8)
        {
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:8];
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
        
        
        //Dismiss Menu TableView with Animation
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
    int tag = (int)((UIButton *)(UIControl *)sender).tag;
    
    if (selectedUser) {
        selectedUser=nil;
    }
    NSLog(@"%@",[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag]);
    selectedUser=[NSMutableDictionary dictionary];
    selectedUser=[[SingletonClassIboard shareSinglton].allData objectAtIndex:tag];
    
    
    ProfileViewController * profileVC=[[ProfileViewController alloc]init];
    profileVC.accessToken=[selectedUser objectForKey:@"accessToken"] ;
  
    [self presentViewController:profileVC animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getDataForProfile" object:nil];
    
}

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
