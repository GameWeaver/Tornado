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
//  SwirlView.m
//  Tornado
//
//  Created by Chris Davis on 19/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import "SwirlView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SwirlView
@synthesize AngleIncrement;

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGPoint move;
CGPoint curve;
CGPoint controlA;
CGPoint controlB;
CATransform3D t;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		//rotate layer to be flat
		
		t = self.layer.transform;
		//t = CATransform3DMakeTranslation(25, 0, 0);
		t = CATransform3DRotate(t,radians(70.0f), 1.0, 0.0, 0.0);
		//t = CATransform3DMakeRotation(radians(70.0f), 1.0, 0.0, 0.0);
		
		self.AngleIncrement = 1.0;
		self.X = 0;
		
		//Seed r with a random value so we don't have the same rotation
		//for each swirl
		int lowerBound = 0;
		int upperBound = 360;
		int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
		self.R = rndValue;
		
		//t = CATransform3DRotate(t,radians(rndValue), 0, 0, 1);
		
		//self.layer.anchorPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
		//self.layer.anchorPoint = CGPointMake(0.0, 0);
		//CGPoint anchor = self.layer.anchorPoint;
		//float anchorZ = self.layer.anchorPointZ;
		//self.layer.anchorPointZ = 25.0;
		//CGPoint c = self.center;
		//self.center = CGPointMake(50, 50);
		//CATransform3D transform = t;
		//CGAffineTransform affineTransform = CATransform3DGetAffineTransform(transform);
		//CGPoint v = CGPointMake(10, 10);
		//CGPoint offset = CGPointApplyAffineTransform(v, affineTransform);
		
		//move = CGPointMake(17.5, 5.5);
		//curve = CGPointMake(39.5, 5.5);
		//controlA = CGPointMake(0.29, 34.75);
		//controlB = CGPointMake(56.16, 35.77);
		
		[self setClearsContextBeforeDrawing:YES];
		[self setBackgroundColor:[UIColor clearColor]];
		
		/*[UIView beginAnimations:nil context:nil];
		 CATransform3D _3Dt = CATransform3DRotate(self.layer.transform,3.14, 0.0, 0.0 ,1.0);
		 [UIView setAnimationRepeatCount:100];
		 [UIView setAnimationDuration:.08];
		 self.layer.transform=_3Dt;
		 [UIView commitAnimations];*/
		
		/*NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60
		 target:self
		 selector:@selector(rotate)
		 userInfo:nil
		 repeats:YES];
		 [timer fire];*/
		
    }
    return self;
}

/*- (void)rotate {
 [self setNeedsDisplay];
 self.R += 1.0;
 if (self.R >= 360)
 self.R = 0;
 }*/

- (void)drawRect:(CGRect)rect
{
	
	float w_speed = self.Wobble_speed;
	float w_range = self.Wobble_range;
	
	NSLog(@"wobble");
	float amt = w_speed;
	NSLog(@"amt: %f", amt);
	if (self.Dir == FALSE)
	{
		self.X += amt;
		if (self.X >= w_range)
			self.Dir = TRUE;
	} else {
		self.X -= amt;
		if (self.X <= -w_range)
			self.Dir = FALSE;
	}
	
	//SwirlView *v = [swirls objectAtIndex:0];
	CGRect f = self.frame;
	f.origin.x += self.X;
	self.frame = f;
	
	
	
	self.R += self.AngleIncrement;
	if (self.R >= 360)
		self.R = self.R-360;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	/*CGContextBeginPath(context);
	 CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
	 CGContextSetAlpha(context, 1.0);
	 CGContextFillRect(context, self.bounds);*/
	
	
	//// Color Declarations
	UIColor* strokeColor = [UIColor colorWithRed: 0.886 green: 0 blue: 0 alpha: 1];
	
	//// Shadow Declarations
	UIColor* shadow2 = strokeColor;
	CGSize shadow2Offset = CGSizeMake(0.1, 1.1);
	CGFloat shadow2BlurRadius = 3.2;
	
	
	CATransform3D transform;
	//1
	//transform = CATransform3DTranslate(t, 50, 50, 0);
	//transform = CATransform3DRotate(transform,radians(self.R),0,0,1 );
	//transform = CATransform3DTranslate(transform, -25, -15, 0);
	
	//2
	float width = self.bounds.size.width;
	float height = self.bounds.size.height;
	transform = CATransform3DTranslate(t, width/2, height, 0);
	transform = CATransform3DRotate(transform,radians(self.R),0,0,1 );
	transform = CATransform3DTranslate(transform, -width/2, -height/2, 0);
	
	
	CGAffineTransform affineTransform = CATransform3DGetAffineTransform(transform);
	
	
	/*
	 1
	 CGPoint dmove = CGPointApplyAffineTransform(move, affineTransform);
	 CGPoint dcurve = CGPointApplyAffineTransform(curve, affineTransform);
	 CGPoint dcontrolA = CGPointApplyAffineTransform(controlA, affineTransform);
	 CGPoint dcontrolB = CGPointApplyAffineTransform(controlB, affineTransform);
	 
	 
	 //// Bezier 2 Drawing
	 UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
	 [bezier2Path moveToPoint:dmove];
	 [bezier2Path addCurveToPoint:dcurve controlPoint1:dcontrolA controlPoint2:dcontrolB];
	 CGContextSaveGState(context);
	 CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
	 [strokeColor setStroke];
	 bezier2Path.lineWidth = 2.5;
	 [bezier2Path stroke];*/
	
	
	// 2
	//// Frames
	CGRect frame = self.bounds;
	
	CGPoint dmove = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 0.21500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85500 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcurveA = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 0.49000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15000 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcontrolA1 = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + -0.12671 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54470 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcontrolA2 = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 0.20967 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14539 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcurveB = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 0.78000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85500 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcontrolB1 = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 0.79514 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15502 * CGRectGetHeight(frame)), affineTransform);
	CGPoint dcontrolB2 = CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(frame) + 1.09706 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54598 * CGRectGetHeight(frame)), affineTransform);
	
	
	//// Bezier 3 Drawing
	UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
	[bezier3Path moveToPoint:dmove];
	[bezier3Path addCurveToPoint:dcurveA  controlPoint1:dcontrolA1  controlPoint2: dcontrolA2];
	[bezier3Path addCurveToPoint:dcurveB  controlPoint1:dcontrolB1  controlPoint2: dcontrolB2];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
	[strokeColor setStroke];
	bezier3Path.lineWidth = 2.5;
	[bezier3Path stroke];
	
	
}

@end
