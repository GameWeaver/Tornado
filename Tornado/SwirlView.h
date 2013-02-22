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
//  SwirlView.h
//  Tornado
//
//  Created by Chris Davis on 19/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwirlView : UIView
{
	
}
@property (assign) int R;
@property (assign) float AngleIncrement;

@property (assign) float Wobble_range;
@property (assign) float Wobble_speed;
@property (assign) float Frame_rate;
@property (assign) float X;
@property (assign) BOOL Dir;
@end
