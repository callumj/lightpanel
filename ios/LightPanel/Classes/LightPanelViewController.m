//
//  LightPanelViewController.m
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import "LightPanelViewController.h"

@implementation LightPanelViewController

@synthesize touchView;
@synthesize modeSelector;

@synthesize serverAddress;
@synthesize serverPort;
@synthesize penMode;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}*/

-(void)openSocket
{
	// This will be the write stream.
	writeStream = NULL;
	
	// Create socket.
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
									   (CFStringRef) serverAddress,
									   serverPort,
									   nil,
									   &writeStream);
	CFWriteStreamOpen(writeStream);
}

-(void)sendSocket:(NSString *)data {
	
	// Open write stream.
	if (writeStream != NULL)
	{
		NSString *message = [NSString stringWithString:data];
		CFWriteStreamWrite(writeStream, [message UTF8String], [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	}
	CFErrorRef streamErr = CFWriteStreamCopyError(writeStream);
}

-(void)loadSettings
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//set user defaults
	NSDictionary *initialDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:@"192.168.1.8", @"server_addr", @"8080", @"server_port", nil];
	[defaults registerDefaults:initialDefaults];
	
	self.serverAddress = [[NSString alloc] initWithString:[defaults stringForKey:@"server_addr"]];
	self.serverPort = [defaults integerForKey:@"server_port"];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	penMode = YES;
	[self loadSettings];
	[self openSocket];
	[self syncModeWithUI];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTouchFromNotification:) name:kTouchBeganForTouchView object:nil];
}

-(void)handleTouchFromNotification:(NSNotification *)notification
{
	UITouch *touchPoint = [notification object];
	CGPoint tPoint = [touchPoint locationInView:self.touchView];
	CGFloat percentY = (tPoint.y / self.touchView.bounds.size.height) * 100;
	CGFloat percentX = (tPoint.x / self.touchView.bounds.size.width) * 100;
	
	int brightness = 100;
	if (!penMode)
		brightness = 0;
	
	NSString *sendData = [[NSString alloc] initWithFormat:@"%.2f%% %.2f%% %d\r\n", percentY, percentX, brightness];
	[self sendSocket:sendData];
	[sendData autorelease];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction)switchPen:(id)sender
{
	penMode = !penMode;
	[self syncModeWithUI];
}

-(void)syncModeWithUI
{
	UIImage *buttonImage;
	if (penMode)
		buttonImage = [UIImage imageNamed:@"pencil.png"];
	else
		buttonImage = [UIImage imageNamed:@"erase.png"];
	
	[modeSelector setImage:buttonImage forState:UIControlStateNormal];
	[modeSelector setImage:buttonImage forState:UIControlStateHighlighted];
	[modeSelector setImage:buttonImage forState:UIControlStateSelected];
	[buttonImage autorelease];
}

@end
