//
//  BMAudioUnit.h
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMAudioUnit : NSObject
{
@public
    AudioUnit audioUnit;
    AUNode audioNode;
    AudioComponentDescription componentDescription;
@private
}

+ (instancetype)unit;

@end