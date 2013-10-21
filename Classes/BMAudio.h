//
//  BMAudio.h
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMAudioTrack;

@interface BMAudio : NSObject

+ (instancetype)sharedInstance;

#ifdef TARGET_OS_IOS
- (void)setUpIOSAudioSession;
#endif

- (void)setUpAudioGraph;

- (void)loadAudioTrack:(BMAudioTrack*)audioTrack;

@end
