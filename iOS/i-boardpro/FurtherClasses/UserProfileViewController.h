

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate>
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
@end
