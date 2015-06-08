

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
{
    sqlite3 * database;
    NSMutableArray * allData;
}

@end

