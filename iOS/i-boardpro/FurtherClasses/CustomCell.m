

#import "CustomCell.h"

@implementation CustomCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.profileImageView = [[UIImageView alloc] init];
        self.profileImageView.frame=CGRectMake(0, 0,SCREEN_WIDTH/4-4, SCREEN_WIDTH/4-4);
        [self addSubview:self.profileImageView];
        self.profileImageView.layer.cornerRadius = 4;
        self.profileImageView.clipsToBounds = YES;
        [self addSubview:self.profileImageView];
    }
    return self;
}
@end
