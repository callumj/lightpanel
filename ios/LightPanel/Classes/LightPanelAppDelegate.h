//
//  LightPanelAppDelegate.h
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightPanelViewController;

@interface LightPanelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LightPanelViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LightPanelViewController *viewController;

@end

