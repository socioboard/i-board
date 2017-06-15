

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface UserProfileViewControllerIboard : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate,GADBannerViewDelegate>
{
    UIImageView * profileImage,* loggedInImge;
    CGSize windowSize;
    NSString * profilePicStr,* userFullName,* userNameStr;
     NSString * bio;
    UILabel * username,* full_name,* mediaCountLbl,* followsCountLbl,*followingCountLbl   ;
    NSString * mediaCountStr,* followsCountStr,*followingCountStr;
    
    NSMutableArray * imageUrl;
   
}
@property(nonatomic,strong)NSString * accessToken,*userId;
@property(nonatomic,strong)UICollectionView * mainCollectionView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property(nonatomic,strong)GADBannerView *bannerView;
@end
