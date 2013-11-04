//
//  BMMidiManager.h
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMMidiListener <NSObject>
- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity;
- (void)noteOffWithNote:(UInt32)note;
@end

// TODO rename to BMMidiPlaybackManager
@interface BMMidiManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  Begin listening for midi. Currently does not report detecting sources after they've been added.
 */
- (void)setUp;

/**
 *  Add a listner to receive midi events
 *
 *  @param listener object to add to receive midi events
 */
- (void)addListener:(id<BMMidiListener>)listener;

/**
 *  Remove a listener from receiving midi events. Must be called whenever listener object is deallocated
 *
 *  @param listener object to remove from receiving midi events
 */
- (void)removeListener:(id<BMMidiListener>)listener;

/**
 *  Report a note on event to all listeners
 *
 *  @param note     midi note number to report
 *  @param velocity midi velocity to report
 */
- (void)reportNoteOnWithNote:(UInt32)note velocity:(UInt32)velocity;

/**
 *  Report a note off event to all listeners
 *
 *  @param note midi note number to report
 */
- (void)reportNoteOffWithNote:(UInt32)note;

@end