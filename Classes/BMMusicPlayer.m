//
//  BMMusicPlayer.m
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMMusicPlayer.h"

@interface BMMusicPlayer ()
{
    MusicPlayer musicPlayer;
    MusicSequence musicSequence;
    MusicTimeStamp trackDuration;
    AUGraph graph;
}
@end

@implementation BMMusicPlayer

#pragma mark - lifecyle

- (id)initWithGraph:(AUGraph)argGraph
{
    if (self = [super init])
    {
        graph = argGraph;
        NewMusicPlayer(&musicPlayer);
    }
    return self;
}

- (void)dealloc
{
    DisposeMusicPlayer(musicPlayer);
}

#pragma mark - utility

- (void)loadSequence
{
    if (!_midiFileName) return; // better way to handle this?
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:_midiFileName withExtension:@"mid"];
    
    NewMusicSequence(&musicSequence);
    MusicSequenceFileLoad(musicSequence, (__bridge CFURLRef)url, 0,0);
    
    MusicTrack t;
    UInt32 sz = sizeof(MusicTimeStamp);
    MusicSequenceGetIndTrack(musicSequence, 0, &t);
    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &trackDuration, &sz);
    
    // this is it, arthur pewty! feed the track to the ausampler and let 'er rip
    MusicSequenceSetAUGraph(musicSequence, graph);
    
    MusicPlayerSetSequence(musicPlayer, musicSequence);
    MusicPlayerPreroll(musicPlayer);
}

#pragma mark - public API

- (void)play
{
    if (!self.isPlaying)
    {
        if (!musicSequence)
        {
            [self loadSequence];
        }
        
        MusicPlayerStart(musicPlayer);

// USE TO CHECK ENDING?
//        // on background thread
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//            //Background Thread
//            MusicPlayerStart(musicPlayer);
//            while (1) {
//                usleep (3 * 1000 * 1000);
//                MusicTimeStamp now = 0;
//                MusicPlayerGetTime (musicPlayer, &now);
//                if (now >= trackDuration)
//                    break;
//                NSLog(@"%f", now);
//            }
//            NSLog(@"finishing");
//            DisposeMusicSequence(musicSequence);
//            isPlaying = NO;
//        });
    }
}

- (void)pause
{
    MusicPlayerStop(musicPlayer);
}

- (void)reset
{
    [self pause];
    DisposeMusicSequence(musicSequence);
    [self setTimeStamp:0];
}

- (BOOL)isPlaying
{
    Boolean isPlaying;
    MusicPlayerIsPlaying(musicPlayer, &isPlaying);
    return isPlaying;
}

- (MusicTimeStamp)timeStamp
{
    MusicTimeStamp now = 0;
    MusicPlayerGetTime (musicPlayer, &now);
    return now;
}

- (void)setTimeStamp:(MusicTimeStamp)timeStamp
{
    MusicPlayerSetTime(musicPlayer, timeStamp);
}

- (CABarBeatTime)beatPosition
{
    MusicTimeStamp beats;
    MusicSequenceGetBeatsForSeconds(musicSequence, [self timeStamp], &beats);
    CABarBeatTime outBarBeatTime;
    MusicSequenceBeatsToBarBeatTime(musicSequence, beats, 4, &outBarBeatTime);
    return outBarBeatTime;
}

- (Float64)playbackRate
{
    Float64 rate;
    MusicPlayerGetPlayRateScalar(musicPlayer, &rate);
    return rate;
}

- (void)setPlaybackRate:(Float64)rate
{
    MusicPlayerSetPlayRateScalar(musicPlayer, rate);
}

//- (Float64)sequenceTempo
//{
//    MusicTrack *outTrack;
//    MusicSequenceGetTempoTrack(musicSequence, outTrack);
//}

@end
