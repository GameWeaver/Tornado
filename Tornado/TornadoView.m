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

float wobble_range = 5.0;
float wobble_speed = 50.0;
float frame_rate = 45.0;
float x = 0;
BOOL dir = FALSE;
NSMutableArray *swirls;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)setup
{
	swirls = [[NSMutableArray alloc] init];
	
	[self createSwirls:15];

	
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0/frame_rate
													  target:self
													selector:@selector(animate)
													userInfo:nil
													 repeats:YES];
	[timer fire];
	
}

- (float)between:(int)min max:(int)max
{
	return min + arc4random() % (max - min);
}

- (void)createSwirls:(int)n
{
	float square = 100;
	float y = 0;
	float x = 0;
	
	for (int i = 0; i < n; i++)
	{
		y = i * 15;
		
		//cone shape
		square = square - 6;
		x = (100-square)/2;

		SwirlView *s = [[SwirlView alloc] initWithFrame:CGRectMake(x, y, square, square)];
		s.AngleIncrement = [self between:5 max:16];
		//s.AngleIncrement = 8.2;
		//s.Wobble_range = [self between:2 max:8];
		//s.Wobble_speed = [self between:20 max:50];
		s.Wobble_range = 0.0;
		s.Wobble_speed = 0.0;
		s.Frame_rate = frame_rate;
		s.X = 0;
		[self addSubview:s];
		[swirls addObject:s];
		[s release];
	}
}

- (void)animate
{
	for (SwirlView *view in swirls)
	{
		[view setNeedsDisplay];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    CGContextFillRect(context, self.bounds);

	//CGContextRestoreGState(context);
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//UITouch *touch = [[event touchesForView:self] anyObject];
	//CGPoint location = [touch locationInView:touch.view];
	
	for (SwirlView *view in swirls)
	{
		CGRect frame = view.frame;
		frame.size.width += 5.0;
		frame.size.height += 5.0;
		view.frame = frame;
	}
	
}

@end
