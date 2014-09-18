//
//  ViewController+GameControls.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

#import "ViewController+GameControls.h"

#import "UIView+Animations.h"

#import "SpriteLayer.h"

static const CGFloat kCornerRadius = 10.0f;
static const CGFloat kDurationFade = 1.25f;

@implementation ViewController (GameControls)

#pragma mark -
#pragma mark Game Controls;
- (void)loadGameControls {
    // Configure the fonts
    self.fontLarge = [UIFont fontWithName:@"GROBOLD" size:18.0f];
    self.fontSmall = [UIFont fontWithName:@"GROBOLD" size:14.0f];
    
    // Turn on the game controls
    self.crosshairs.hidden = NO;
    self.tutorialPanel.hidden = NO;
    self.scorePanel.hidden = NO;
    self.triggerPanel.hidden = NO;
    
    // Customize the views
    [self.tutorialInnerPanel.layer setCornerRadius:kCornerRadius];
    [self.tutorialInnerPanel setClipsToBounds:YES];
    [self.tutorialInnerPanel setBackgroundColor:[UIColor clearColor]];
    [self.tutorialLabel setFont:self.fontLarge];
    [self.tutorialDescLabel setFont:self.fontSmall];
    
    [self.scoreInnerPanel.layer setCornerRadius:kCornerRadius];
    [self.scoreInnerPanel setClipsToBounds:YES];
    [self.scoreInnerPanel setBackgroundColor:[UIColor clearColor]];
    [self.scoreValueLabel setFont:self.fontLarge];
    [self.scoreHeaderLabel setFont:self.fontLarge];
    
    [self.triggerLabel setFont:self.fontLarge];
    
    [self.sampleButtonLabel setFont:self.fontLarge];
    [self.samplePanelInner.layer setCornerRadius:kCornerRadius];
    [self.samplePanelInner setClipsToBounds:YES];
    [self.samplePanelInner setBackgroundColor:[UIColor clearColor]];
    [self.sampleLabel1 setFont:[UIFont systemFontOfSize:11.0f]];
    [self.sampleLabel2 setFont:[UIFont systemFontOfSize:11.0f]];
    
    self.sampleView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.sampleView.layer.borderWidth = 1.0f;
    self.sampleView.layer.cornerRadius = 4.0f;
    self.sampleView.clipsToBounds = YES;
    
    // Configure sounds
    [self loadSounds];
    
    // Configure state
    [self setScore:0];
    
    // View states are not transitioning
    self.transitioningTracker = NO;
    self.transitioningSample = NO;
    
    // Configure the Tracking Helper (if required)
#if kUSE_TRACKING_HELPER
    self.samplePanel.hidden = NO;
    self.sampleButtonPanel.hidden = NO;
    
    [self.samplePanel setAlpha:0.0f];
#endif
}

#pragma mark -
#pragma mark Game Play
- (NSInteger)selectRandomRing {
    // Simulate a 50% chance of hitting the target
    NSInteger randomNumber1 = arc4random() % 100;
    if ( randomNumber1 < 50 ) {
        // Stagger the 5 simulations linearly
        NSInteger randomNumber2 = arc4random() % 100;
        if ( randomNumber2 < 20 ) {
            return 1; /* outer most ring */
        } else if ( randomNumber2 < 40 ) {
            return 2;
        } else if ( randomNumber2 < 60 ) {
            return 3;
        } else if ( randomNumber2 < 80 ) {
            return 4;
        } else {
            return 5; /* bullseye */
        }
    } else {
        return 0;
    }
}

- (void)showFloatingScore:(NSInteger)points {
    // Configure the label
    CGRect r1 = [[UIScreen mainScreen] bounds];
    CGFloat w1 = r1.size.width;
    CGFloat h1 = r1.size.height;
    CGFloat xMargin = 5.0f;
    CGFloat yMargin = -40.0f;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(h1/2.0 + xMargin, w1/2.0 + yMargin, 60, 30)]; /* Flip-flop because in landscape */
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor orangeColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, -1);
    label.font = [UIFont fontWithName:@"GROBOLD" size:18.0f];
    label.text = [NSNumberFormatter localizedStringFromNumber:@(points) numberStyle:NSNumberFormatterDecimalStyle];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    // Animate the fade and motion upwards
    CGRect startFrame = label.frame;
    __weak UILabel* _weakLabel = label;
    [UIView animateWithDuration:kDurationFade
                     animations:^(void) {
                         CGFloat offset = +50.0f;
                         [_weakLabel setAlpha:0.0f];
                         [_weakLabel setFrame:CGRectMake(startFrame.origin.x,
                                                         startFrame.origin.y - offset,
                                                         startFrame.size.width,
                                                         startFrame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_weakLabel removeFromSuperview];
                     }];
}

- (void)showExplosion {
    // TODO: Add code here
}

@end