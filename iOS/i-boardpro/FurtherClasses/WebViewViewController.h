//
//  WebViewViewController.h
//  Board
//
//  Created by Sumit Ghosh on 21/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface WebViewViewController : UIViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{
    NSMutableArray * urlParts;
    CGSize  windowSize;
    NSString * userID;
    sqlite3 * _database;
    
}
@property(nonatomic, strong)UIWebView * webView;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
-(void)loadAllFollowedBy;
-(void)createUI;

@end
