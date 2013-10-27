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
- (void)setUp;
- (void)addListener:(id<BMMidiListener>)listener;
- (void)removeListener:(id<BMMidiListener>)listener;
@end