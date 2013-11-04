//
//  SUViewController.m
//  ExampleCoolTool
//
//  Created by Alex Saenko on 11/1/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUViewController.h"
#import "SUCoolTool.h"

@interface SUViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SUViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	SUCoolTool *coolTool = [[SUCoolTool alloc] init];
    [coolTool createWindowForDebugWithImage:self.imageView.image];
}

@end
