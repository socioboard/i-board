//
//  CustomCell.m
//  Board
//
//  Created by Sumit Ghosh on 23/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.profileImageView = [[UIImageView alloc] init];
        self.profileImageView.frame=CGRectMake(0, 0, 73, 73);
        [self addSubview:self.profileImageView];
        self.profileImageView.layer.cornerRadius = 4;
        self.profileImageView.clipsToBounds = YES;
        [self addSubview:self.profileImageView];
    }
    return self;
}
@end
