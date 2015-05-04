//
//  ProfileViewController.h
//  TwitterBoard
//
//  Created by GLB-254 on 4/18/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UIDocumentInteractionControllerDelegate>
{
    CGSize windowSize;
    UILabel * username,* full_name;
    UIImageView * profile_pic;
     NSString * mediaCountStr,* followsCountStr,*followingCountStr;
     UILabel * mediaCountLbl,* followsCountLbl,*followingCountLbl   ;
}

@property(nonatomic,strong)NSString * accessToken;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
