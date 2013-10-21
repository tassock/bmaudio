//
//  BMMixerUnit.h
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMAudioUnit.h"

@interface BMMixerUnit : BMAudioUnit
@property (nonatomic, readwrite, assign) NSUInteger numChannels;
- (void)setDefaults;
@end
