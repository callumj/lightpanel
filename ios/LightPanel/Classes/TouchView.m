//
//  TouchView.m
//  LightPanel
//
//  Created by Callum Jones on 6/03/11.
//  Copyright 2011 mullac.org. All rights reserved.
//

#import "TouchView.h"


@implementation TouchView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
		[[NSNotificationCenter defaultCenter] postNotificationName:kTouchBeganForTouchView object:touch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
		[[NSNotificationCenter defaultCenter] postNotificationName:kTouchBeganForTouchView object:touch];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
		[[NSNotificationCenter defaultCenter] postNotificationName:kTouchBeganForTouchView object:touch];
}
@end
