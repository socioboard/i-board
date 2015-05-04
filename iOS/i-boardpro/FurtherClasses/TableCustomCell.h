//
//  TableCustomCell.h
//  TwitterBoard
//
//  Created by GLB-254 on 4/18/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCustomCell : UITableViewCell
{
    CGSize windowSize;
}
@property(nonatomic,strong)UIImageView * userImage,* feedImage,* profileImg,* menuImages,* cmtUserImage;
@property(nonatomic,strong)UIButton * add_minusButton,* settingButton,* commentBtn;
@property(nonatomic,strong)UILabel * userNameDesc,*likesLbl,* likesCount,* commentCnt,* cellTitle;



@property(nonatomic,strong) UILabel * cellMenuTitle,* cmtUserName;
@property(nonatomic,strong)UITextView * jokeTxtView;
@end
