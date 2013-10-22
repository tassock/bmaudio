//
//  BMDistortionUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMDistortionUnit.h"

@implementation BMDistortionUnit

- (id)init
{
    if (self = [super init])
    {
        AudioComponentDescription cd = {0};
        cd.componentType = kAudioUnitType_Effect;
        cd.componentSubType = kAudioUnitSubType_Distortion;
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        componentDescription = cd;
    }
    return self;
}

@end
