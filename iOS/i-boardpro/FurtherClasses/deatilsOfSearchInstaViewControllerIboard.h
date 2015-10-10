//
//  deatilsOfSearchInstaViewControllerIboard.h
//  i-boardpro
//
//  Created by GBS-ios on 9/9/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface deatilsOfSearchInstaViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,NSCoding>
{
    NSString * pagination;
}
@property(nonatomic,strong)NSString * titleName,*tempFilePath;
@property(nonatomic)BOOL isAddMoreJokes;
@property(nonatomic,strong)NSArray * followedArry;
@end
