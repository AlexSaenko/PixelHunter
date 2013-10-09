//
//  SUCoolTool.m
//  CoolTool
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCoolTool.h"
#import "SUGridViewController.h"
#import "SUScreenshotUtil.h"
#import "SUCompareViewController.h"

typedef enum DebuggerType {
    kSUGridType,
    kSUMockupType
} DebuggerType;

static BOOL L0AccelerationIsShaking(UIAcceleration *last, UIAcceleration *current, double threshold) {
	double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
	return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

@interface SUCoolTool () <UIAccelerometerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SUGridViewControllerDelegate, SUCompareViewControllerDelegate>
{
    BOOL histeresisExcited;
}

@property (nonatomic, strong) UIAcceleration *lastAcceleration;
@property (nonatomic, weak) UIAlertView *alertView;
@property (nonatomic, strong) UIWindow *debugWindow;
@property (nonatomic, strong) UIWindow *parentWindow;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation SUCoolTool 

#pragma mark Singleton stuff

static id __sharedInstance;

+ (SUCoolTool *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[SUCoolTool alloc] init];
        [UIAccelerometer sharedAccelerometer].delegate = __sharedInstance;
        [[NSNotificationCenter defaultCenter] addObserver:__sharedInstance
                                                 selector:@selector(orientationChanged:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
    });
    return __sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = nil;
        __sharedInstance = [super allocWithZone:zone];
    });
	
    return __sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Public init

+ (void)setup
{
    [SUCoolTool sharedInstance];
}

#pragma mark - Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (self.lastAcceleration) {
		if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
			histeresisExcited = YES;
            if (self.alertView == nil && self.debugWindow == nil && self.imagePicker == nil) {
                [self showAlert];
            }
		} else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			histeresisExcited = NO;
		}
	}
    
	self.lastAcceleration = acceleration;
}

- (void)showAlert

{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"CHOOSE_INSTRUMENT", @"Choose instrument")
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                              otherButtonTitles:NSLocalizedString(@"GRID", @"Grid"),
                              NSLocalizedString(@"GALLERY", @"Gallery"),
                              nil];
    
    
    [alertView show];
    self.alertView = alertView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            
        }
            break;
            
        case 1: {
            // Create grid
            [self createWindowForDebugWithImage:[SUScreenshotUtil convertViewToImage:
                                                 [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] view]]];
        }
            break;
            
            // Show Image Picker
        case 2: {
            [alertView dismissWithClickedButtonIndex:2 animated:NO];
            [self showImagePicker];
        }
            break;
            
        default:
            break;
    }
}

- (void)createWindowForDebugWithImage:(UIImage *)image
{
    self.parentWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.debugWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SUGridViewController *viewController = [[SUGridViewController alloc] initWithScreenshotImage:image];
    viewController.delegate = self;
    self.debugWindow.rootViewController = viewController;
    self.parentWindow.hidden = YES;
    [self.debugWindow makeKeyAndVisible];
}

- (void)showImagePicker
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)removeWindowForDebug
{
    self.parentWindow.hidden = NO;
    self.debugWindow = nil;
}

#pragma mark - Orientation handling
- (void)orientationChanged:(NSNotification *)notification
{
    [self.debugWindow.rootViewController.view setNeedsLayout];
    [((SUGridViewController *)self.debugWindow.rootViewController).gridRootView layoutViewsDependingOnOrientation];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
    self.parentWindow = [[UIApplication sharedApplication] keyWindow];
    self.debugWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SUCompareViewController *viewController = [[SUCompareViewController alloc] initWithScreenshotImage:[SUScreenshotUtil convertViewToImage:
                                                                                                        [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] view]] withMockupImage:image];
    viewController.delegate = self;
    self.debugWindow.rootViewController = viewController;
    self.parentWindow.hidden = YES;
    [self.debugWindow makeKeyAndVisible];
}

- (void)tapOnCloseButton
{
    [self removeWindowForDebug];
}

@end
