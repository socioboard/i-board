

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ComposeViewControllerIboard : UIViewController<UIDocumentInteractionControllerDelegate,UITextViewDelegate>
{
    CGSize windowSize;
    BOOL isDate;
    NSDate * dateFire;
    sqlite3 * database;
    time_t  unixTime;
}
@property(nonatomic,strong)UIImage * img;
@property(nonatomic,strong)UIView * headerView,* tabView;
@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSURL * imgPath;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property(nonatomic,strong)NSString * imgId;

@end
