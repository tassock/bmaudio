//
//  BMSamplerUnit.h
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudioUnit.h"

@interface BMSamplerUnit : BMAudioUnit

- (void)loadPreset:(NSString*)presetName;

- (void)noteOnWithNote:(NSUInteger)note velocity:(NSUInteger)velocity;
- (void)noteOffWithNote:(NSUInteger)note;

@end
