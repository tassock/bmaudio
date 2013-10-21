//
//  BMIOUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMIOUnit.h"

@implementation BMIOUnit

- (id)init
{
    if (self = [super init])
    {
        AudioComponentDescription cd = {0};
        cd.componentType = kAudioUnitType_Output;
#ifdef TARGET_OS_IOS
        cd.componentSubType = kAudioUnitSubType_RemoteIO;
#else
        cd.componentSubType = kAudioUnitSubType_DefaultOutput;
#endif
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        componentDescription = cd;
    }
    return self;
}

@end
