

#import <UIKit/UIKit.h>

@interface FollwViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView * followTableView;
    NSMutableArray * usreId;
   
}

@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
