

#import "CollectionReusableHeaderView.h"

@implementation CollectionReusableHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0,frame.size.width, 25);
        UIColor *firstColor = [UIColor colorWithRed:(CGFloat)80/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:1.0];
        UIColor *secColor = [UIColor colorWithRed:(CGFloat)150/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:1.0];
        layer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor],(id)[secColor CGColor], nil];
      

        
        
        self.headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-25, frame.size.width, 25)];
        self.headerTitleLabel.textColor = [UIColor blackColor];
        self.headerTitleLabel.font = [UIFont systemFontOfSize:14];
        //[self.headerTitleLabel.layer insertSublayer:layer atIndex:0];
        [self addSubview:self.headerTitleLabel];
    }
    return self;
}

@end
