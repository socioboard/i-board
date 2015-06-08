

#import <UIKit/UIKit.h>

@interface CustomMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate> {
    
    UIImageView *imageVUser;
    UILabel *lblUserName;
    
    UIView *viewBooster;
    NSUserDefaults *userDefault;
    int totalDiamond;
    UIButton *btnDiamond,*btnDiamondPlus;
    UIButton *btnBooster,*btnBoosterPlus;
    UIButton *btnLife,*btnLifePlus;
    UILabel *lblLifeTime;
    NSTimer *timer;
    NSTimer *timerForBooster;
    int time,boosterTime;
    UILabel * lblUserRank;
    //----------
    CGRect screenSize;
    UIView * rejectView;
    
    NSMutableDictionary * selectedUser;
     NSArray * menuImages;
    CGSize windowSize;
}



@property (nonatomic, assign) BOOL isSignIn;

@property (nonatomic, assign) CGFloat screen_height;

@property (nonatomic, strong) UIButton *menuButton,*profileImage;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *topicButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *boosterView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UITableView *menuTableView,*accountTableView;
@property (nonatomic, strong) UILabel *firstSectionHeader;
@property (nonatomic, strong) UILabel *secondHeaderLabel;



@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *tabViewControllersArray,*titleOfTabBar;
@property (nonatomic, strong) NSArray *secondSectionViewControllers;
@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, copy) UIViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, strong) UIView *mainsubView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureLeft,*swipeGestureRight;

@property(nonatomic,strong)NSMutableDictionary * dict;


-(NSArray *) getAllViewControllers;
@end

@interface UIViewController (CustomMenuViewControllerItem)

@property (nonatomic, strong) CustomMenuViewController *customMenuViewController;
//-(CustomMenuViewController *)firstAvailableViewController;

-(void)reloadAccountTbl;
@end
