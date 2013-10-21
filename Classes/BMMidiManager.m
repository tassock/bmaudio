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
@end

@implementation BMMidiManager

void MyMIDINotifyProc (const MIDINotification  *message, void *refCon) {
	printf("MIDI Notify, messageId=%d,", message->messageID);
}

static void	MyMIDIReadProc(const MIDIPacketList *pktlist, void *refCon, void *connRefCon) {
    //	MyMIDIPlayer *player = (MyMIDIPlayer*) refCon;
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
            
            if (midiManager.instrumentDelegate)
            {
                if (midiStatus == 144)
                {
                    [midiManager.instrumentDelegate noteOnWithNote:note velocity:velocity];
                }
                else if (midiStatus == 128)
                {
                    [midiManager.instrumentDelegate noteOffWithNote:note];
                }
            }
			
			// send to augraph
            //			CheckError(MusicDeviceMIDIEvent (player->instrumentUnit,
            //											 midiStatus,
            //											 note,
            //											 velocity,
            //											 0),
            //					   "Couldn't send MIDI event");
			
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

@end
