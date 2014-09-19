//
//  ViewController.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

static const NSUInteger kPOINTS_1 = 50;
static const NSUInteger kPOINTS_2 = 100;
static const NSUInteger kPOINTS_3 = 250;
static const NSUInteger kPOINTS_4 = 500;
static const NSUInteger kPOINTS_5 = 1000;

@interface ViewController : UIViewController

#pragma mark -
#pragma mark IBOutlet Properties
// (IBOutlets are listed in header so that we can use them in the category)
@property (nonatomic, weak) IBOutlet UIImageView * backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView * crosshairs;

@property (nonatomic, weak) IBOutlet UIView      * tutorialPanel;
@property (nonatomic, weak) IBOutlet UIImageView * tutorialInnerPanel;
@property (nonatomic, weak) IBOutlet UILabel     * tutorialLabel;
@property (nonatomic, weak) IBOutlet UILabel     * tutorialDescLabel;

@property (nonatomic, weak) IBOutlet UIView      * scorePanel;
@property (nonatomic, weak) IBOutlet UIImageView * scoreInnerPanel;
@property (nonatomic, weak) IBOutlet UILabel     * scoreValueLabel;
@property (nonatomic, weak) IBOutlet UILabel     * scoreHeaderLabel;

@property (nonatomic, weak) IBOutlet UIView      * triggerPanel;
@property (nonatomic, weak) IBOutlet UILabel     * triggerLabel;

@property (nonatomic, weak) IBOutlet UIView      * sampleButtonPanel;
@property (nonatomic, weak) IBOutlet UILabel     * sampleButtonLabel;

@property (nonatomic, weak) IBOutlet UIView      * samplePanel;
@property (nonatomic, weak) IBOutlet UIView      * samplePanelInner;
@property (nonatomic, weak) IBOutlet UIImageView * sampleView;
@property (nonatomic, weak) IBOutlet UILabel     * sampleLabel1;
@property (nonatomic, weak) IBOutlet UILabel     * sampleLabel2;

#pragma mark -
#pragma mark Additional Properties
// (Additional properties required by the category)
@property (nonatomic, strong) UIFont * fontLarge;
@property (nonatomic, strong) UIFont * fontSmall;

@property (nonatomic, assign) BOOL transitioningTracker;
@property (nonatomic, assign) BOOL transitioningSample;

@property (nonatomic, assign) NSInteger score;

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)pressTrigger:(id)sender;
- (IBAction)pressSample:(id)sender;
- (IBAction)pressSampleClose:(id)sender;

#pragma mark -
#pragma mark Audio Support
- (void)loadSounds;

@end
