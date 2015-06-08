//
//  CopyFollowersViewController.h
//  i-boardpro
//
//  Created by Sumit Ghosh on 12/05/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDropdownView.h"

@interface CopyFollowersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView * copyFollowerTbl;
    CGSize windowSize;
    NSString * choice;
    BOOL follow;
}
@property (strong, nonatomic) LMDropdownView *dropdownView;
@end
