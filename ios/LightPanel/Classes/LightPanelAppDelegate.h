//
//  LightPanelAppDelegate.h
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightPanelViewController;
@class ActionsPanelViewController;

@interface LightPanelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NSUserDefaults *defaults;
    
    LightPanelViewController *viewController;
    ActionsPanelViewController *actionPanelViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LightPanelViewController *viewController;
@property (nonatomic, retain) IBOutlet ActionsPanelViewController *actionPanelViewController;

-(NSUserDefaults *)getSettings;
-(void)showActionsPanel;
-(void)removeActionsPanel;

+(LightPanelAppDelegate*)instance;

@end

