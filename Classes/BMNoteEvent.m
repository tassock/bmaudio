//
//  BMNoteEvent.m
//  BMAudio
//
//  Created by Peter Marks on 10/26/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMNoteEvent.h"

@implementation BMNoteEvent

- (NSString*)description
{
    return [NSString stringWithFormat:@"beat=%f, note=%u, velocity=%u, duration%f", _beat, _note, _velocity, _duration];
}

@end
