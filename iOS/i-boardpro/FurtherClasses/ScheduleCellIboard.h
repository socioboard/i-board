
#import <UIKit/UIKit.h>

@interface ScheduleCellIboard : UITableViewCell

@property(nonatomic,strong)UILabel * topLabel,* photocaptionLabel;
@property(nonatomic,strong)UIImageView * cellImgView;
+ (CGRect)messageSize:(NSString*)message;

@end
