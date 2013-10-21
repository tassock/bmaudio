//
//  BMAudioUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudioUnit.h"

@implementation BMAudioUnit

+ (instancetype)unit
{
    return [[[self class] alloc] init];
}

-(AudioComponentDescription)componentDescription
{
    AudioComponentDescription cd = {0};
    return cd;
}

@end
