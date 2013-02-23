//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License. You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
//  License for the specific language governing permissions and limitations under
//  the License.
//
//  MidiManager.m
//  Tornado
//
//  Created by Chris Davis on 23/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//  Also, thanks to The Mgmt from:
//  http://comelearncocoawithme.blogspot.co.uk/2011/08/reading-from-external-controllers-with.html

#import "MidiManager.h"

@implementation MidiManager

static MidiManager* _sharedMySingleton = nil;

+ (MidiManager *)instance
{
	@synchronized([MidiManager class])
	{
		if (!_sharedMySingleton)
        {
			[[self alloc] init];
        }
        
		return _sharedMySingleton;
	}
    
	return nil;
}

+ (id)alloc
{
	@synchronized([MidiManager class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
    
	return nil;
}

- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	return self;
}

- (void)createMidiSessionWithUniqueId:(SInt32)uniqueId
{
	NSLog(@"Iterate through destinations");
	ItemCount destCount = MIDIGetNumberOfDestinations();
	for (ItemCount i = 0 ; i < destCount ; ++i) {
		
		// Grab a reference to a destination endpoint
		MIDIEndpointRef dest = MIDIGetDestination(i);
		if (dest != NULL) {
			NSLog(@"  Destination: %@", getDisplayName(dest));
		}
	}
	
	NSLog(@"Iterate through sources");
	// Virtual sources and destinations don't have entities
	ItemCount sourceCount = MIDIGetNumberOfSources();
	for (ItemCount i = 0 ; i < sourceCount ; ++i) {
		
		MIDIEndpointRef source = MIDIGetSource(i);
		if (source != NULL) {
			NSLog(@"  Source: %@", getDisplayName(source));
		}
	}
	
	ItemCount numOfDevices = MIDIGetNumberOfDevices();
    
	for (int i = 0; i < numOfDevices; i++) {
		MIDIDeviceRef midiDevice = MIDIGetDevice(i);
		NSDictionary *midiProperties;
        
		MIDIObjectGetProperties(midiDevice, (CFPropertyListRef *)&midiProperties, YES);
		NSLog(@"Midi properties: %d \n %@", i, midiProperties);
	}
	
	
	OSStatus result;
    
	result = MIDIClientCreate(CFSTR("MIDI client"), NULL, NULL, &midiClient);
	if (result != noErr) {
        return;
	}
	
	result = MIDIInputPortCreate(midiClient, CFSTR("Input"), midiInputCallback, NULL, &inputPort);
	
	
	
	MIDIObjectRef endPoint;
	MIDIObjectType foundObj;
    
	result = MIDIObjectFindByUniqueID(uniqueId, &endPoint, &foundObj);
	
	result = MIDIPortConnectSource(inputPort, endPoint, NULL);
}


NSString *getDisplayName(MIDIObjectRef object)
{
	// Returns the display name of a given MIDIObjectRef as an NSString
	CFStringRef name = nil;
	if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyDisplayName, &name))
		return nil;
	return (NSString *)name;
}


static void midiInputCallback (const MIDIPacketList *list, void *procRef, void *srcRef)
{
    NSLog(@"midiInputCallback was called");
	
	bool continueSysEx = false;
	UInt16 nBytes;
    const MIDIPacket *packet = &list->packet[0];
	unsigned char sysExMessage[SYSEX_LENGTH];
    unsigned int sysExLength = 0;
	
	for (unsigned int i = 0; i < list->numPackets; i++) {
        nBytes = packet->length;
		
		// Check if this is the end of a continued SysEx message
        if (continueSysEx) {
            unsigned int lengthToCopy = MIN (nBytes, SYSEX_LENGTH - sysExLength);
            // Copy the message into our SysEx message buffer,
            // making sure not to overrun the buffer
            memcpy(sysExMessage + sysExLength, packet->data, lengthToCopy);
            sysExLength += lengthToCopy;
			
			// Check if the last byte is SysEx End.
            continueSysEx = (packet->data[nBytes - 1] == 0xF7);
			
			if (!continueSysEx || sysExLength == SYSEX_LENGTH) {
                // We would process the SysEx message here, as it is we're just ignoring it
                
                sysExLength = 0;
            }
        } else {
			
			UInt16 iByte, size;
            
            iByte = 0;
            while (iByte < nBytes) {
                size = 0;
                
                // First byte should be status
                unsigned char status = packet->data[iByte];
                if (status < 0xC0) {
                    size = 3;
                } else if (status < 0xE0) {
                    size = 2;
                } else if (status < 0xF0) {
                    size = 3;
                } else if (status == 0xF0) {
                    // MIDI SysEx then we copy the rest of the message into the SysEx message buffer
                    unsigned int lengthLeftInMessage = nBytes - iByte;
                    unsigned int lengthToCopy = MIN (lengthLeftInMessage, SYSEX_LENGTH);
                    
                    memcpy(sysExMessage + sysExLength, packet->data, lengthToCopy);
                    sysExLength += lengthToCopy;
                    
                    size = 0;
                    iByte = nBytes;
					
                    // Check whether the message at the end is the end of the SysEx
                    continueSysEx = (packet->data[nBytes - 1] != 0xF7);
                } else if (status < 0xF3) {
                    size = 3;
                } else if (status == 0xF3) {
                    size = 2;
                } else {
                    size = 1;
                }
				
                unsigned char messageType = status & 0xF0;
                unsigned char messageChannel = status & 0xF;
				
				switch (status & 0xF0) {
                    case 0x80:
                        NSLog(@"Note off: %d, %d", packet->data[iByte + 1], packet->data[iByte + 2]);
                        break;
                        
                    case 0x90:
                        NSLog(@"Note on: %d, %d", packet->data[iByte + 1], packet->data[iByte + 2]);
                        break;
                        
                    case 0xA0:
                        NSLog(@"Aftertouch: %d, %d", packet->data[iByte + 1], packet->data[iByte + 2]);
                        break;
                        
                    case 0xB0:
                        NSLog(@"Control message: %d, %d", packet->data[iByte + 1], packet->data[iByte + 2]);
						[[OP1 instance] onChange:packet->data[iByte + 1] value:packet->data[iByte + 2]];
                        break;
                        
                    case 0xC0:
                        NSLog(@"Program change: %d", packet->data[iByte + 1]);
                        break;
                        
                    case 0xD0:
                        NSLog(@"Change aftertouch: %d", packet->data[iByte + 1]);
                        break;
                        
                    case 0xE0:
                        NSLog(@"Pitch wheel: %d, %d", packet->data[iByte + 1], packet->data[iByte + 2]);
                        break;
                        
                    default:
                        NSLog(@"Some other message %hhu", status);
                        break;
                }
                
                iByte += size;
            }
        }
		
		packet = MIDIPacketNext(packet);
    }
	
}



@end
