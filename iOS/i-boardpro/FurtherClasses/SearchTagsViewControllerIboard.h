//
//  SearchTagsViewControllerIboard.h
//  i-boardpro
//
//  Created by GBS-ios on 9/9/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface SearchTagsViewControllerIboard : UIViewController<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)GADBannerView * bannerView;
@end
