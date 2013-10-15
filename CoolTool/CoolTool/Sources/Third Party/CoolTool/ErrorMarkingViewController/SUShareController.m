//
//  SUShareController.m
//  CoolTool
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUShareController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SUScreenshotUtil.h"

@interface SUShareController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *screenshotSound;
@property (nonatomic, strong) SUErrorMarkingToolbar *toolbar;
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation SUShareController

- (id)initWithToolbar:(SUErrorMarkingToolbar *)toolbar onViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.toolbar = toolbar;
        self.viewController = viewController;
        [self.toolbar.sendMailButton.button addTarget:self action:@selector(sendScreenshotViaMail)
                                           forControlEvents:UIControlEventTouchUpInside];
        [self createScreenshotSound];
    }
    return self;
}

- (void)sendScreenshotViaMail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;

        [mailComposeViewController setSubject:NSLocalizedStringFromTable(@"MAIL_SUBJECT", @"CoolTool", nil)];
        [self.toolbar setHidden:YES];
        [self.screenshotSound play];
        [self showBlinkingViewWithCompletionBlock:^(void) {
            UIImage *imageToSend = [SUScreenshotUtil convertViewToImage:self.viewController.view];
            NSData *imageData = UIImageJPEGRepresentation(imageToSend, 1.0f);
            [mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Bug-image.png"];
            NSString *emailBody = NSLocalizedStringFromTable(@"MAIL_BODY", @"CoolTool", nil);
            [mailComposeViewController setMessageBody:emailBody isHTML:NO];

            [self.viewController presentViewController:mailComposeViewController animated:YES completion:^{
                [self.toolbar setHidden:NO];
            }];
        }];
    }
    else {
        [self showErrorAlertView];
    }
}

- (void)createScreenshotSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter" ofType:@"mp3"];
    self.screenshotSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
}

- (void)showBlinkingViewWithCompletionBlock:(void (^)())completionBlock
{
    UIViewController *viewController;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    [UIView animateWithDuration:1.0f animations:^{
        [self.viewController.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        completionBlock(viewController);
    }];
}

- (void)showErrorAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_TITLE", @"CoolTool", nil)
                              message:NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_MESSAGE", @"CoolTool", nil)
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch(result)
    {
        case MFMailComposeResultFailed:
            [self showErrorAlertView];
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
