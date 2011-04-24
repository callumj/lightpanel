//
//  ActionsPanelViewController.m
//  LightPanel
//
//  Created by Callum Jones on 22/04/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import "ActionsPanelViewController.h"

@implementation ActionsPanelViewController

@synthesize switchBackButton;
@synthesize sleepSlider;
@synthesize sleepLabel;

@synthesize strobeButton;
@synthesize dotsButton;
@synthesize fadeButton;
@synthesize scrollButton;
@synthesize snakeButton;

@synthesize allOffButton;
@synthesize allOnButton;
@synthesize stopButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [[LightPanelAppDelegate instance] getSettings];
	webServerHost = [[NSString alloc] initWithString:[defaults stringForKey:@"web_server_addr"]];
	webServerPort = [defaults integerForKey:@"web_server_port"];
    
    [self sliderChangedValue:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)switchBackToTouchView:(id)sender
{
    [[LightPanelAppDelegate instance] removeActionsPanel];
}

-(NSString *)constructArgs
{
    NSString *args = [NSString stringWithFormat:@"sleep_time/%1.2f", powf([sleepSlider value], 2.0)];
    return args;
}

-(IBAction)performActionOnTouchDown:(id)sender
{
    lastActionPerformed = [[NSDate date] retain];
    
    if (sender == strobeButton)
        [self runActionOnServer:@"strobe" withArgs:[self constructArgs]];
    else if (sender == allOnButton)
        [self runActionOnServer:@"allOn" withArgs:nil];
    else if (sender == allOffButton)
        [self runActionOnServer:@"allOff" withArgs:nil];
    else if (sender == stopButton)
        [self runActionOnServer:@"stop" withArgs:nil];
    else if (sender == snakeButton)
        [self runActionOnServer:@"snake_decay" withArgs:[self constructArgs]];
    else if (sender == dotsButton)
        [self runActionOnServer:@"random_dots" withArgs:[self constructArgs]];
    else if (sender == fadeButton)
        [self runActionOnServer:@"fade_in" withArgs:[self constructArgs]];
    else if (sender == scrollButton)
        [self runActionOnServer:@"scroll" withArgs:[self constructArgs]];
}

-(IBAction)performActionOnTouchUpInside:(id)sender
{
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:lastActionPerformed];
    
    if (difference > 0.2)
    {
        if (sender != allOffButton && sender != allOnButton && sender != stopButton)
        {
            [self runActionOnServer:@"stop" withArgs:@"newest/true"];
        }
        else if (sender == allOnButton)
        {
            [self runActionOnServer:@"allOff" withArgs:nil];
        }
        else if (sender == stopButton && difference > 0.5)
        {
            [self runActionOnServer:@"stop" withArgs:@"fast/true"];
        }
    }
}

-(IBAction)sliderChangedValue:(id)sender
{
    CGFloat curVal = powf([sleepSlider value], 2.0);
    NSString *labelVal = [NSString stringWithFormat:@"%1.2fs", curVal];
    [sleepLabel setText:labelVal];
}

-(void)runActionOnServer:(NSString *)action withArgs:(NSString *)args
{
    NSString *url = nil;
    
    if (args == nil)
        url = [NSString stringWithFormat:@"http://192.168.1.14:4567/c/%@", action];
    else
        url = [NSString stringWithFormat:@"http://192.168.1.14:4567/c/%@/%@", action, args];
    [self hitURL:url];
}

-(void)hitURL:(NSString *)url
{
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection autorelease];
}

@end
