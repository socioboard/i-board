

#import "SingletonClassIboard.h"

static SingletonClassIboard * shareSinglton;

@implementation SingletonClassIboard

+(SingletonClassIboard*)shareSinglton
{
    if (!shareSinglton) {
        shareSinglton=[[SingletonClassIboard alloc]init];
    }
    return shareSinglton;
}

@end
