//
//  ActionsPanelViewController.h
//  LightPanel
//
//  Created by Callum Jones on 22/04/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightPanelAppDelegate.h"


@interface ActionsPanelViewController : UIViewController {
    NSString *webServerHost;
    int webServerPort;
    NSDate *lastActionPerformed;
    
    IBOutlet UIButton *switchBackButton;
    IBOutlet UISlider *sleepSlider;
    IBOutlet UILabel *sleepLabel;
    
    //action buttons
    IBOutlet UIButton *strobeButton;
    IBOutlet UIButton *snakeButton;
    IBOutlet UIButton *dotsButton;
    IBOutlet UIButton *fadeButton;
    IBOutlet UIButton *scrollButton;
    
    IBOutlet UIButton *allOffButton;
    IBOutlet UIButton *allOnButton;
    IBOutlet UIButton *stopButton;
}

@property (nonatomic, retain) IBOutlet UIButton *strobeButton;
@property (nonatomic, retain) IBOutlet UIButton *snakeButton;
@property (nonatomic, retain) IBOutlet UIButton *dotsButton;
@property (nonatomic, retain) IBOutlet UIButton *fadeButton;
@property (nonatomic, retain) IBOutlet UIButton *scrollButton;

@property (nonatomic, retain) IBOutlet UIButton *allOffButton;
@property (nonatomic, retain) IBOutlet UIButton *allOnButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

@property (nonatomic, retain) IBOutlet UIButton *switchBackButton;

@property (nonatomic, retain) IBOutlet UISlider *sleepSlider;
@property (nonatomic, retain) IBOutlet UILabel *sleepLabel;

-(IBAction)switchBackToTouchView:(id)sender;
-(IBAction)performActionOnTouchDown:(id)sender;
-(IBAction)performActionOnTouchUpInside:(id)sender;
-(IBAction)sliderChangedValue:(id)sender;

-(NSString *)constructArgs;
-(void)runActionOnServer:(NSString *)action withArgs:(NSString *)args;
-(void)hitURL:(NSString *)url;

@end
