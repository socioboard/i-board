//
//  TableCustomCell.m
//  TwitterBoard
//
//  Created by GLB-254 on 4/18/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

#import "TableCustomCell.h"

@implementation TableCustomCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        windowSize=[UIScreen mainScreen].bounds.size;
       
    if([reuseIdentifier isEqualToString:@"Follow"])
    {
        self.userImage=[[UIImageView alloc]init];
        self.userImage.frame=CGRectMake(20, 20, 60, 60);
        self.userImage.layer.cornerRadius=self.userImage.frame.size.width/2;
        self.userImage.clipsToBounds=YES;
        [self.contentView addSubview:self.userImage];
        
        
        self.feedImage=[[UIImageView alloc]init];
        self.feedImage.frame=CGRectMake(100, 40, 160  , 160);
        self.feedImage.clipsToBounds=YES;
       
        [self.contentView addSubview:self.feedImage];
        
        self.userNameDesc=[[UILabel alloc]init];
        self.userNameDesc.frame=CGRectMake(100, 10, 170, 40);
        [self.contentView addSubview:self.userNameDesc];
        
        
        self.likesLbl=[[UILabel alloc]init];
        self.likesLbl.frame=CGRectMake(20, 220, 50, 20);
        self.likesLbl.font=[UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:self.likesLbl];
        
        self.commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.frame=CGRectMake(windowSize.width-120, 220, 60, 20);
        self.commentBtn.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        [self.commentBtn setTitle:@"Comments" forState:UIControlStateNormal];
        [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        [self.contentView addSubview:self.commentBtn];
        
        
        self.likesCount=[[UILabel alloc]init];
        self.likesCount.frame=CGRectMake(50, 220, 50, 20);
        self.likesCount.font=[UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:self.likesCount];
        
        self.commentCnt=[[UILabel alloc]init];
        self.commentCnt.frame=CGRectMake(windowSize.width-55, 220, 60, 20);
        self.commentCnt.font=[UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:self.commentCnt];
        
        
        self.add_minusButton=[[UIButton alloc]init];
        self.add_minusButton.frame=CGRectMake(windowSize.width-50,30,30, 30);
        [self.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.add_minusButton];
        
        
        self.cmtUserImage=[[UIImageView alloc]init];
        self.cmtUserImage.frame=CGRectMake(20, 20, 60, 60);
        self.cmtUserImage.layer.cornerRadius=self.userImage.frame.size.width/2;
        self.cmtUserImage.clipsToBounds=YES;
        self.userImage.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.cmtUserImage];
        
        
        
        self.cmtUserName=[[UILabel alloc]init];
        self.cmtUserName.frame=CGRectMake(90, 80, 100, 25);
        self.cmtUserName.font=[UIFont systemFontOfSize:10];
        self.cmtUserName.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.userNameDesc];
        
        self.jokeTxtView = [[UITextView alloc] init];
        self.jokeTxtView.editable = NO;
        self.jokeTxtView.scrollsToTop = NO;
        self.jokeTxtView.userInteractionEnabled = NO;
        self.jokeTxtView.textAlignment = NSTextAlignmentLeft;
        self.jokeTxtView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.jokeTxtView];
    }
       
        if ([reuseIdentifier isEqualToString:@"menuTable"]) {
            
            self.profileImg=[[UIImageView alloc]init];
            self.profileImg.frame=CGRectMake(5, 5, 30, 30);
            self.profileImg.layer.cornerRadius=self.profileImg.frame.size.width/2;
            self.profileImg.clipsToBounds=YES;
            [self.contentView addSubview:self.profileImg];
            
            self.menuImages=[[UIImageView alloc]init];
            self.menuImages.frame=CGRectMake(5, 10, 20, 20);
            self.menuImages.clipsToBounds=YES;
            [self.contentView addSubview:self.menuImages];

            
            self.cellTitle=[[UILabel alloc]init];
            self.cellTitle.textColor=[UIColor blackColor];
            self.cellTitle.frame=CGRectMake(40, 0, 100, 40);
            [self.contentView addSubview:self.cellTitle];
            
            self.cellMenuTitle=[[UILabel alloc]init];
            self.cellMenuTitle.textColor=[UIColor blackColor];
            self.cellMenuTitle.frame=CGRectMake(40, 0, 100, 40);
            [self.contentView addSubview:self.cellMenuTitle];
            
            self.settingButton=[[UIButton alloc]init];
            self.settingButton.frame=CGRectMake(140,5,20, 20);
            [self.settingButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:self.settingButton];

            
        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
