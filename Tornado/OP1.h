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
//  OP1.h
//  Tornado
//
//  Created by Chris Davis on 23/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidiManager.h"

#define kDIAL_MIN 0
#define kDIAL_MAX 40

#define kBLUE_MIN 0.0
#define kBLUE_MAX 20.0
#define kGREEN_MIN 0.0
#define kGREEN_MAX 5.0
#define kWHITE_MIN 0.0
#define kWHITE_MAX 5.0
#define kORANGE_MIN 0.0
#define kORANGE_MAX 5.0

@interface OP1 : NSObject
{
	float m_BlueDialPrevious;
	float m_GreenDialPrevious;
	float m_WhiteDialPrevious;
	float m_OrangeDialPrevious;
	
	float m_BlueDial;
	float m_GreenDial;
	float m_WhiteDial;
	float m_OrangeDial;
}

@property (assign) float BlueDialPrevious;
@property (assign) float GreenDialPrevious;
@property (assign) float WhiteDialPrevious;
@property (assign) float OrangeDialPrevious;

@property (assign) float BlueDial;
@property (assign) float GreenDial;
@property (assign) float WhiteDial;
@property (assign) float OrangeDial;

+ (OP1 *)instance;
+ (id)alloc;
- (id)init;
- (void)start;
- (void)reset;
- (void)onChange:(int)control value:(int)value;
- (void)DefaultInputs:(int)value dialValue:(float *)dial dialPrevious:(float *)previous min:(float)min max:(float)max;

@end
