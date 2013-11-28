//
//  SUErrorMarkingToolbar.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUToolbarView.h"
#import "SUCompositeButton.h"


@interface SUErrorMarkingToolbar : SUToolbarView

@property (nonatomic, strong) SUCompositeButton *addMarkingViewButton;
@property (nonatomic, strong) SUCompositeButton *sendMailButton;
@property (nonatomic, strong) SUCompositeButton *showMarkingViewToolbarButton;
@property (nonatomic, strong) SUCompositeButton *addTextMarkingViewButton;

@end
