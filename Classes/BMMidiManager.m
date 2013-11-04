//
//  BMMidiManager.m
//  BMAudio
//
//  Created by Peter Marks on 10/20/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMMidiManager.h"
#import "BMAudioHelpers.h"

@interface BMMidiManager ()
{
    MIDIClientRef midiClient;
}
@property (nonatomic, readwrite, strong) NSMutableArray *listeners;
@end

@implementation BMMidiManager

// Library for MIDI connectivity:
// https://github.com/petegoodliffe/PGMidi

// Library for MIDI utilities
// https://github.com/meshula/LabMidi

// Guide about MIDI on iOS (questionable since their demo doesn't run)
// http://www.deluge.co/?q=all-things-midi

void MyMIDINotifyProc (const MIDINotification  *message, void *refCon) {
	printf("MIDI Notify, messageId=%d,", (int)message->messageID);
}

static void	MyMIDIReadProc(const MIDIPacketList *pktlist, void *refCon, void *connRefCon) {
    BMMidiManager *midiManager = (__bridge BMMidiManager*) refCon;
    
	MIDIPacket *packet = (MIDIPacket *)pktlist->packet;
	for (int i=0; i < pktlist->numPackets; i++) {
		Byte midiStatus = packet->data[0];
		Byte midiCommand = midiStatus >> 4;
		// is it a note-on or note-off
		if ((midiCommand == 0x09) ||
			(midiCommand == 0x08)) {
			Byte note = packet->data[1] & 0x7F;
			Byte velocity = packet->data[2] & 0x7F;
			printf("midiStatus=%d, midiCommand=%d. Note=%d, Velocity=%d\n", midiStatus, midiCommand, note, velocity);
            
            if (midiStatus == 144)
            {
                [midiManager reportNoteOnWithNote:note velocity:velocity];
            }
            else if (midiStatus == 128)
            {
                [midiManager reportNoteOffWithNote:note];
            }
		}
		packet = MIDIPacketNext(packet);
	}
}

+ (instancetype)sharedInstance
{
    static BMMidiManager *sharedInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        self.listeners = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)setUp
{
	CheckError (MIDIClientCreate(CFSTR("Core MIDI to System Sounds Demo"), MyMIDINotifyProc, (__bridge void *)self, &midiClient),
				"Couldn't create MIDI client");
	
	MIDIPortRef inPort;
	CheckError (MIDIInputPortCreate(midiClient, CFSTR("Input port"), MyMIDIReadProc, (__bridge void *)self, &inPort),
				"Couldn't create MIDI input port");
	
	unsigned long sourceCount = MIDIGetNumberOfSources();
	printf ("%ld sources\n", sourceCount);
	for (int i = 0; i < sourceCount; ++i) {
		MIDIEndpointRef src = MIDIGetSource(i);
		CFStringRef endpointName = NULL;
		CheckError(MIDIObjectGetStringProperty(src, kMIDIPropertyName, &endpointName),
				   "Couldn't get endpoint name");
		char endpointNameC[255];
		CFStringGetCString(endpointName, endpointNameC, 255, kCFStringEncodingUTF8);
		printf("  source %d: %s\n", i, endpointNameC);
		CheckError (MIDIPortConnectSource(inPort, src, NULL),
					"Couldn't connect MIDI port");
	}
}

- (void)addListener:(id<BMMidiListener>)listener
{
    [_listeners addObject:listener];
}

- (void)removeListener:(id<BMMidiListener>)listener
{
    [_listeners removeObject:listener];
}

- (void)reportNoteOnWithNote:(UInt32)note velocity:(UInt32)velocity
{
    for (id<BMMidiListener>listener in _listeners)
    {
        [listener noteOnWithNote:note velocity:velocity];
    }
}

- (void)reportNoteOffWithNote:(UInt32)note
{
    for (id<BMMidiListener>listener in _listeners)
    {
        [listener noteOffWithNote:note];
    }
}

@end
