

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FansViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>
{
    CGSize windowSize;
    UITableView * fansTable;
}

@property(nonatomic,strong)GADBannerView *bannerView;
@end
