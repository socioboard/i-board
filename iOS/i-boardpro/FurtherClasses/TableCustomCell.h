

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>




@interface TableCustomCell : UITableViewCell
{
    CGSize windowSize;
}
@property(nonatomic,strong)UIImageView * userImage,* feedImage,* profileImg,* menuImages,* cmtUserImage,*feedsUserImage;
@property(nonatomic,strong)UIButton * add_minusButton,* settingButton,* commentBtn,*add_plusButton,* likesBtn,* commentCnt;
@property(nonatomic,strong)UILabel * userNameDesc,*likesLbl,* likesCount,* cellTitle,*feedsUsername,* listCopy ;

@property(nonatomic,strong)UIView * topView,* bottomView;


@property(nonatomic,strong) UILabel * cellMenuTitle,* cmtUserName;
@property(nonatomic,strong)UITextView * cmtTxtView;


@property(nonatomic,strong)GADBannerView *bannerView;

@property(nonatomic,strong)UILabel * mediaCount,* hashName;

@end
