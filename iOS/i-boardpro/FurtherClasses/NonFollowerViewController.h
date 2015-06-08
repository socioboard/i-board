

#import <UIKit/UIKit.h>

@interface NonFollowerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *  full_name,*  profilePic;
    UITableView * nonFollowTbl;
     CGSize windowSize;
    NSMutableArray * usreId;
}
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
