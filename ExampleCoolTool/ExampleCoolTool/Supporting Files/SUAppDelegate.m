//
//  SUAppDelegate.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUAppDelegate.h"
#import "SUCoolTool.h"

@implementation SUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup CoolTool
    [SUCoolTool setup];
    return YES;
}

@end
