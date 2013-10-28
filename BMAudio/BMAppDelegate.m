//
//  BMAppDelegate.m
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAppDelegate.h"
#import "BMAudio.h"
#import "BMAudioTrack.h"
#import "BMSamplerUnit.h"
#import "BMReverbUnit.h"
#import "BMDistortionUnit.h"
#import "BMMidiManager.h"
#import "BMMusicPlayer.h"

@implementation BMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    BMSamplerUnit *sampler1 = [BMSamplerUnit unit];
    BMReverbUnit *reverbUnit = [BMReverbUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[sampler1, reverbUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
    
    BMSamplerUnit *sampler2 = [BMSamplerUnit unit];
    BMDistortionUnit *distortionUnit = [BMDistortionUnit unit];
    BMAudioTrack *tromboneTrack2 = [BMAudioTrack trackWithUnits:@[sampler2, distortionUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack2];
    
    [[BMAudio sharedInstance] setUpAudioGraph];
    
    [sampler1 loadPreset:@"Trombone"];
    [sampler2 loadPreset:@"Trombone"];
    
    [[BMMidiManager sharedInstance] setUp];
    [[BMMidiManager sharedInstance] addListener:sampler2];
    
    BMMusicPlayer *musicPlayer = [[BMMusicPlayer alloc] init];
    [musicPlayer loadSequenceFromMidiFile:@"CarntSleepBassline"];
    musicPlayer.currentTempo = 70.0;
    [musicPlayer noteEventsOnOrAfterBeat:0 beforeBeat:32];
}

@end
