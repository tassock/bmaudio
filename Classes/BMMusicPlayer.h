//
//  BMMusicPlayer.h
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMMusicPlayer : NSObject

/**
 *  Singleton accessor
 *
 *  @return Shared instance of BMMusicPlayer
 */
+ (instancetype)sharedInstance;

/**
 *  Create and load a new MusicSequence from a given midi file
 *
 *  @param midiFileName midi file to load music sequence from.
 */
- (void)loadSequenceFromMidiFile:(NSString*)midiFileName;

/**
 *  Play the MusicSequence
 */
- (void)play;

/**
 *  Pause the MusicSequence. Playing after pausing will resume where you left off.
 */
- (void)pause;

/**
 *  Reset the MusicSequence. Playing after resetting will play from the start of the sequence
 */
- (void)reset;

/**
 *  Indicates whether the player is currently playing
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
 *  Tempo of the MusicSequence's music track
 */
@property (nonatomic, assign, readonly) Float64 trackTempo;

/**
 *  The rate at which the MusicSequence is being played relative to the original track tempo. 1 = normal. 2 = double speed.
 */
@property (nonatomic, assign, readwrite) Float64 playbackRate;

/**
 *  Effective tempo being played back at (trackTempo * playbackRate)
 */
@property (nonatomic, assign, readwrite) Float64 currentTempo;

/**
 *  String represent the current beat in <bar>.<beat>.<subbeat> format
 */
@property (nonatomic, strong, readonly) NSString *currentBeatString;

/**
 *  Current position of playback in terms of time
 */
@property (nonatomic, assign, readwrite) MusicTimeStamp currentTime;

/**
 *  Current position of playback in terms of beats
 */
@property (nonatomic, assign, readwrite) CABarBeatTime currentBeat;

/**
 *  Query MusicSequence for MIDI note events within a given range of beats across all MusicTracks
 *
 *  @param afterBeat  lower limit of note range, in beats
 *  @param beforeBeat uppser limit of note range, in beats
 *
 *  @return Array of BMNoteEvents within the given range
 */
- (NSArray*)noteEventsOnOrAfterBeat:(MusicTimeStamp)afterBeat beforeBeat:(MusicTimeStamp)beforeBeat;

@end
