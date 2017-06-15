//
//  HelperClassIboard.m
//  i-boardpro
//
//  Created by GBS-ios on 9/9/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "HelperClassIboard.h"
#import "SingletonClassIboard.h"

@implementation HelperClassIboard


+(id)loadFeeds:(NSString*)pagination{
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    NSURL * url;
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (pagination) {
        url =  [NSURL URLWithString:pagination];
    }
    else{
        
        url=[NSURL  URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",access_token]];
    }
    NSMutableURLRequest * getRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return nil;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return response;
    
}


#pragma  mark-  load Followers
+(id)loadAllFollowers:(NSString *)pagination{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
    
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl;
    if (pagination.length == 0) {
        getUrl =   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",accessToken]];
    }
    else{
        getUrl = [NSURL URLWithString:pagination];
    }
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    if (data==nil) {
        return nil;
    }
    id dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dictResponse;
}


+(id)loadAllFollowedBy:(NSString *)pagination{
    
    NSURLResponse * urlResponse;
    NSError * error;
    
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    NSURL * getUrl;
    if (pagination) {
        getUrl =  [NSURL URLWithString:pagination];
    }
    else{
      getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/followed-by?access_token=%@",accessToken]];
    }
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return nil;
    }
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dictResponse;
}

+(id)unfollowAction:(NSString *) userIDStr{
    
    //int tag = (int)((UIButton *)(UIControl *)sender).tag;
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;
    
    
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship",userIDStr]];
    
    
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [request setHTTPMethod:@"POST"];
    NSString * body=[NSString stringWithFormat:@"access_token=%@&action=unfollow",accessToken];
    
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return nil;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return response;
}


+(id)followActions:(NSString *)userId{
    
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSError * error=nil;
    NSURLResponse * urlResponse=nil;

    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship",userId]];
    
    
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    [request setHTTPMethod:@"POST"];
    NSString * body=[NSString stringWithFormat:@"access_token=%@&action=follow",accessToken];
    
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return nil;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return  response;
}


#pragma mark- sqlite methods

-(void)fetchNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken{
    
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
    

}


-(void)deleteNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken {
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
}

-(void)fireNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firedNotification" object:nil userInfo:nil];
}


+(id)loadCopyFollowersList:(NSString*)userId choice:(NSString*)choiceOpt{
    
      NSURLResponse * urlResponse;
     NSError * error;
     
     
     
     NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
     NSURL * getUrl=   [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/%@?access_token=%@",userId,choiceOpt,accessToken]];
     NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
     
     [request setHTTPMethod:@"GET"];
     [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     
     
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
     
     
     if (data==nil) {
         return nil;
     }
     NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dictResponse;

}

#pragma mark- get all media here

+(id)getAllRecentMediaFromTags:(NSString *)pagination name:(NSString *)titlename{
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSURL * getUrl;
    if (pagination) {
        getUrl = [NSURL URLWithString:pagination];
    }
    else{
        getUrl =[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@",titlename,access_token]];
        
    }
    NSMutableURLRequest * getRequest =[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data =[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    if (!data) {
        return nil;
    }
    
    id jsonResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return jsonResponse;
}


#pragma mark- get all Media from location

+(id)getAllRecentMediaFromLocation:(NSString*)pagination   mediaId:(NSString*)ids{
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSURL * getUrl;
    
    getUrl =[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%@/media/recent?access_token=%@",ids,access_token]];
    
    
    NSMutableURLRequest * getRequest =[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data =[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    if (!data) {
        return nil;
    }
    
    id jsonResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return  jsonResponse;
}


@end
