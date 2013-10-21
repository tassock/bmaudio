//
//  BMSamplerUnit.m
//  BMAudio
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMSamplerUnit.h"
#import "BMAudioHelpers.h"

@implementation BMSamplerUnit

- (id)init
{
    if (self = [super init])
    {
        AudioComponentDescription cd = {0};
        cd.componentType = kAudioUnitType_MusicDevice;
        cd.componentSubType = kAudioUnitSubType_Sampler;
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        componentDescription = cd;
    }
    return self;
}

- (void)loadPreset:(NSString*)presetName
{
    NSURL *presetURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:presetName ofType:@"aupreset"]];
    
	CFDataRef propertyResourceData = 0;
	
	// Read from the URL and convert into a CFData chunk
	CFURLCreateDataAndPropertiesFromResource (
                                              kCFAllocatorDefault,
                                              (__bridge CFURLRef) presetURL,
                                              &propertyResourceData,
                                              nil,
                                              nil,
                                              nil
                                              );
    
   	
	// Convert the data object into a property list
	CFPropertyListRef presetPropertyList = 0;
	CFPropertyListFormat dataFormat = 0;
	presetPropertyList = CFPropertyListCreateWithData (
                                                       kCFAllocatorDefault,
                                                       propertyResourceData,
                                                       kCFPropertyListImmutable,
                                                       &dataFormat,
                                                       nil
                                                       );
    
    // Set the class info property for the Sampler unit using the property list as the value.
    
    AudioUnitSetProperty(
                         audioUnit,
                         kAudioUnitProperty_ClassInfo,
                         kAudioUnitScope_Global,
                         0,
                         &presetPropertyList,
                         sizeof(CFPropertyListRef)
                         );
    
    CFRelease(presetPropertyList);
    
	CFRelease (propertyResourceData);
}

- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity
{
    CheckError(MusicDeviceMIDIEvent (audioUnit,
                                     144,
                                     note,
                                     velocity,
                                     0),
               "Couldn't send MIDI event");
}

- (void)noteOffWithNote:(UInt32)note
{
    CheckError(MusicDeviceMIDIEvent (audioUnit,
                                     128,
                                     note,
                                     64,
                                     0),
               "Couldn't send MIDI event");
}

@end
