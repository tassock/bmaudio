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
#import "BMMidiManager.h"

@implementation BMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    BMSamplerUnit *tromboneSampler = [BMSamplerUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[tromboneSampler]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
    
    [[BMAudio sharedInstance] setUpAudioGraph];
    
    [tromboneSampler loadPreset:@"Trombone"];
    
    [[BMMidiManager sharedInstance] setUp];
    [BMMidiManager sharedInstance].instrumentDelegate = tromboneSampler;
}

@end
