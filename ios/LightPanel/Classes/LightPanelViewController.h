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
	NSError									*errorStream;
	CFReadStreamRef							writeStream;
	NSString								*serverAddress;
	int										serverPort;
}

@property (nonatomic, retain) IBOutlet TouchView *touchView;
@property (nonatomic, retain) NSString *serverAddress;
@property (nonatomic)			int		serverPort;

-(void)openSocket;
-(void)sendSocket:(NSString *)data;
-(void)handleTouchFromNotification:(NSNotification *)notification;
-(void)loadSettings;

@end

