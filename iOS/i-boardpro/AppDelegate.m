//
//  AppDelegate.m
//  Board
//
//  Created by Sumit Ghosh on 21/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>
#import "ComposeViewController.h"
#import "SingletonClass.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    
    if (localNotification)
    {
        
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"firedNotification" object:nil userInfo:nil];
        
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [self checkNetworkStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];// Override point for customization after application launch.
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    // [self firedNotification];
    application.applicationIconBadgeNumber=0;
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image ready to post"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    for (int i=0; i<[SingletonClass shareSinglton].notfyArr.count; i++) {
        NSMutableDictionary * dict=[[SingletonClass shareSinglton].notfyArr objectAtIndex:i];
        if ([[notification.userInfo objectForKey:@"unixTime"] isEqualToString:[dict objectForKey:@"unixTime"]] && [[notification.userInfo objectForKey:@"access_token"] isEqualToString:[dict objectForKey:@"access_token"]]) {
            [self fetchNotificationData : [notification.userInfo objectForKey:@"unixTime"] andAccesToken:[notification.userInfo objectForKey:@"access_token"]];
            [self deleteNotificationData : [notification.userInfo objectForKey:@"unixTime"] andAccesToken:[notification.userInfo objectForKey:@"access_token"]];
        }
        
    }
    
    //[self retreiveDataFromSqlite];
    
}

-(void)fetchNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board12.sqlite"];
    
    sqlite3_stmt *statement;
    
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        NSString *querySQL=[NSString stringWithFormat:@"SELECT * FROM InstaBoard WHERE AccessToken=\"%@\" AND Time=\"%@\"",accessToken,time];
        
        sqlite3_stmt *compiledStmt=nil;
        const char *query_stmt=[querySQL UTF8String];
        NSLog(@"QuerySQL in appdelegate :%@",querySQL);
        NSData * data;
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL)==SQLITE_OK);
        if(sqlite3_step(statement)==SQLITE_ROW)
        {
            char *profilepic = (char *) sqlite3_column_text(compiledStmt,1);
            
            char *imgId = (char *) sqlite3_column_text(compiledStmt,2);
            
            int length = sqlite3_column_bytes(compiledStmt, 3);
            data=[NSData dataWithBytes:sqlite3_column_blob(compiledStmt, 3) length:length];
            
            NSString *profilePic  = [NSString stringWithUTF8String:profilepic];
            NSString *imageId  = [NSString stringWithUTF8String:imgId];
            
            NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
            
            [temp setObject:profilePic forKey:@"profilePic"];
            [temp setObject:data forKey:@"image"];
            
            
            //[[SingletonClass shareSinglton].postData addObject:temp];
            
            [SingletonClass shareSinglton].imagePath=profilePic;
            [SingletonClass shareSinglton].imageId=imageId;
        }
        sqlite3_finalize(compiledStmt);
        
    }
    sqlite3_close(database);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firedNotification" object:nil userInfo:nil];
    //[self firedNotification];
    
}

-(void)deleteNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"board12.sqlite"];
    
    sqlite3_stmt *statement;
    
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        NSString *querySQL=[NSString stringWithFormat:@"DELETE * FROM InstaBoard WHERE AccessToken=\"%@\" AND Time=\"%@\"",accessToken,time];
        
        sqlite3_stmt *compiledStmt=nil;
        const char *query_stmt=[querySQL UTF8String];
        NSLog(@"QuerySQL in appdelegate :%@",querySQL);
        NSData * data;
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL)==SQLITE_OK);
        if(sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Deleted Successfull");
        }
        sqlite3_finalize(compiledStmt);
        
    }
    sqlite3_close(database);
    
}



// Notification method called when network statu Changed
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    //NSLog(@"current Status = %d",netStatus);
    if (netStatus == 0) {
        NSLog(@"No InternetConeection");
        [SingletonClass shareSinglton].isActivenetworkConnection = NO;
    }
    else if (netStatus>2){
        NSLog(@"Unknown Status");
        [SingletonClass shareSinglton].isActivenetworkConnection = NO;
    }
    else{
        NSLog(@"Active network coneection");
        [SingletonClass shareSinglton].isActivenetworkConnection = YES;
    }
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatusChangeNotification object:nil];
}


#pragma  mark -
// Check Network Status of App
-(void) checkNetworkStatus{
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    
    [self.internetReachability startNotifier];
    
    NetworkStatus a = [self.internetReachability currentReachabilityStatus];
    switch (a) {
        case NotReachable:
            NSLog(@"Not Reachable");
            [SingletonClass shareSinglton].isActivenetworkConnection = NO;
            break;
        case ReachableViaWiFi:
            NSLog(@"Reachable via WAN");
            [SingletonClass shareSinglton].isActivenetworkConnection = YES;
            break;
        case ReachableViaWWAN:
            NSLog(@"Reachable Via Wifi");
            [SingletonClass shareSinglton].isActivenetworkConnection = YES;
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
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.globussoft.Board" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Board" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Board.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
