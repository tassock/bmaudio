//
//  BMMusicPlayer.m
//  BMAudio
//
//  Created by Peter Marks on 10/21/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMMusicPlayer.h"

@implementation BMMusicPlayer

- (void)setUpFromGraph:(AUGraph)graph
{
    MusicPlayer p;
    MusicSequence s;
    
    
    NewMusicPlayer(&p);
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"presto" withExtension:@"mid"];
    
    NewMusicSequence(&s);
    MusicSequenceFileLoad(s, (__bridge CFURLRef)url, 0,0);
    
    MusicTrack t;
    MusicTimeStamp len;
    UInt32 sz = sizeof(MusicTimeStamp);
    MusicSequenceGetIndTrack(s, 0, &t);
    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &len, &sz);
    
    // this is it, arthur pewty! feed the track to the ausampler and let 'er rip
    MusicSequenceSetAUGraph(s, graph);
    //MusicTrackSetDestNode(t, samplerNode);
    
    
    MusicPlayerSetSequence(p, s);
    MusicPlayerPreroll(p);
    MusicPlayerStart(p);
    while (1) {
        usleep (3 * 1000 * 1000);
        MusicTimeStamp now = 0;
		MusicPlayerGetTime (p, &now);
        if (now >= len)
            break;
        NSLog(@"%f", now);
    }
    
    NSLog(@"finishing");
    
    // shut everything down in good order
//    AUGraphStop(graph);
    MusicPlayerStop(p);
//    DisposeAUGraph(graph);
    DisposeMusicSequence(s);
    DisposeMusicPlayer(p);
//    [mySession setActive: NO error:nil];
}

@end
