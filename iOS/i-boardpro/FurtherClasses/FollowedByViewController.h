

#import <UIKit/UIKit.h>

@interface FollowedByViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView * followTableView;
    UIActivityIndicatorView * activityIndicator;
    NSString * bio;
    
}
@property (nonatomic, retain) UIDocumentInteractionController *dic;

@end
