//
//  BMReverbUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMReverbUnit.h"

@implementation BMReverbUnit

- (id)init
{
    if (self = [super init])
    {
        AudioComponentDescription cd = {0};
        cd.componentType = kAudioUnitType_Effect;
        #ifdef TARGET_OS_IOS
        cd.componentSubType = kAudioUnitSubType_Reverb2;
        #else
        cd.componentSubType = kAudioUnitSubType_MatrixReverb;
        #endif
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        componentDescription = cd;
    }
    return self;
}

/*
 params for kAudioUnitSubType_Reverb2
 // set the decay time at 0 Hz to 5 seconds
 AudioUnitSetParameter(reverbAU, kAudioUnitScope_Global, 0, kReverb2Param_DecayTimeAt0Hz, 5.f, 0);
 // set the decay time at Nyquist to 2.5 seconds
 AudioUnitSetParameter(reverbAU, kAudioUnitScope_Global, 0, kReverb2Param_DecayTimeAtNyquist, 5.f, 0);
 
 You can find the parameters for the reverb unit (and all Apple-supplied Audio Units) in AudioUnit/AudioUnitParameters.h
 
 // Parameters for the AUMatrixReverb unit
 enum {
 // Global, EqPow CrossFade, 0->100, 100
 kReverbParam_DryWetMix 							= 0,
 
 // Global, EqPow CrossFade, 0->100, 50
 kReverbParam_SmallLargeMix						= 1,
 
 // Global, Secs, 0.005->0.020, 0.06
 kReverbParam_SmallSize							= 2,
 
 // Global, Secs, 0.4->10.0, 3.07
 kReverbParam_LargeSize							= 3,
 
 // Global, Secs, 0.001->0.03, 0.025
 kReverbParam_PreDelay							= 4,
 
 // Global, Secs, 0.001->0.1, 0.035
 kReverbParam_LargeDelay							= 5,
 
 // Global, Genr, 0->1, 0.28
 kReverbParam_SmallDensity						= 6,
 
 // Global, Genr, 0->1, 0.82
 kReverbParam_LargeDensity						= 7,
 
 // Global, Genr, 0->1, 0.3
 kReverbParam_LargeDelayRange					= 8,
 
 // Global, Genr, 0.1->1, 0.96
 kReverbParam_SmallBrightness					= 9,
 
 // Global, Genr, 0.1->1, 0.49
 kReverbParam_LargeBrightness					= 10,
 
 // Global, Genr, 0->1 0.5
 kReverbParam_SmallDelayRange					= 11,
 
 // Global, Hz, 0.001->2.0, 1.0
 kReverbParam_ModulationRate						= 12,
 
 // Global, Genr, 0.0 -> 1.0, 0.2
 kReverbParam_ModulationDepth					= 13,
 };
 
 */


@end
