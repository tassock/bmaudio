//
//  BMAudioTrack.h
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMAudioTrack : NSObject
@property (nonatomic, readwrite, strong) NSArray *audioUnits;

+ (instancetype)trackWithUnits:(NSArray*)audioUnits;
@end
