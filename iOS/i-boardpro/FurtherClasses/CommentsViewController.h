

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface CommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,GADBannerViewDelegate>
{
    UITableView *commentsTbl;
    CGSize windowSize;
     NSMutableArray * cmtTextArr,* cmtUserImgArr,* cmtUserName,*cmtMediaId;
}
@property(nonatomic,strong)NSString * capId;
@property(nonatomic,assign)int index;
@property(nonatomic,strong)UIView * headerView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property(nonatomic,strong) UIImage * feedImage;
@property(nonatomic,strong)NSDictionary * resultDict;

@property(nonatomic,strong)GADBannerView *bannerView;

@end
