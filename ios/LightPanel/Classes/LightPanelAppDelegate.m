//
//  LightPanelAppDelegate.m
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import "LightPanelAppDelegate.h"
#import "LightPanelViewController.h"

static LightPanelAppDelegate *_delegate = nil;

@implementation LightPanelAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize actionPanelViewController;

#pragma mark -
#pragma mark Application lifecycle

-(id)init
{
    self = [super init];
    _delegate = self;
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

	return YES;
}

-(void)showActionsPanel
{
    if (actionPanelViewController == nil)
        actionPanelViewController = [[ActionsPanelViewController alloc] init];
    
    [self.viewController.view removeFromSuperview];
    [self.window addSubview:actionPanelViewController.view];
    [self.window makeKeyAndVisible];
}

-(void)removeActionsPanel
{
    if (actionPanelViewController != nil)
        [actionPanelViewController.view removeFromSuperview];
    
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
}

-(NSUserDefaults *)getSettings
{
    if (defaults == nil)
    {
        defaults = [[NSUserDefaults standardUserDefaults] retain];
        //set user defaults
        NSDictionary *initialDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:@"192.168.1.8", @"server_addr", @"8080", @"server_port", @"192.168.1.18", @"web_server_addr", @"4567", @"web_server_port", nil];
        [defaults registerDefaults:initialDefaults];
        [initialDefaults release];
    }
    
    return defaults;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    _delegate = self;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

+(LightPanelAppDelegate *)instance
{
    return _delegate;
}


@end
