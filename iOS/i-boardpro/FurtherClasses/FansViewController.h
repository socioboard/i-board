

#import <UIKit/UIKit.h>

@interface FansViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGSize windowSize;
    UITableView * fansTable;
}

@end
