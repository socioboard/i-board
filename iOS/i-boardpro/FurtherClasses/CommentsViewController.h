//
//  CommentsViewController.h
//  Board
//
//  Created by Sumit Ghosh on 30/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView *commentsTbl;
    CGSize windowSize;
     NSMutableArray * cmtTextArr,* cmtUserImgArr,* cmtUserName,*cmtMediaId;
}
@property(nonatomic,strong)NSString * capId;
@property(nonatomic,strong)UIView * headerView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
