//
//  ViewController.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController+GameControls.h"

#import "VideoSource.h"
#import "PatternDetector.h"

#import "UIView+Animations.h"
#import "UIImage+OpenCV.h"
#import "ARView.h"

#pragma mark -
#pragma mark ViewController Class Extension
@interface ViewController () <VideoSourceDelegate>
{
    SystemSoundID m_soundExplosion;
    SystemSoundID m_soundShoot;
    SystemSoundID m_soundTracking;
    
    PatternDetector * m_detector;
    NSTimer * m_trackingTimer;
    NSTimer * m_sampleTimer;
    
    CameraCalibration m_calibration;
    CGFloat m_targetViewWidth;
    CGFloat m_targetViewHeight;
}

// Data Properties
@property (nonatomic, strong) VideoSource * videoSource;

// Transition Closures
@property (nonatomic, copy) void (^transitioningTrackerComplete)(void);
@property (nonatomic, copy) void (^transitioningTrackerCompleteResetScore)(void);

// Visualization Layer
@property (nonatomic, strong) ARView * arView;

@end

#pragma mark -
#pragma mark ViewController Implementation
@implementation ViewController

#pragma mark -
#pragma mark Accessors
- (void)setScore:(NSInteger)score {
    _score = score;
    [self.scoreValueLabel setText:[NSNumberFormatter localizedStringFromNumber:@(score) numberStyle:NSNumberFormatterDecimalStyle]];
}

#pragma mark -
#pragma mark Object Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure Video Source
    self.videoSource = [[VideoSource alloc] init];
    self.videoSource.delegate = self;
    [self.videoSource startWithDevicePosition:AVCaptureDevicePositionBack];
}

// Supporting iOS5
- (void)viewDidUnload
{
    self.backgroundImageView = nil;
    self.crosshairs = nil;
    
    self.tutorialPanel = nil;
    self.tutorialInnerPanel = nil;
    self.tutorialLabel = nil;
    self.tutorialDescLabel = nil;
    
    self.scorePanel = nil;
    self.scoreInnerPanel = nil;
    self.scoreValueLabel = nil;
    self.scoreHeaderLabel = nil;
    
    self.triggerPanel = nil;
    self.triggerLabel = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)pressTrigger:(id)sender {
    // TODO: Add code here
    NSLog(@"Fire!");
}

- (IBAction)pressSample:(id)sender {
    if ( ![self isSamplePanelVisible] && !self.transitioningSample ) {
        self.transitioningSample = YES;
        
        // Clear the UI
        [self updateSample:nil];
        
        // Clear the timer
        if ( m_sampleTimer != nil ) {
            [m_sampleTimer invalidate];
            m_sampleTimer = nil;
        }
        
        // Start the timer
        m_sampleTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/20.0f)
                                                         target:self
                                                       selector:@selector(updateSample:)
                                                       userInfo:nil
                                                        repeats:YES];
        
        __weak typeof(self) _weakSelf = self;
        [self.samplePanel popIn:^{
            _weakSelf.transitioningSample = NO;
        }];
    }
}

- (IBAction)pressSampleClose:(id)sender {
    if ( [self isSamplePanelVisible] && !self.transitioningSample ) {
        self.transitioningSample = YES;
        
        // Terminate the timer
        [m_sampleTimer invalidate];
        m_sampleTimer = nil;
        
        __weak typeof(self) _weakSelf = self;
        [self.samplePanel popOut:^{
            _weakSelf.transitioningSample = NO;
        }];
    }
}

#pragma mark -
#pragma mark View State Methods
- (BOOL)isTutorialPanelVisible {
    return (self.tutorialPanel.alpha == 1.0f);
}

- (BOOL)isSamplePanelVisible {
    return (self.samplePanel.alpha == 1.0f);
}

#pragma mark -
#pragma mark Audio Support
- (void)loadSounds {
    CFURLRef soundURL1 = (__bridge CFURLRef)[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"powerup" ofType:@"caf"]];
    CFURLRef soundURL2 = (__bridge CFURLRef)[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"laser" ofType:@"caf"]];
    CFURLRef soundURL3 = (__bridge CFURLRef)[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"caf"]];
    
    AudioServicesCreateSystemSoundID(soundURL1, &m_soundTracking);
    AudioServicesCreateSystemSoundID(soundURL2, &m_soundShoot);
    AudioServicesCreateSystemSoundID(soundURL3, &m_soundExplosion);
}

#pragma mark -
#pragma mark Game Play
- (void)hitTargetWithPoints:(NSInteger)points {
    // TODO: Add code here
}

- (void)missTarget {
    // TODO: Add code here
}

#pragma mark -
#pragma mark Tracking Methods
- (void)updateTracking:(NSTimer*)timer {
    // TODO: Add code here
}

- (void)updateSample:(NSTimer*)timer {
    // TODO: Add code here
}

- (void)togglePanels {
    // TODO: Add code here
}

#pragma mark -
#pragma mark VideoSource Delegate
- (void)frameReady:(VideoFrame)frame {
    __weak typeof(self) _weakSelf = self;
    dispatch_sync( dispatch_get_main_queue(), ^{
        // (1) Construct CGContextRef from VideoFrame
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(frame.data,
                                                        frame.width,
                                                        frame.height,
                                                        8,
                                                        frame.stride,
                                                        colorSpace,
                                                        kCGBitmapByteOrder32Little |
                                                        kCGImageAlphaPremultipliedFirst);
        
        // (2) Construct CGImageRef from CGContextRef
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        // (3) Construct UIImage from CGImageRef
        UIImage * image = [UIImage imageWithCGImage:newImage];
        CGImageRelease(newImage);
        [[_weakSelf backgroundImageView] setImage:image];
    });
}

@end
