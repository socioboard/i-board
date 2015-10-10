

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
        self.topView = [[UIView alloc]init];
        self.topView.backgroundColor =  [UIColor colorWithRed: 213.0/255.0 green:63.0/255.0 blue:26.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.topView];
        
        self.add_plusButton=[[UIButton alloc]init];
        [self.topView addSubview:self.add_plusButton];
//
        
       
        
        
        self.feedImage=[[UIImageView alloc]init];
       // self.feedImage.frame=CGRectMake(50, 40, windowSize.width-100  , 180);
        self.feedImage.clipsToBounds=YES;
       
        [self.contentView addSubview:self.feedImage];
        
        self.userImage=[[UIImageView alloc]init];
        self.userImage.frame=CGRectMake(20, 10, 50, 50);
        self.userImage.layer.cornerRadius=self.userImage.frame.size.width/2;
        self.userImage.clipsToBounds=YES;
        [self.contentView addSubview:self.userImage];
        
        self.userNameDesc=[[UILabel alloc]init];
        self.userNameDesc.frame=CGRectMake(100, 20, 170, 40);
        self.userNameDesc.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.userNameDesc];
        
        self.feedsUsername=[[UILabel alloc]init];
        self.feedsUsername.frame=CGRectMake(80, 5, 170, 30);
        self.feedsUsername.font=[UIFont systemFontOfSize:12];
        self.feedsUsername.textColor = [UIColor whiteColor];
        [self.topView addSubview:self.feedsUsername];
        
        self.feedsUserImage=[[UIImageView alloc]init];
        self.feedsUserImage.frame=CGRectMake(10, 10, 30, 30);
        self.feedsUserImage.layer.cornerRadius=self.feedsUserImage.frame.size.width/2;
        self.feedsUserImage.clipsToBounds=YES;
        [self.topView addSubview:self.feedsUserImage];
        
        
        self.likesLbl=[[UILabel alloc]init];
        self.likesLbl.frame=CGRectMake(20, 220, 50, 20);
        self.likesLbl.font=[UIFont boldSystemFontOfSize:11];
       // [self.contentView addSubview:self.likesLbl];
        
        self.bottomView = [[UIView alloc]init];
        //CGRectMake(0, 0, self.contentView.frame.size.width, 50)];
        self.bottomView.backgroundColor =  [UIColor colorWithRed: 227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.bottomView];

        
        self.likesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       // self.likesBtn.frame=CGRectMake(30, 220, 15, 15);
        self.likesBtn.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        //[self.likesBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.bottomView addSubview:self.likesBtn];
        
        
        self.commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       // self.commentBtn.frame=CGRectMake(windowSize.width-75, 220, 15, 20);
        self.commentBtn.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"iboard-comment.png"] forState:UIControlStateNormal];
        [self.bottomView addSubview:self.commentBtn];
        
        
        self.likesCount=[[UILabel alloc]init];
       // self.likesCount.frame=CGRectMake(50, 220, 50, 20);
        self.likesCount.font=[UIFont boldSystemFontOfSize:11];
        [self.bottomView addSubview:self.likesCount];
        
        self.commentCnt=[UIButton buttonWithType:UIButtonTypeCustom];
//self.commentCnt.frame=CGRectMake(windowSize.width-55, 220, 60, 20);
        self.commentCnt.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        [self.commentCnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.commentCnt.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomView addSubview:self.commentCnt];
        
        if ([[UIScreen mainScreen] bounds].size.height == 736.0) {
           // self.feedImage.frame=CGRectMake(50, 40, windowSize.width-100  , 220);
            //self.likesLbl.frame=CGRectMake(20, 270, 50, 20);
           // self.likesBtn.frame=CGRectMake(30, 270, 15, 15);
           // self.commentBtn.frame=CGRectMake(windowSize.width-75, 270, 15, 20);
            //self.likesCount.frame=CGRectMake(50, 270, 50, 20);
            //self.commentCnt.frame=CGRectMake(windowSize.width-55, 270, 60, 20);
        }
        
        self.add_minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.add_minusButton.frame=CGRectMake(windowSize.width-60,20,40, 40);
       // [self.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.add_minusButton];
        
       
        
        self.cmtUserImage=[[UIImageView alloc]init];
        self.cmtUserImage.frame=CGRectMake(20, 20, 60, 60);
        self.cmtUserImage.layer.cornerRadius=self.userImage.frame.size.width/2;
        self.cmtUserImage.clipsToBounds=YES;
        [self.contentView addSubview:self.cmtUserImage];
        
        
        
        self.cmtUserName=[[UILabel alloc]init];
        self.cmtUserName.frame=CGRectMake(90, 80, 100, 25);
        self.cmtUserName.font=[UIFont systemFontOfSize:10];
        self.cmtUserName.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.userNameDesc];
        
        self.cmtTxtView = [[UITextView alloc] init];
        self.cmtTxtView.editable = NO;
        self.cmtTxtView.scrollsToTop = NO;
        self.cmtTxtView.userInteractionEnabled = NO;
        self.cmtTxtView.textAlignment = NSTextAlignmentLeft;
        self.cmtTxtView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cmtTxtView];
        
        
        self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
        //[self.contentView addSubview:self.bannerView];
        
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
            [self.settingButton setBackgroundImage:[UIImage imageNamed:@"iboard-setting.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:self.settingButton];

            
        }
          if ([reuseIdentifier isEqualToString:@"copy"]) {
              self.listCopy=[[UILabel alloc]init];
              self.listCopy.textColor=[UIColor blackColor];
              self.listCopy.frame=CGRectMake(40, 0, 100, 40);
              [self.contentView addSubview:self.listCopy];

          }
        
        if ([reuseIdentifier isEqualToString:@"overlappingUser"]) {
            self.cmtUserName=[[UILabel alloc]init];
            self.cmtUserName.frame=CGRectMake(90, 10, 100, 25);
            self.cmtUserName.font=[UIFont systemFontOfSize:10];
            self.cmtUserName.textColor=[UIColor blackColor];
            [self.contentView addSubview: self.cmtUserName];
            
            self.cmtUserImage=[[UIImageView alloc]init];
            self.cmtUserImage.frame=CGRectMake(20, 10, 40, 40);
            self.cmtUserImage.layer.cornerRadius=self.cmtUserImage.frame.size.width/2;
            self.cmtUserImage.clipsToBounds=YES;
            [self.contentView addSubview:self.cmtUserImage];
        }
        
        if ([reuseIdentifier isEqualToString:@"#Tags"]) {
            
            self.hashName =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width, 30)];
            self.hashName.font = [UIFont boldSystemFontOfSize:13];
            [self.contentView addSubview:self.hashName];
            
            self.mediaCount =[[UILabel alloc]initWithFrame:CGRectMake(20, 25, [UIScreen mainScreen].bounds.size.width, 30)];
            self.mediaCount.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:self.mediaCount];

        }
        if ([reuseIdentifier isEqualToString:@"notFeed"]) {
            
            self.userNameDesc=[[UILabel alloc]init];
            self.userNameDesc.frame=CGRectMake(100, 20, 170, 40);
            self.userNameDesc.font=[UIFont systemFontOfSize:12];
            [self.contentView addSubview:self.userNameDesc];
            
            self.userImage=[[UIImageView alloc]init];
            self.userImage.frame=CGRectMake(20, 10, 50, 50);
            self.userImage.layer.cornerRadius=self.userImage.frame.size.width/2;
            self.userImage.clipsToBounds=YES;
            [self.contentView addSubview:self.userImage];
            
            self.add_minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
            self.add_minusButton.frame=CGRectMake(windowSize.width-60,20,40, 40);
            // [self.add_minusButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:self.add_minusButton];
        }
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
