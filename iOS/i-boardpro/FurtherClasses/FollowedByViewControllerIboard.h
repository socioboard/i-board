

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FollowedByViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,GADBannerViewDelegate>
{
    UITableView * followTableView;
    UIActivityIndicatorView * activityIndicator,* loadActivityView;
    NSString * bio,*pagination;
    
}
@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property(nonatomic,strong)GADBannerView *bannerView;
@end
