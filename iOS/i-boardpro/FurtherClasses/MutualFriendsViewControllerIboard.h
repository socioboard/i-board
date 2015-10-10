

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MutualFriendsViewControllerrIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>
{
    CGSize windowSize;
    UITableView * mutualTbl;
}

@property(nonatomic,strong)GADBannerView *bannerView;
@end
