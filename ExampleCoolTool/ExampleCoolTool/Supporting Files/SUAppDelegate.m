//
//  SUAppDelegate.m
//  ExampleCoolTool
//
//  Created by Alex Saenko on 11/1/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUAppDelegate.h"

@implementation SUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SUCoolTool setup];
    
    return YES;
}

@end
