//
//  SUUnderLayerView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridUnderLayerView.h"

@interface SUGridUnderLayerView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;


@end

@implementation SUGridUnderLayerView

- (id)initWithScreenshotImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // Init screenshotImageView
        self.screenshotImageView = [[UIImageView alloc] initWithImage:image];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.screenshotImageView];
        
        // Init grid view
        self.gridView = [[SUGridView alloc] init];
        self.gridView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.gridView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = [super bounds].size;
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    self.gridView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
        
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
        self.gridView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    }
}


@end
