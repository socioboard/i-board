//
//  NonFollowerViewController.h
//  Board
//
//  Created by Sumit Ghosh on 23/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NonFollowerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *  full_name,*  profilePic;
    UITableView * nonFollowTbl;
     CGSize windowSize;
    NSMutableArray * usreId;
}
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
