//
//  BMSamplerUnit.h
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudioUnit.h"
#import "BMMidiManager.h"

@interface BMSamplerUnit : BMAudioUnit <BMMidiInstrument>

- (void)loadPreset:(NSString*)presetName;

- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity;
- (void)noteOffWithNote:(UInt32)note;

@end
