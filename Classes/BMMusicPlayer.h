//
//  BMMusicPlayer.h
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMAudio;

@interface BMMusicPlayer : NSObject
@property (nonatomic, strong, readwrite) NSString *midiFileName;
@property (nonatomic, assign, readonly) Float64 tempo;

- (id)initWithBMAudio:(BMAudio*)audio;
- (void)loadSequence;
- (void)play;
- (void)pause;
- (void)reset;
- (MusicTimeStamp)timeStamp;
- (CABarBeatTime)beatPosition;

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
