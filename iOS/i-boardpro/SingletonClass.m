

#import "SingletonClass.h"

static SingletonClass * shareSinglton;

@implementation SingletonClass

+(SingletonClass*)shareSinglton
{
    if (!shareSinglton) {
        shareSinglton=[[SingletonClass alloc]init];
    }
    return shareSinglton;
}

@end
