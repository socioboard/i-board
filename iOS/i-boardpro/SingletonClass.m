//
//  SingletonClass.m
//  TwitterBoard
//
//  Created by Sumit Ghosh on 18/04/15.
//  Copyright (c) 2015 globussoft. All rights reserved.
//

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
