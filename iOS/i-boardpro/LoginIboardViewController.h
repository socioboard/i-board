//
//  LoginIboardViewController.h
//  i-boardpro
//
//  Created by GBS-ios on 9/30/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface LoginIboardViewController : UIViewController
{
    sqlite3 * database;
    NSMutableArray * allData;
}
@end
