//
//  BMMusicPlayer.h
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMMusicPlayer : NSObject
@property (nonatomic, strong, readwrite) NSString *midiFileName;

- (id)initWithGraph:(AUGraph)argGraph;
- (void)play;
- (void)pause;
- (void)reset;
- (MusicTimeStamp)timeStamp;

@end
