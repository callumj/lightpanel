//
//  LightPanelViewController.h
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"
#import "LightPanelAppDelegate.h"

@interface LightPanelViewController : UIViewController {

	IBOutlet TouchView						*touchView;
	IBOutlet UIButton						*modeSelector;
	
	NSError									*errorStream;
	CFReadStreamRef							writeStream;
	NSString								*serverAddress;
	int										serverPort;
	BOOL									penMode;
}

@property (nonatomic, retain) IBOutlet TouchView *touchView;
@property (nonatomic, retain) IBOutlet UIButton *modeSelector;

@property (nonatomic, retain) NSString *serverAddress;
@property (nonatomic)			int		serverPort;
@property (nonatomic)			BOOL	penMode;

-(void)openSocket;
-(void)sendSocket:(NSString *)data;
-(void)handleTouchFromNotification:(NSNotification *)notification;
-(void)loadSettings;
-(IBAction)switchPen:(id)sender;
-(void)syncModeWithUI;

@end

