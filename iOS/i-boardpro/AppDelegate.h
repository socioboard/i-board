

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <sqlite3.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIDocumentInteractionControllerDelegate>
{
    sqlite3 * database;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) Reachability *internetReachability;

@property (nonatomic, retain) UIDocumentInteractionController *dic;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

