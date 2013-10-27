//
//  BMNoteEvent.h
//  BMAudio
//
//  Created by Peter Marks on 10/26/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMNoteEvent : NSObject
@property (nonatomic, readwrite, assign) Float64 beat;
@property (nonatomic, readwrite, assign) UInt8 note;
@property (nonatomic, readwrite, assign) UInt8 velocity;
@property (nonatomic, readwrite, assign) Float32 duration;
@end
