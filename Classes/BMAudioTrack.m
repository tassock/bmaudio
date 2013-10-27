//
//  BMAudioTrack.m
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudioTrack.h"

@implementation BMAudioTrack

+ (instancetype)trackWithUnits:(NSArray*)audioUnits
{
    return [[[self class] alloc] initWithUnits:audioUnits];
}

- (id)initWithUnits:(NSArray*)audioUnits
{
    if (self = [super init])
    {
        self.audioUnits = audioUnits;
    }
    return self;
}

/**
 *  NOTE: If you edit a music track after associating it with a music event iterator, you must discard iterator and create a new one. 
 */

@end
