//
//  FeedViewController.h
//  TwitterBoard
//
//  Created by Sumit Ghosh on 19/04/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView * feedTableView;
    UIActivityIndicatorView * activityView;
    CGSize windowSize;
    NSMutableArray * userId;
    NSString * pagination,*nextMaxId;
}
@property(nonatomic)BOOL isAddMoreJokes;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
