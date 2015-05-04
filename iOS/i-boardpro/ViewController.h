//
//  ViewController.h
//  Board
//
//  Created by Sumit Ghosh on 21/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
{
    sqlite3 * database;
    NSMutableArray * allData;
}

@end

