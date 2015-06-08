

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView *commentsTbl;
    CGSize windowSize;
     NSMutableArray * cmtTextArr,* cmtUserImgArr,* cmtUserName,*cmtMediaId;
}
@property(nonatomic,strong)NSString * capId;
@property(nonatomic,strong)UIView * headerView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
