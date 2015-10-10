//
//  HelperClassIboard.h
//  i-boardpro
//
//  Created by GBS-ios on 9/9/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface HelperClassIboard : NSObject
{
    sqlite3 * database;
}

+(id)loadFeeds:(NSString*)pagination;

#pragma  mark-  load Followers
+(id)loadAllFollowers:(NSString *)pagination;
+(id)loadAllFollowedBy:(NSString *)pagination;
+(id)unfollowAction:(NSString *) userId;
+(id)followActions:(NSString *)userId;

-(void)fetchNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken;
-(void)deleteNotificationData :(NSString *)time andAccesToken:(NSString *) accessToken ;

+(id)loadCopyFollowersList:(NSString*)userId choice:(NSString*)choiceOpt;
+(id)getAllRecentMediaFromTags:(NSString *)pagination name:(NSString *)titlename;

+(id)getAllRecentMediaFromLocation:(NSString*)pagination   mediaId:(NSString*)ids;
@end
