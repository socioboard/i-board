

#import "ScheduleCell.h"

@implementation ScheduleCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.topLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-60,10 , self.frame.size.width, 25)];
        self.topLabel.font=[UIFont boldSystemFontOfSize:12];
        self.topLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.topLabel];
        
        
        self.cellImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
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

@end
