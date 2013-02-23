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
//  OP1.m
//  Tornado
//
//  Created by Chris Davis on 23/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import "OP1.h"

@implementation OP1

static OP1* _sharedMySingleton = nil;
@synthesize BlueDial = m_BlueDial;
@synthesize GreenDial = m_GreenDial;
@synthesize WhiteDial = m_WhiteDial;
@synthesize OrangeDial = m_OrangeDial;
@synthesize BlueDialPrevious = m_BlueDialPrevious;
@synthesize GreenDialPrevious = m_GreenDialPrevious;
@synthesize WhiteDialPrevious = m_WhiteDialPrevious;
@synthesize OrangeDialPrevious = m_OrangeDialPrevious;

+ (OP1 *)instance
{
	@synchronized([OP1 class])
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
	@synchronized([OP1 class])
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
		//Change unique id for your device.
		[[MidiManager instance] createMidiSessionWithUniqueId:1322036174];
		[self reset];
	}
	return self;
}

- (void)start
{
	//Empty, just making sure singleton inits.
}

- (void)reset
{
	self.BlueDialPrevious = -1;
	self.GreenDialPrevious = -1;
	self.WhiteDialPrevious = -1;
	self.OrangeDialPrevious = -1;
	
	self.BlueDial = kBLUE_MIN;
	self.GreenDial = kGREEN_MIN;
	self.WhiteDial = kWHITE_MIN;
	self.OrangeDial = kORANGE_MIN;
}


- (void)onChange:(int)control value:(int)value
{
	switch (control) {
		case 1: //Blue
			[self DefaultInputs:value dialValue:&m_BlueDial dialPrevious:&m_BlueDialPrevious min:kBLUE_MIN max:kBLUE_MAX increment:1.0];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"blueChanged" object:self];
			break;
		case 2: //Green
			[self DefaultInputs:value dialValue:&m_GreenDial dialPrevious:&m_GreenDialPrevious min:kGREEN_MIN max:kGREEN_MAX increment:0.2];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"greenChanged" object:self];
			break;
		case 3: //White
			[self DefaultInputs:value dialValue:&m_WhiteDial dialPrevious:&m_WhiteDialPrevious min:kWHITE_MIN max:kWHITE_MAX increment:0.2];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"whiteChanged" object:self];
			break;
		case 4: //Orange
			[self DefaultInputs:value dialValue:&m_OrangeDial dialPrevious:&m_OrangeDialPrevious min:kORANGE_MIN max:kORANGE_MAX increment:0.5];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"orangeChanged" object:self];
			break;
		default:
			break;
	}
}


// I don't like the code I've written here, the only reason
// it's written like this is because the dials might not be
// set to 0 when the app launches, and I didn't want to write
// the 'write' midi stream. So instead I'm just taking the value,
// zero-ing it, then adding or taking away depending.
- (void)DefaultInputs:(int)value dialValue:(float *)dial dialPrevious:(float *)previous min:(float)min max:(float)max increment:(float)increment
{
	BOOL processed = FALSE;
	if (*previous == -1)
	{
		*dial = min;
		processed = TRUE;
	}
	
	if (value < *previous || value == kDIAL_MIN)
	{
		if (*dial > min && processed == FALSE)
			(*dial) -= increment;
	}
	
	if (value > *previous || value == kDIAL_MAX)
	{
		if (*dial < max && processed == FALSE)
			(*dial) += increment;
	}
	
	*previous = value;
}

/*
 BOOL processed = FALSE;
 if (self.BlueDialPrevious == -1)
 {
 self.BlueDial = 0;
 processed = TRUE;
 }
 
 if (value < self.BlueDialPrevious || value == kDIAL_MIN)
 {
 if (self.BlueDial > kBLUE_MIN && processed == FALSE)
 self.BlueDial--;
 }
 
 if (value > self.BlueDialPrevious || value == kDIAL_MAX)
 {
 if (self.BlueDial < kBLUE_MAX && processed == FALSE)
 self.BlueDial++;
 }
 
 
 self.BlueDialPrevious = value;
 */

@end
