

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface WebViewViewControllerIboard : UIViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{
    NSMutableArray * urlParts;
    CGSize  windowSize;
    NSString * userID;
    sqlite3 * _database;
    
}
@property(nonatomic, strong)UIWebView * webView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;

-(void)createUI;

@end
