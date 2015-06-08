

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate>
{
    CGSize windowSize;
     NSString * bio;
}
@property(nonatomic,strong)UICollectionView * mainCollectionView;
@property(nonatomic,strong)NSMutableArray * imageUrl;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
