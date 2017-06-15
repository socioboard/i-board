

#import "AppDelegate.h"
#import <sqlite3.h>
#import "ComposeViewControllerIboard.h"
#import "SingletonClassIboard.h"
#import "Flurry.h"
#import "HelperClassIboard.h"
#import <UserNotifications/UserNotifications.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GADMobileAds configureWithApplicationID:@"XXXXXXXXXX****************XXXXXXXXXXXXXXXXX"];

    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        application.applicationIconBadgeNumber = 0;
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
      
    }
    
    
    
    [Flurry startSession:flurryId_iboard];
    
    if (localNotification)
    {
        
        for (int i=0; i<[SingletonClassIboard shareSinglton].notfyArr.count; i++) {
            NSMutableDictionary * dict=[[SingletonClassIboard shareSinglton].notfyArr objectAtIndex:i];
            if ([[localNotification.userInfo objectForKey:@"unixTime"] isEqualToString:[dict objectForKey:@"unixTime"]] && [[localNotification.userInfo objectForKey:@"access_token"] isEqualToString:[dict objectForKey:@"access_token"]]) {
                HelperClassIboard * help =[[HelperClassIboard alloc]init];;

                [help fetchNotificationData : [localNotification.userInfo objectForKey:@"unixTime"] andAccesToken:[localNotification.userInfo objectForKey:@"access_token"]];
                
            }
            
        }

        
    }
    
    
    /* Register phone for notification. both iOS 10 and iOS 8,9 */
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 10) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                application.applicationIconBadgeNumber = 0;
            }
        }];
    }
    else if ([[[UIDevice currentDevice] systemVersion] intValue] > 8) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    [self checkNetworkStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:@"reachability" object:nil];// Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSLog(@"My token is: %@", deviceToken);
    NSString * deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]   stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"the generated device token string is : %@",deviceTokenString);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    NSString *userInfo = [response.notification.request.content.userInfo objectForKey:@"instagramPost"];
    
    
    NSDictionary *userInfoDict = response.notification.request.content.userInfo;
    if ([userInfoDict objectForKey:@"follower"]) {
        
    }
    else{
        for (int i=0; i<[SingletonClassIboard shareSinglton].notfyArr.count; i++) {
            NSMutableDictionary *dict=[[SingletonClassIboard shareSinglton].notfyArr objectAtIndex:i];
            if ([[userInfoDict objectForKey:@"unixTime"] isEqualToString:[dict objectForKey:@"unixTime"]] && [[userInfoDict objectForKey:@"access_token"] isEqualToString:[dict objectForKey:@"access_token"]]) {
                
                HelperClassIboard * help =[[HelperClassIboard alloc]init];;
                [help fetchNotificationData : [userInfoDict objectForKey:@"unixTime"] andAccesToken:[userInfoDict objectForKey:@"access_token"]];
                
            }
            
        }
    }

    
    if ([userInfo isEqualToString:@"post in Instagram"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"instagramPostNotification" object:nil];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] - 1;
    }
    completionHandler();
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    application.applicationIconBadgeNumber=0;
    
//    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//    {
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image ready to post"
//                                                            message:@""
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
    
    NSDictionary * dict =notification.userInfo;
    if ([dict objectForKey:@"follower"]) {
        
    }
    else{
        for (int i=0; i<[SingletonClassIboard shareSinglton].notfyArr.count; i++) {
            NSMutableDictionary * dict=[[SingletonClassIboard shareSinglton].notfyArr objectAtIndex:i];
            if ([[notification.userInfo objectForKey:@"unixTime"] isEqualToString:[dict objectForKey:@"unixTime"]] && [[notification.userInfo objectForKey:@"access_token"] isEqualToString:[dict objectForKey:@"access_token"]]) {
                //[self fetchNotificationData : [notification.userInfo objectForKey:@"unixTime"] andAccesToken:[notification.userInfo objectForKey:@"access_token"]];
                HelperClassIboard * help =[[HelperClassIboard alloc]init];;
                [help fetchNotificationData : [notification.userInfo objectForKey:@"unixTime"] andAccesToken:[notification.userInfo objectForKey:@"access_token"]];
        
            }
        }
    }
    
    
    
}


    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
 /*-(void)fetchNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board21.sqlite"];
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        NSString *querySQL=[NSString stringWithFormat:@"select * from Schedule WHERE AccessToken=\"%@\" AND Time=\"%@\"",accessToken,time];
        
        sqlite3_stmt *compiledStmt=nil;
        const char *query_stmt=[querySQL UTF8String];
        NSLog(@"QuerySQL in appdelegate :%@",querySQL);
        NSData * data;
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &compiledStmt, NULL)==SQLITE_OK){
        if(sqlite3_step(compiledStmt)==SQLITE_ROW)
        {
            char *profilepic = (char *) sqlite3_column_text(compiledStmt,1);
            
            char *imgId = (char *) sqlite3_column_text(compiledStmt,2);
            
            int length = sqlite3_column_bytes(compiledStmt, 3);
            data=[NSData dataWithBytes:sqlite3_column_blob(compiledStmt, 3) length:length];
            
            char * time=(char *) sqlite3_column_text(compiledStmt,4);
            char * caption=(char*)sqlite3_column_text(compiledStmt,6);
            NSString *profilePic  = [NSString stringWithUTF8String:profilepic];
            NSString *imageId  = [NSString stringWithUTF8String:imgId];
             NSString *captionStr  = [NSString stringWithUTF8String:caption];
            NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
            
            [temp setObject:profilePic forKey:@"profilePic"];
            [temp setObject:data forKey:@"image"];
            
            
            [SingletonClassIboard shareSinglton].captionStr=captionStr;
            [SingletonClassIboard shareSinglton].imagePath=profilePic;
            [SingletonClassIboard shareSinglton].imageId=imageId;
        }
        }
        else{
          NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(compiledStmt);
        
    }
    sqlite3_close(database);
      [self deleteNotificationData : time andAccesToken:accessToken];
    
    [self performSelector:@selector(fireNotification) withObject:nil afterDelay:2];
    
    
    
}*/
    
    
//-(void)fireNotification{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"firedNotification" object:nil userInfo:nil];
//}





/*-(void)deleteNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board21.sqlite"];
     
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        NSString *querySQL=[NSString stringWithFormat:@"DELETE FROM Schedule where AccessToken=\"%@\" AND Time=\"%@\"",accessToken,time];
        
        sqlite3_stmt *compiledStmt=nil;
        const char *query_stmt=[querySQL UTF8String];
        NSLog(@"QuerySQL in appdelegate :%@",querySQL);
       
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &compiledStmt, NULL)==SQLITE_OK){
        if(sqlite3_step(compiledStmt)==SQLITE_DONE)
        {
            NSLog(@"Deleted Successfull");
        }
        else{
            NSLog(@"ERROR %s",sqlite3_errmsg(database));
        }
    }
        else{
            NSLog(@"ERROR %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStmt);
        
    }
    sqlite3_close(database);
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"scheduleReload" object:nil userInfo:nil];
}*/






#pragma  mark -
// Check Network Status of App
-(void) checkNetworkStatus{
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    
    [self.internetReachability startNotifier];
    
    NetworkStatus a = [self.internetReachability currentReachabilityStatus];
    switch (a) {
        case NotReachable:
          //  NSLog(@"Not Reachable");
            [SingletonClassIboard shareSinglton].isActivenetworkConnection = NO;
            break;
        case ReachableViaWiFi:
           // NSLog(@"Reachable via WAN");
            [SingletonClassIboard shareSinglton].isActivenetworkConnection = YES;
            break;
        case ReachableViaWWAN:
           // NSLog(@"Reachable Via Wifi");
            [SingletonClassIboard shareSinglton].isActivenetworkConnection = YES;
            break;
            
        default:
            break;
    }
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.globussoft.Board" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Board" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Board.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//

//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
