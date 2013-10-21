//
//  SUMarkColorView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkColorView.h"
#import "SUColorView.h"
#import "SUConstants.h"

@interface SUMarkColorView ()

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *colorViews;
@property (nonatomic, strong) UIView *selectedColorView;

@end


@implementation SUMarkColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        
        // Init color views array
        self.colorViews = [[NSMutableArray alloc] init];
        
        // Init colors array
        self.colorArray = [NSArray arrayWithObjects:[UIColor redColor],
                                                    [UIColor blueColor],
                                                    [UIColor greenColor],
                                                    [UIColor grayColor],
                                                    [UIColor purpleColor],
                                                    [UIColor orangeColor],nil];
        
        // Init color views
        for (NSInteger i = 0; i < [self.colorArray count]; i++) {
            SUColorView *colorView = [[SUColorView alloc] initWithColor:[self.colorArray objectAtIndex:i]];
            colorView.frame = [self rectWithIndex:i];
            [colorView.colorViewButton addTarget:self action:@selector(colorViewDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:colorView];
            [self.colorViews addObject:colorView];
        }
        
        // Init selected color view
        self.selectedColorView = [[UIView alloc] init];
        self.selectedColorView.userInteractionEnabled = NO;
        self.selectedColorView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.3f];
        self.selectedColorView.frame = kSUColorViewRect;
        self.selectedColorView.center = ((SUColorView *)[self.colorViews objectAtIndex:0]).center;
        [self addSubview:self.selectedColorView];
        
    }
    
    return self;
}

- (void)colorViewDidPress:(UIButton *)colorViewButton
{
    [UIView animateWithDuration:0.1f animations:^{
        self.selectedColorView.center = ((SUColorView *)colorViewButton.superview).center;
    }];
    [self.delegate colorViewPickedWithColor:((SUColorView *)colorViewButton.superview).smallColorView.backgroundColor];
}

- (CGRect)rectWithIndex:(NSInteger)index
{
    CGRect tempRect = kSUColorViewRect;
    
    tempRect.origin.y = (tempRect.origin.y + tempRect.size.width) * index;
    
    return tempRect;
}

@end
