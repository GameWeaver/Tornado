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
//  MidiManager.h
//  Tornado
//
//  Created by Chris Davis on 23/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//  Also, thanks to The Mgmt from:
//  http://comelearncocoawithme.blogspot.co.uk/2011/08/reading-from-external-controllers-with.html

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "OP1.h"

#define SYSEX_LENGTH 1024

@interface MidiManager : NSObject
{
	MIDIClientRef midiClient;
	MIDIPortRef inputPort;
}

+ (MidiManager *)instance;
+ (id)alloc;
- (id)init;
- (void)createMidiSessionWithUniqueId:(SInt32)uniqueId;
NSString *getDisplayName(MIDIObjectRef object);
static void midiInputCallback (const MIDIPacketList *list, void *procRef, void *srcRef);

@end
