//
//  SUUnderLayerView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridUnderLayerView.h"
#import "SUConstants.h"

@interface SUGridUnderLayerView ()

@end

@implementation SUGridUnderLayerView

- (id)initWithFrame:(CGRect)rect withScreenshotImage:(UIImage *)image
{
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // Init scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        [self addSubview:self.scrollView];
        
        // Init container view
        self.containerView = [[UIView alloc] initWithFrame:rect];
        [self.scrollView addSubview:self.containerView];
        
        // Init screenshotImageView
        self.screenshotImageView = [[UIImageView alloc] initWithImage:image];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.screenshotImageView];
        
        // Init grid view
        self.gridView = [[SUGridView alloc] init];
        self.gridView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.gridView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize sz = [super bounds].size;
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    self.containerView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    self.gridView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
}


@end
