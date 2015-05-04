//
//  PhotosViewController.h
//  Board
//
//  Created by Sumit Ghosh on 23/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate>
{
    CGSize windowSize;
     NSString * bio;
}
@property(nonatomic,strong)UICollectionView * mainCollectionView;
@property(nonatomic,strong)NSMutableArray * imageUrl;
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
