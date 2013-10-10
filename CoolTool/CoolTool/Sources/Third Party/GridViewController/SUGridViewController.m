//
//  SUGridViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridViewController.h"
#import "SUCoolTool.h"
#import "SUConstants.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SUScreenshotUtil.h"

@interface SUGridViewController () <SUGridViewControllerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) AVAudioPlayer *screenshotSound;

@end

@implementation SUGridViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
	self = [super init];
	if (self) {
		self.screenshotImage = screenshotImage;
        [self createScreenshotSound];
	}
    
	return self;
}

#pragma mark - Viewcontroller's life cycle

- (void)loadView
{
    CGSize sz = [[UIScreen mainScreen] applicationFrame].size;
    SUGridRootView *view = [[SUGridRootView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sz.width, sz.height) withScreenshotImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.gridRootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.gridRootView.toolbar.closeButton addTarget:self
                                              action:@selector(tapOnCloseButton)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self.gridRootView.toolbar.showPickerButton addTarget:self
                                                   action:@selector(showImagePicker)];
    [self.gridRootView.toolbar.sendMailButton addTarget:self
                                                 action:@selector(sendScreenshotViaMail)];
    [self.gridRootView.toolbar.slider addTarget:self
                                        action:@selector(changeMockupImageAlpha:)
                              forControlEvents:UIControlEventValueChanged];
    
    self.gridRootView.gridUnderLayerView.scrollView.delegate = self;
    self.gridRootView.gridUnderLayerView.scrollView.contentSize = self.gridRootView.gridUnderLayerView.containerView.frame.size;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale = self.gridRootView.gridUnderLayerView.scrollView.frame.size.width / self.gridRootView.gridUnderLayerView.containerView.frame.size.width;
    self.gridRootView.gridUnderLayerView.scrollView.maximumZoomScale = kSUMaximumZoomScale;
    [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridRootView.gridUnderLayerView.containerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeRulerPositions];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.gridRootView.gridUnderLayerView.containerView.frame = [self centeredFrameForScrollView:scrollView andView:self.gridRootView.gridUnderLayerView.containerView];
    [self changeRulerPositions];
    if (self.gridRootView.gridUnderLayerView.scrollView.zoomScale == kSUMaximumZoomScale) {
        self.gridRootView.smallGridView.hidden = NO;
    } else {
        self.gridRootView.smallGridView.hidden = YES;
    }
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andView:(UIView *)view
{
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = view.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

- (void)changeRulerPositions
{    
    self.gridRootView.topRuler.frame = CGRectMake(-self.gridRootView.gridUnderLayerView.scrollView.contentOffset.x, 0.0f,
                                                  self.gridRootView.gridUnderLayerView.scrollView.contentSize.width , kSURulerSize);
    self.gridRootView.sideRuler.frame = CGRectMake(0.0f, -self.gridRootView.gridUnderLayerView.scrollView.contentOffset.y,
                                                   kSURulerSize, self.gridRootView.gridUnderLayerView.scrollView.contentSize.height);

    self.gridRootView.smallGridView.startVerticalPoint = (NSInteger) self.gridRootView.topRuler.frame.origin.x % 40;
    self.gridRootView.smallGridView.startHorizontalPoint = (NSInteger) self.gridRootView.sideRuler.frame.origin.y % 40;
    [self.gridRootView.smallGridView setNeedsDisplay];
}

- (void)changeMockupImageAlpha:(UISlider *)sender
{
    self.gridRootView.gridUnderLayerView.mockupImageView.alpha = sender.value;
}

- (void)showImagePicker
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
    }];
}

#pragma mark E-mail message
- (void)createScreenshotSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter" ofType:@"mp3"];
    self.screenshotSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
}

- (void)sendScreenshotViaMail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        
        [mailComposeViewController setSubject:NSLocalizedString(@"MAIL_SUBJECT", nil)];
        [self.gridRootView.toolbar setHidden:YES];
        [self.screenshotSound play];
        [self showBlinkingViewWithCompletionBlock:^(void) {
            UIImage *imageToSend = [SUScreenshotUtil convertViewToImage:self.view];
            NSData *imageData = UIImageJPEGRepresentation(imageToSend, 1.0f);
            [mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Bug-image.png"];
            NSString *emailBody = NSLocalizedString(@"MAIL_BODY", nil);
            [mailComposeViewController setMessageBody:emailBody isHTML:NO];
            
            [self presentViewController:mailComposeViewController animated:YES completion:^{
                [self.gridRootView.toolbar setHidden:NO];
            }];
        }];
    }
    else {
        [self showErrorAlertView];
    }
}

- (void)showBlinkingViewWithCompletionBlock:(void (^)())completionBlock
{
    UIViewController *viewController;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.gridRootView.frame.size.width, self.gridRootView.frame.size.height)];
    [UIView animateWithDuration:1.0f animations:^{
        [self.gridRootView addSubview:view];
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
                              initWithTitle:NSLocalizedString(@"ERROR_ALERT_VIEW_TITLE", nil)
                              message:NSLocalizedString(@"ERROR_ALERT_VIEW_MESSAGE", nil)
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.gridRootView.gridUnderLayerView.mockupImageView.image = image;
    self.gridRootView.toolbar.slider.enabled = YES;
}

#pragma mark - Delegate

- (void)tapOnCloseButton
{
    [self.delegate tapOnCloseButton];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
