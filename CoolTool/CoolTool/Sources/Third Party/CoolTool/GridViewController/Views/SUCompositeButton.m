//
//  SUCompositeButton.m
//  Z360ShowMyAd
//
//  Created by Rostyslav Druzhchenko on 7/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompositeButton.h"

@interface SUCompositeButton ()

@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imagePressed;
@property (nonatomic, strong) UIImage *imageActivated;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end


@implementation SUCompositeButton

- (id)initWithImageNameNormal:(NSString *)imageNameNormal
             imageNamePressed:(NSString *)imageNamePressed
           imageNameActivated:(NSString *)imageNameActivated

{
    self = [super init];
    if (self) {
        self.imageNormal = [UIImage imageNamed:imageNameNormal];
        self.imagePressed = [UIImage imageNamed:imageNamePressed];
        self.imageActivated = [UIImage imageNamed:imageNameActivated];
        
        if (imageNameActivated == nil) {
            self.imageActivated = self.imageNormal;
        }

        // Init image view
        self.imageView = [[UIImageView alloc] initWithImage:self.imageNormal];
        [self addSubview:self.imageView];

        // Init button
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(onDown) forControlEvents:UIControlEventTouchDown];
        [self.button addTarget:self action:@selector(onUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:self.button];
        
        self.enabled = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.frame.size;
            
    self.imageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);

    // Layout button
    self.button.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
}

#pragma mark - Actions

- (void)onDown
{
//TODO: Uncomment when design will be provided
//    self.imageView.image = self.imagePressed;
}

- (void)onUp
{
    self.imageView.image = self.imageNormal;
}

- (void)onTouchUpInside
{
    if (self.target && self.action){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
    
    [self.button addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Propreties

- (void)setEnabled:(BOOL)newEnabled
{
    _enabled = newEnabled;
    if (self.enabled){
        self.state = SUCompositeButtonStateNormal;
    }
    else{
        self.state = SUCompositeButtonStateActivated;
    }
    
    self.userInteractionEnabled = self.enabled;
}

- (void)setState:(SUCompositeButtonState)state
{
    _state = state;
    
    if (state == SUCompositeButtonStateNormal) {
        self.imageView.image = self.imageNormal;
    }
    else if (state == SUCompositeButtonStateActivated) {
        self.imageView.image = self.imageActivated;
    }

}

@end
