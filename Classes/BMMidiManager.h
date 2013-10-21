//
//  BMMidiManager.h
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMMidiInstrument <NSObject>
- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity;
- (void)noteOffWithNote:(UInt32)note;
@end

@interface BMMidiManager : NSObject
@property (nonatomic, weak, readwrite) id<BMMidiInstrument>instrumentDelegate;

+ (instancetype)sharedInstance;
- (void)setUp;
@end