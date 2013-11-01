//
//  SUViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUViewController.h"
#import "SUCoolTool.h"

@interface SUViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation SUViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    SUCoolTool *coolTool = [[SUCoolTool alloc] init];
    [coolTool createWindowForDebugWithImage:self.testImageView.image];
}

@end
