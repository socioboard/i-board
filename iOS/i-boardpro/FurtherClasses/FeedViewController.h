

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView * feedTableView;
    UIActivityIndicatorView * activityView;
    CGSize windowSize;
    NSMutableArray * userId;
    NSString * pagination,*nextMaxId;
}
@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
