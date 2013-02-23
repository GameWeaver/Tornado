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
//  AppDelegate.m
//  Tornado
//
//  Created by Chris Davis on 17/02/2013.
//  Copyright (c) 2013 GameWeaver Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <CoreMIDI/MIDINetworkSession.h>
#import <CoreMIDI/CoreMIDI.h>

@implementation AppDelegate

@synthesize session;
MIDIClientRef midiClient;
MIDIPortRef inputPort;

- (void)dealloc
{
	[_window release];
	[_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
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
        return NO;
	}

	result = MIDIInputPortCreate(midiClient, CFSTR("Input"), midiInputCallback, NULL, &inputPort);
	
	
	
	MIDIObjectRef endPoint;
	MIDIObjectType foundObj;
    
	result = MIDIObjectFindByUniqueID(1322036174, &endPoint, &foundObj);
	
	result = MIDIPortConnectSource(inputPort, endPoint, NULL);
	
	//CFRunLoopRun();
	
	NSLog(@"after run loop");
	
	
	
	//[self scanExistingDevices];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
	//[[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
	
	
	
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)find
{
	NSMutableArray *_accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
	EAAccessory *accessory = nil;
	NSString *protocol = @"com.redpark.hobdb9";
	for(EAAccessory *obj in _accessoryList)
    {
        if ([[obj protocolStrings] containsObject:protocol])//if find the accessory(p25) record it
        {
            //[accessoryLabel setText:@"P25mi connected"]; // yup this is correct accessory!
			accessory = obj;
            //[obj release];
            break;
        }
    }
	
	//if accessory not null
	if(accessory != nil)
	{
		//[self popup:@"found"];
		session = [[EASession alloc] initWithAccessory:accessory forProtocol:protocol];//initial session that pair with protocol string
		[[session outputStream] setDelegate:self];//set delegate class for output stream
		[[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode]; //set outputstream loop
		[[session outputStream] open]; //open session
		[[session inputStream] setDelegate:self];
		[[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[[session inputStream] open];
	}
}

-(void)_accessoryDidConnect:(id)sender
{
	//[self popup:@"connected"];
	[self find];
}
-(void)_accessoryDidDisconnect:(id)sender
{
	NSLog(@"davis - disconnected");
}

//this is a stream listener function that would actived by system while steam has any event
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	
	//[self popup:[theStream debugDescription]];
	
    switch(streamEvent)
    {
        case NSStreamEventOpenCompleted:
            if(theStream==[session outputStream])//to identify which stream has been opend
            {
				NSLog(@"davis - NSStreamEventOpenCompleted out");
            }
            else
            {
                NSLog(@"davis - NSStreamEventOpenCompleted in");
            }
			
			
            break;
        case NSStreamEventHasBytesAvailable:
            //if system has stream data comes in
            NSLog(@"davis - NSStreamEventHasBytesAvailable");
			
            break;
        case NSStreamEventHasSpaceAvailable:
			
            NSLog(@"davis - NSStreamEventHasSpaceAvailable");
			
			
            break;
        case NSStreamEventErrorOccurred:
			NSLog(@"davis - NSStreamEventErrorOccurred");
            break;
        default:
			NSLog(@"davis - other");
            break;
    }
}

- (void)popup:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:message
												   delegate:self
										  cancelButtonTitle:@"ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


NSString *getDisplayName(MIDIObjectRef object)
{
	// Returns the display name of a given MIDIObjectRef as an NSString
	CFStringRef name = nil;
	if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyDisplayName, &name))
		return nil;
	return (NSString *)name;
}


static void
midiInputCallback (const MIDIPacketList *list,
                   void *procRef,
                   void *srcRef)
{
    NSLog(@"midiInputCallback was called");
}




- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
