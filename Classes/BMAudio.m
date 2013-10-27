//
//  BMAudio.m
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudio.h"
#import "BMSamplerUnit.h"
#import "BMIOUnit.h"
#import "BMMixerUnit.h"
#import "BMAudioHelpers.h"
#import "BMAudioTrack.h"

#import <AudioToolbox/AudioToolbox.h>

#ifdef TARGET_OS_IOS
#import <AVFoundation/AVFoundation.h>
#endif

@interface BMAudio ()
{
    BMSamplerUnit *samplerUnit;
    BMIOUnit *ioUnit;
    BMMixerUnit *mixerUnit;
}
@end

@implementation BMAudio

// TODO: start / stop graph

- (id)init
{
    if (self = [super init])
    {
        self.audioTracks = [NSArray array];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static BMAudio *sharedInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#ifdef TARGET_OS_IOS
- (void)setUpIOSAudioSession
{
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    
    [mySession setCategory: AVAudioSessionCategoryPlayback error:nil];
    
    Float64 graphSampleRate = 44100.0;
    
    [mySession setPreferredSampleRate: graphSampleRate error: nil]; // changed, iOS 6 deprecation
    [mySession setActive: YES error:nil];
}
#endif

- (void)setUpAudioGraph
{
	NewAUGraph(&graph);
    
    // Initialize and add our own audio units
    ioUnit = [BMIOUnit unit];
    [self addNodeForAudioUnit:ioUnit];
    mixerUnit = [BMMixerUnit unit];
    [self addNodeForAudioUnit:mixerUnit];
    
    // Add track units to graph
    for (BMAudioTrack *audioTrack in self.audioTracks)
    {
        for (BMAudioUnit *audioUnit in audioTrack.audioUnits)
        {
            [self addNodeForAudioUnit:audioUnit];
        }
    }
    
    // Initialize graph
    AUGraphOpen(graph);
    
    // Connect units TODO connect last unit
    int t = 0;
    for (BMAudioTrack *audioTrack in self.audioTracks)
    {
        BMAudioUnit *previousUnit;
        NSUInteger unitCount = audioTrack.audioUnits.count;
        int u = 0;
        for (BMAudioUnit *audioUnit in audioTrack.audioUnits)
        {
            u ++;
            BOOL isLastUnit = (u == unitCount);
            if (isLastUnit)
            {
                // connect to mixer
                CheckError(AUGraphConnectNodeInput(graph, audioUnit->audioNode, 0, mixerUnit->audioNode, t),
                           "Could not connect to mixerUnit");
            }
            if (previousUnit)
            {
                // connect to previous unit
                CheckError(AUGraphConnectNodeInput(graph, previousUnit->audioNode, 0, audioUnit->audioNode, 0),
                           "Could not connect ? to ?");
            }
            previousUnit = audioUnit;
        }
        t ++;
    }
    
    // configure mixer and connect unit to IO Unit
    CheckError(AUGraphConnectNodeInput(graph, mixerUnit->audioNode, 0, ioUnit->audioNode, 0),
               "Could not connect mixerUnit to ioUnit");
    
    
    // Obtain unit instances from their corresponding nodes.
    [self connectGraphNodeToAudioUnit:ioUnit];
    [self connectGraphNodeToAudioUnit:mixerUnit];
    for (BMAudioTrack *audioTrack in self.audioTracks)
    {
        for (BMAudioUnit *audioUnit in audioTrack.audioUnits)
        {
            [self connectGraphNodeToAudioUnit:audioUnit];
        }
    }
    
    mixerUnit.numChannels = _audioTracks.count;
    [mixerUnit setDefaults];
    
    // Start up the graph!
    CheckError(AUGraphInitialize(graph), "Couldn't initialize graph");
    CheckError(AUGraphStart(graph), "Couldn't start graph");
}

- (void)addNodeForAudioUnit:(BMAudioUnit*)audioUnit
{
    AudioComponentDescription cd = audioUnit->componentDescription;
    CheckError(AUGraphAddNode(graph, &cd, &audioUnit->audioNode), "Couldn't add node to graph");
}

- (void)connectGraphNodeToAudioUnit:(BMAudioUnit*)audioUnit
{
    CheckError(AUGraphNodeInfo(graph, audioUnit->audioNode, 0, &audioUnit->audioUnit), "Couldn't get node info");
}

- (void)loadAudioTrack:(BMAudioTrack*)audioTrack
{
    NSMutableArray *mutableAudioTracks = [NSMutableArray arrayWithArray:_audioTracks];
    [mutableAudioTracks addObject:audioTrack];
    _audioTracks = [NSArray arrayWithArray:mutableAudioTracks];
}

@end
