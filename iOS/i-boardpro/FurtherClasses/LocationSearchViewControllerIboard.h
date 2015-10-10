//
//  LocationSearchViewControllerIboard.h
//  i-boardpro
//
//  Created by GBS-ios on 9/18/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface LocationSearchViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,UITextFieldDelegate>
{
    BOOL isClickedLocation;
}
@property(nonatomic,strong)GADBannerView * bannerView;


@end
