

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NonFollowerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,GADBannerViewDelegate>
{
    NSMutableArray *  full_name,*  profilePic;
    UITableView * nonFollowTbl;
     CGSize windowSize;
    NSMutableArray * usreId;
    NSString * pagination,* paginationForFollwedBy;
}
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property(nonatomic,strong)GADBannerView *bannerView;
@end
