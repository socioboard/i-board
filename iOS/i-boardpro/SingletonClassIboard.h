

#import <Foundation/Foundation.h>

@interface SingletonClassIboard : NSObject

+(SingletonClassIboard*)shareSinglton;

@property(nonatomic,strong)NSMutableArray * full_name,* profile_picture,* userId;
@property(nonatomic,strong)NSString * followed_by,* follows,* media,* user_full_name,* user_pic,* user_name,* medaiCnt;

// feeds Data

@property(nonatomic,strong)NSMutableArray * commentsCount,* likesCount,* feedPic,* feedUserPic,* feedUserName;
@property(nonatomic,strong)NSString* userID;

//retreive data from sqlite
@property(nonatomic,strong)NSMutableArray * allData;

//Bool var checking addAccount

@property(nonatomic)BOOL fromAddAccount;


// mutable array for non follwers
@property(nonatomic,strong)NSMutableArray * follower,* followeBy;


// profile view bool for dismiss customView

@property(nonatomic)BOOL customDismiss;

//
@property(nonatomic,strong)NSString * imagePath,* imageId;
@property(nonatomic,strong)NSData * data;
@property(nonatomic,strong)NSMutableArray * postData;
@property(nonatomic,strong)NSString * captionStr;

//

@property(nonatomic,strong)NSMutableArray * notfyArr;

@property(nonatomic)BOOL isActivenetworkConnection;

//
@property(nonatomic,strong) NSMutableDictionary * storedData;
@end
