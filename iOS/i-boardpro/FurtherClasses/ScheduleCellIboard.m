

#import "ScheduleCellIboard.h"

@implementation ScheduleCellIboard

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
//        self.topLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-60,10 , self.frame.size.width-(self.frame.size.width/2-60), 25)];
        
        self.topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.topLabel.font=[UIFont boldSystemFontOfSize:12];
        self.topLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.topLabel];
        
//        self.photocaptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.topLabel.frame.origin.x, self.topLabel.frame.origin.y+self.topLabel.frame.size.height, self.topLabel.frame.size.width, 30)];
        
        self.photocaptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.photocaptionLabel.font=[UIFont boldSystemFontOfSize:12];
        self.photocaptionLabel.textColor=[UIColor blackColor];
        self.photocaptionLabel.numberOfLines=0;
        self.photocaptionLabel.textAlignment = NSTextAlignmentLeft;
        self.photocaptionLabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.photocaptionLabel];
        
//        self.cellImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.cellImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.cellImgView.backgroundColor=[UIColor redColor];
        self.cellImgView.layer.cornerRadius=5;
        self.cellImgView.clipsToBounds=YES;
        [self.contentView addSubview:self.cellImgView];
        
        
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
        CGRect messageRect = [ScheduleCellIboard messageSize:_photocaptionLabel.text];
        CGRect topLabelFrame = CGRectZero;
        CGRect photocaptionLabelFrame = CGRectZero;
        CGRect cellImgViewFrame = CGRectZero;
        topLabelFrame = CGRectMake(self.frame.size.width/2-60,10 , self.frame.size.width-(self.frame.size.width/2-60), 25);
        photocaptionLabelFrame = CGRectMake(self.frame.size.width/2-60, 40, self.frame.size.width-(self.frame.size.width/2-60), messageRect.size.height+10);
        cellImgViewFrame = CGRectMake(10, 10, 60, 60);
       _topLabel.frame  = topLabelFrame;
       _photocaptionLabel.frame = photocaptionLabelFrame;
       _cellImgView.frame = cellImgViewFrame;
    
          }

+(CGFloat)textMarginHorizontal {
    return 5;
}

+(CGFloat)textMarginVertical {
    return 5;
}


+(CGFloat)maxTextWidth {
    
  return 150.0f;
   
}

+(CGRect) messageSize:(NSString*)message {
    
 return [message boundingRectWithSize:CGSizeMake([ScheduleCellIboard maxTextWidth], CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}context:nil];
   }
@end
