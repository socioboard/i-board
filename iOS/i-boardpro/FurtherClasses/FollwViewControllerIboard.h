

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FollwViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,GADBannerViewDelegate>
{
    UITableView * followTableView;
    NSMutableArray * usreId;
    NSString * pagination;
}

@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;

@property(nonatomic,strong)GADBannerView *bannerView;
@end
