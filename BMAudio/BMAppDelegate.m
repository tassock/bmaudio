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
    BMSamplerUnit *tromboneSampler = [BMSamplerUnit unit];
    BMReverbUnit *reverbUnit = [BMReverbUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[tromboneSampler, reverbUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
    
    BMSamplerUnit *tromboneSampler2 = [BMSamplerUnit unit];
    BMDistortionUnit *distortionUnit = [BMDistortionUnit unit];
    BMAudioTrack *tromboneTrack2 = [BMAudioTrack trackWithUnits:@[tromboneSampler2, distortionUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack2];
    
    [[BMAudio sharedInstance] setUpAudioGraph];
    
    [tromboneSampler loadPreset:@"Trombone"];
    [tromboneSampler2 loadPreset:@"Trombone"];
    
    [[BMMidiManager sharedInstance] setUp];
    [BMMidiManager sharedInstance].instrumentDelegate = tromboneSampler2;
    
    BMMusicPlayer *musicPlayer = [[BMMusicPlayer alloc] init];
    [musicPlayer setUpFromGraph:[BMAudio sharedInstance]->graph];
}

@end
