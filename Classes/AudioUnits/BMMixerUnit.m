//
//  BMMixerUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMMixerUnit.h"
#import "BMAudioHelpers.h"

@implementation BMMixerUnit

- (id)init
{
    if (self = [super init])
    {
        AudioComponentDescription cd = {0};
        cd.componentType = kAudioUnitType_Mixer;
        cd.componentSubType = kAudioUnitSubType_MultiChannelMixer;
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        componentDescription = cd;
    }
    return self;
}

- (void)setDefaults
{
    for(int i = 0; i < _numChannels; i ++)
    {
        // Enable input
        CheckError(AudioUnitSetParameter (audioUnit,
                                          kMultiChannelMixerParam_Enable,
                                          kAudioUnitScope_Input,
                                          i,
                                          YES,
                                          0
                                          ),
                   "AudioUnitSetParameter (enable the mixer unit)");
        
        // Set input gain to 1.0
        CheckError(AudioUnitSetParameter (audioUnit,
                                          kMultiChannelMixerParam_Volume,
                                          kAudioUnitScope_Input,
                                          i,
                                          1.0,
                                          0
                                          ),
                   "AudioUnitSetParameter (set mixer unit input volume)");
    }
    
    // Set output gain to 1.0
    CheckError(AudioUnitSetParameter (audioUnit,
                                       kMultiChannelMixerParam_Volume,
                                       kAudioUnitScope_Output,
                                       0,
                                       1.0,
                                       0
                                       ),
                "AudioUnitSetParameter (set mixer unit output volume)");
    
}

@end
