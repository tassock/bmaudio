//
//  BMMusicPlayer.m
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMMusicPlayer.h"
#import "BMAudio.h"
#import "BMAudioTrack.h"
#import "BMNoteEvent.h"

@interface BMMusicPlayer ()
{
    MusicPlayer musicPlayer;
    MusicSequence musicSequence;
    MusicTimeStamp trackDuration;
}
@property (nonatomic, assign, readwrite) Float64 trackTempo;
@end

@implementation BMMusicPlayer

#pragma mark - lifecyle

+ (instancetype)sharedInstance
{
    static BMMusicPlayer *sharedInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        NewMusicPlayer(&musicPlayer);
    }
    return self;
}

- (void)dealloc
{
    DisposeMusicSequence(musicSequence);
    DisposeMusicPlayer(musicPlayer);
}

#pragma mark - utility

- (void)fetchExtendedTempo
{
    MusicTrack tempoTrack;
    MusicSequenceGetTempoTrack(musicSequence, &tempoTrack);
    MusicEventIterator eventIterator;
    NewMusicEventIterator(tempoTrack, &eventIterator);
    
    Boolean hasNextEvent = YES;
    while (hasNextEvent) {
        MusicTimeStamp timeStamp;
        MusicEventType eventType;
        const void *eventData;
        UInt32 eventDataSize;
        MusicEventIteratorGetEventInfo(eventIterator,
                                       &timeStamp,
                                       &eventType,
                                       &eventData,
                                       &eventDataSize);
        
        if (eventType == kMusicEventType_ExtendedTempo)
        {
            ExtendedTempoEvent *extendedTempo = (ExtendedTempoEvent*)eventData;
            self.trackTempo = extendedTempo->bpm;
            break;
        }
        
        // increment event
        MusicEventIteratorHasNextEvent(eventIterator, &hasNextEvent);
        if (hasNextEvent) MusicEventIteratorNextEvent(eventIterator);
    }
    
    // If we didn't find a tempo event, use the default tempo
    if (_trackTempo == 0) self.trackTempo = 120.0;
}

- (void)loadSequenceFromMidiFile:(NSString*)midiFileName
{
    if (!midiFileName) return;
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:midiFileName withExtension:@"mid"];
    
    NewMusicSequence(&musicSequence);
    MusicSequenceFileLoad(musicSequence, (__bridge CFURLRef)url, 0,0);
    
    MusicTrack t;
    UInt32 sz = sizeof(MusicTimeStamp);
    MusicSequenceGetIndTrack(musicSequence, 0, &t);
    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &trackDuration, &sz);
    
    // this is it, arthur pewty! feed the track to the ausampler and let 'er rip
    MusicSequenceSetAUGraph(musicSequence, [BMAudio sharedInstance]->graph);
    
    MusicPlayerSetSequence(musicPlayer, musicSequence);
    MusicPlayerPreroll(musicPlayer);
    
    [self fetchExtendedTempo];
}

#pragma mark - public API

- (void)play
{
    if (!self.isPlaying)
    {
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
    [self setCurrentTime:0];
}

- (BOOL)isPlaying
{
    Boolean isPlaying;
    MusicPlayerIsPlaying(musicPlayer, &isPlaying);
    return isPlaying;
}

#pragma mark - property setters / getters

- (MusicTimeStamp)currentTime
{
    MusicTimeStamp now = 0;
    MusicPlayerGetTime (musicPlayer, &now);
    return now;
}

- (void)setCurrentTime:(MusicTimeStamp)timeStamp
{
    MusicPlayerSetTime(musicPlayer, timeStamp);
}

- (CABarBeatTime)currentBeat
{
    MusicTimeStamp beats;
    MusicSequenceGetBeatsForSeconds(musicSequence, [self currentTime], &beats);
    CABarBeatTime outBarBeatTime;
    MusicSequenceBeatsToBarBeatTime(musicSequence, beats, 4, &outBarBeatTime);
    return outBarBeatTime;
}

- (void)setCurrentBeat:(CABarBeatTime)currentBeat
{
    MusicTimeStamp beats;
    MusicSequenceBarBeatTimeToBeats(musicSequence, &currentBeat, &beats);
    MusicTimeStamp seconds;
    MusicSequenceGetSecondsForBeats(musicSequence, beats, &seconds);
    self.currentTime = seconds;
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

- (Float64)currentTempo
{
    return _trackTempo * [self playbackRate];
}

- (void)setCurrentTempo:(Float64)desiredTempo
{
    self.playbackRate = desiredTempo / _trackTempo;
}

#pragma mark - sequence stuff

- (UInt32)trackCount
{
    UInt32 outNumberOfTracks;
    MusicSequenceGetTrackCount(musicSequence, &outNumberOfTracks);
    return outNumberOfTracks;
}

- (NSArray*)noteEventsOnOrAfterBeat:(MusicTimeStamp)afterBeat beforeBeat:(MusicTimeStamp)beforeBeat
{
    NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:5];
    for (UInt32 t = 0; t < [self trackCount]; t++) {
        NSArray *audioTracks = [BMAudio sharedInstance].audioTracks;
        if (t < audioTracks.count)
        {
            BMAudioTrack *audioTrack = [audioTracks objectAtIndex:t];
            MusicSequenceGetIndTrack(musicSequence, t, &audioTrack->musicTrack);
            NewMusicEventIterator(audioTrack->musicTrack, &audioTrack->eventIterator);
            
            MusicEventIteratorSeek(audioTrack->eventIterator, afterBeat);
            
            Boolean hasNextEvent = YES;
            while (hasNextEvent) {
                MusicTimeStamp timeStamp;
                MusicEventType eventType;
                const void *eventData;
                UInt32 eventDataSize;
                MusicEventIteratorGetEventInfo(audioTrack->eventIterator,
                                               &timeStamp,
                                               &eventType,
                                               &eventData,
                                               &eventDataSize);
                if (timeStamp >= beforeBeat) break;
                
                if (eventType == kMusicEventType_MIDINoteMessage)
                {
                    MIDINoteMessage *message = (MIDINoteMessage*)eventData;
                    BMNoteEvent *noteEvent = [[BMNoteEvent alloc] init];
                    noteEvent.beat = timeStamp;
                    noteEvent.note = message->note;
                    noteEvent.velocity = message->velocity;
                    noteEvent.duration = message->duration;
                    [notes addObject:noteEvent];
                }
                
                // increment event
                MusicEventIteratorHasNextEvent(audioTrack->eventIterator, &hasNextEvent);
                if (hasNextEvent) MusicEventIteratorNextEvent(audioTrack->eventIterator);
            }
        }
    }
    NSLog(@"Notes: %@", notes);
    return [NSArray arrayWithArray:notes];
}


@end
