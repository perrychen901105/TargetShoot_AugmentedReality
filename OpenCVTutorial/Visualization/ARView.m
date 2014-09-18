//
//  ARView.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/18/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ARView.h"

#import "AppDelegate.h"

#define kDRAW_TARGET_DRAW_RINGS     1
#define kDRAW_TARGET_BULLET_HOLES   1

#define kColorBackground [UIColor darkGrayColor]

#define kColorBulletHole [UIColor greenColor]

#define kColorRing1 [UIColor blueColor]
#define kColorRing2 [UIColor greenColor]
#define kColorRing3 [UIColor yellowColor]
#define kColorRing4 [UIColor orangeColor]
#define kColorRing5 [UIColor redColor]

static const CGFloat kRadius5 = 18.0f;
static const CGFloat kRadius4 = 30.0f;
static const CGFloat kRadius3 = 45.0f;
static const CGFloat kRadius2 = 58.0f;
static const CGFloat kRadius1 = 73.0f;

static const CGFloat kAlphaShow = 0.5f;
static const CGFloat kAlphaHide = 0.0f;

#pragma mark -
#pragma mark Inline Helper Functions
static inline CGFloat distance(CGPoint a, CGPoint b, struct CameraCalibration calibration) {
    CGFloat dx = (b.x - a.x) / calibration.xDistortion;
    CGFloat dy = (b.y - a.y) / calibration.yDistortion;
    return sqrt(dx * dx + dy * dy);
}

static inline void drawTargetCircle(CGPoint center,
                                    UIColor * color,
                                    CGFloat radius,
                                    struct CameraCalibration calibration) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat xF = calibration.xDistortion;
    CGFloat yF = calibration.yDistortion;
    CGFloat factor = IS_IPHONE_5() ? (568.0f/480.0f) : 1.0f;
    const CGFloat * comps = CGColorGetComponents(color.CGColor);
    CGContextSetRGBFillColor(context, comps[0], comps[1], comps[2], comps[3]);
    CGRect circle1 = CGRectMake(center.x - (radius*factor) / (yF*2.0f),
                                center.y - (radius*factor) / (xF*2.0f),
                                (radius*factor) / (yF),
                                (radius*factor) / (xF));
    CGContextFillEllipseInRect(context, circle1);
}

#pragma mark -
#pragma mark ARView Class Extension
@interface ARView ()
{
    struct CameraCalibration m_calibration;
    CGSize    m_size;
    CGPoint   m_center;
}

@property (nonatomic, strong) NSMutableSet * hits;

@property (nonatomic, assign) NSInteger ringNumber;

@end

#pragma mark -
#pragma mark ARView Implementation
@implementation ARView

#pragma mark -
#pragma mark Constructors
- (id)initWithSize:(CGSize)size calibration:(struct CameraCalibration)calibration {
    // Must do math first
    m_calibration = calibration;
    m_size = CGSizeMake(size.width * calibration.xDistortion,
                        size.height * calibration.yDistortion);
    
    // Now construct object
    self = [super initWithFrame:CGRectMake(0, 0, m_size.width, m_size.height)];
    if ( self ) {
        m_center = CGPointMake(self.frame.size.width / 2.0f,
                               self.frame.size.height / 2.0f);
        
        self.hits = [[NSMutableSet alloc] init];
        self.backgroundColor = kColorBackground;
        
        // Change this line to change which ring is highlighted
        self.ringNumber = 1;
    }
    return self;
}

#if kDRAW_TARGET_DRAW_RINGS
- (void)drawRect:(CGRect)rect {
    switch ( self.ringNumber ) {
        case 1:
            drawTargetCircle(self.center, kColorRing1, kRadius1, m_calibration);
            break;
        case 2:
            drawTargetCircle(self.center, kColorRing2, kRadius2, m_calibration);
            break;
        case 3:
            drawTargetCircle(self.center, kColorRing3, kRadius3, m_calibration);
            break;
        case 4:
            drawTargetCircle(self.center, kColorRing4, kRadius4, m_calibration);
            break;
        case 5:
            drawTargetCircle(self.center, kColorRing5, kRadius5, m_calibration);
            break;
    }
}
#endif

#pragma mark -
#pragma mark Gameplay
- (int)selectBestRing:(CGPoint)point {
    int bestRing = 0;
    
    // TODO: Add code here
    
    return bestRing;
}

#pragma mark -
#pragma mark Display Controls
- (void)show {
    // TODO: Add code here
}

- (void)hide {
    // TODO: Add code here
}

@end
