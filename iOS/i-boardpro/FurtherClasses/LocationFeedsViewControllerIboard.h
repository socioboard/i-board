//
//  LocationFeedsViewControllerIboard.h
//  i-boardpro
//
//  Created by GBS-ios on 9/18/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface LocationFeedsViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,NSCoding>
{
    NSString * pagination;
}
//@property(nonatomic,strong)NSString * titleName,*tempFilePath;
@property(nonatomic)BOOL isAddMoreJokes;
@property(nonatomic,strong)NSArray * followedArry;
@property(nonatomic,strong)NSDictionary * resultDict;


-(id)initWithDictionary:(NSDictionary*)dict;
@end
