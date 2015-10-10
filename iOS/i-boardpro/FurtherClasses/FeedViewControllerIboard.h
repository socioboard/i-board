

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FeedViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,GADBannerViewDelegate>
{
    UITableView * feedTableView;
    UIActivityIndicatorView * activityView,* loadActivityView;
    CGSize windowSize;
    NSMutableArray * userId;
    NSString * pagination,*nextMaxId;
}
@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
