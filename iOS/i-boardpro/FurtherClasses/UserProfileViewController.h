//
//  UserProfileViewController.h
//  Board
//
//  Created by Sumit Ghosh on 24/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UIImageView * profileImage,* loggedInImge;
    CGSize windowSize;
    NSString * profilePicStr,* userFullName,* userNameStr;
     NSString * bio;
    UILabel * username,* full_name,* mediaCountLbl,* followsCountLbl,*followingCountLbl   ;
    NSString * mediaCountStr,* followsCountStr,*followingCountStr;
    
    NSMutableArray * imageUrl;
   
}
@property(nonatomic,strong)NSString * accessToken,*userId;
@property(nonatomic,strong)UICollectionView * mainCollectionView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
