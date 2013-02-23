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
//  TornadoView.m
//  Tornado
//
//  Created by Chris Davis on 19/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import "TornadoView.h"
#import "SwirlView.h"

@implementation TornadoView

float frame_rate = 45.0;
NSMutableArray *swirls;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)setup
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blueChanged:) name:@"blueChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(greenChanged:) name:@"greenChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whiteChanged:) name:@"whiteChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orangeChanged:) name:@"orangeChanged" object:nil];
	
	swirls = [[NSMutableArray alloc] init];

	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0/frame_rate
													  target:self
													selector:@selector(animate)
													userInfo:nil
													 repeats:YES];
	[timer fire];
}

- (void)blueChanged:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		int count = [swirls count];
		int dial = [[OP1 instance] BlueDial];

		if (dial < count)
			[self popSwirl];
		if (dial > count)
			[self pushSwirl];
	
	});
}
- (void)greenChanged:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		for (SwirlView *view in swirls)
		{
			view.Wobble_range = [OP1 instance].GreenDial;
		}
	});
}
- (void)whiteChanged:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		for (SwirlView *view in swirls)
		{
			view.Wobble_speed = [OP1 instance].WhiteDial;
		}
	});
}
- (void)orangeChanged:(id)sender
{
	
}

- (float)between:(int)min max:(int)max
{
	return min + arc4random() % (max - min);
}

- (void)pushSwirl
{
	int count = [swirls count];
	
	//Set a hard limit of swirls
	if (count > kBLUE_MAX)
		return;
	
	float square = 5;
	float y = 0;
	float x = 0;
	float x_offset = 50.0;
	
	
	y = count * 15;
	square = count * 5;
	x = (100-square)/2;
	
	SwirlView *s = [[SwirlView alloc] initWithFrame:CGRectMake(x+x_offset, y, square, square)];
	s.AngleIncrement = [self between:5 max:16];
	s.Wobble_range = kGREEN_MIN;
	s.Wobble_speed = kWHITE_MIN;
	s.Frame_rate = frame_rate;
	s.X = 0;
	[self addSubview:s];
	[swirls insertObject:s atIndex:0];
	[s release];
	
	int ptr = 15;
	for (SwirlView *v in swirls)
	{
		CGRect frame = v.frame;
		frame.origin.y = ptr;
		v.frame = frame;
		ptr += 15;
	}
}

- (void)popSwirl
{
	int count = [swirls count];
	if (count > 0)
	{
		SwirlView *view = [swirls objectAtIndex:0];
		[view removeFromSuperview];
		[swirls removeObjectAtIndex:0];
	}
	int ptr = 15;
	for (SwirlView *v in swirls)
	{
		CGRect frame = v.frame;
		frame.origin.y = ptr;
		v.frame = frame;
		ptr += 15;
	}
}

//This is probably excessive.
- (void)animate
{
	for (SwirlView *view in swirls)
	{
		[view setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    CGContextFillRect(context, self.bounds);
}

// Used for debugging, tapping the screen can change the Tornado
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [[event touchesForView:self] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	
	if (location.x > 400)
	{
		[self pushSwirl];
	} else {
		[self popSwirl];
	}
}

@end
