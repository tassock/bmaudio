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
    AUGraph graph;
    BMSamplerUnit *samplerUnit;
    BMIOUnit *ioUnit;
    BMMixerUnit *mixerUnit;
}
@property (nonatomic, readwrite, strong) NSMutableArray *audioTracks;
@end

@implementation BMAudio

- (id)init
{
    if (self = [super init])
    {
        self.audioTracks = [NSMutableArray array];
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
    for (BMAudioTrack *audioTrack in self.audioTracks)
    {
        for (BMAudioUnit *audioUnit in audioTrack.audioUnits)
        {
            AUGraphConnectNodeInput(graph, audioUnit->audioNode, 0, mixerUnit->audioNode, 0);
        }
    }
    
    // configure mixer and connect unit to IO Unit
    AUGraphConnectNodeInput(graph, mixerUnit->audioNode, 0, ioUnit->audioNode, 0);
    
    
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
    [_audioTracks addObject:audioTrack];
}

@end
