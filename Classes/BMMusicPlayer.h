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
 *  Name of the midi file to load into the sequence
 */
@property (nonatomic, strong, readwrite) NSString *midiFileName;

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
 *  Current position of playback in terms of time
 */
@property (nonatomic, assign, readwrite) MusicTimeStamp currentTime;

/**
 *  Current position of playback in terms of beats
 */
@property (nonatomic, assign, readwrite) CABarBeatTime currentBeat;

- (void)loadSequence;
- (void)play;
- (void)pause;
- (void)reset;

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
