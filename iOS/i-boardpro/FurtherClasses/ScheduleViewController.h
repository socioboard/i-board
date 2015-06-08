

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView * scheduleTbl;
    CGSize windowSize;
    UIImage * img;
    NSString * imgId;
}
@property(nonatomic)UIImagePickerController * imagePicker;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
-(void)retreiveDataFromSqlite;
@end
