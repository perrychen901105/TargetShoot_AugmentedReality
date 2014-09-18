//
//  UIView+Animations.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "UIView+Animations.h"

#import "AccelerationAnimation.h"
#import "Evaluate.h"

static const NSString * kAnimationLabel                       = @"kAnimationLabel";
static const NSString * kAnimationCompletionBlock             = @"kAnimationCompletionBlock";
static const NSString * kAnimationDirectionFromTopInLabel     = @"kAnimationDirectionFromTopIn";
static const NSString * kAnimationDirectionFromTopOutLabel    = @"kAnimationDirectionFromTopOut";
static const NSString * kAnimationDirectionFromBottomInLabel  = @"kAnimationDirectionFromBottomIn";
static const NSString * kAnimationDirectionFromBottomOutLabel = @"kAnimationDirectionFromBottomOut";
static const NSString * kAnimationPopIn                       = @"kAnimationPopIn";
static const NSString * kAnimationPopOut                      = @"kAnimationPopOut";
static const CGFloat kAnimationDurationSlideIn      = 1.50f;
static const CGFloat kAnimationDurationSlideOut     = 0.75f;
static const CGFloat kAnimationDurationPop          = 0.70f;
static const NSUInteger kAnimationInterstitialSteps = 99;

@implementation UIView (Animations)

#pragma mark -
#pragma mark External Interface
- (void)slideIn:(kAnimationDirection)fromDirection completion:(void (^)(void))completion {
    self.alpha = 1.0f;
    
    CGFloat endY = self.center.y;
    CGFloat startY;
    switch ( fromDirection ) {
        case kAnimationDirectionFromTop:
            startY = self.center.y - self.frame.size.height;
            break;
        case kAnimationDirectionFromBottom:
            startY = self.center.y + self.frame.size.height;
            break;
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:kAnimationDurationSlideIn] forKey:kCATransactionAnimationDuration];
    [[self layer] setPosition:CGPointMake(self.center.x, endY)];
    
    AccelerationAnimation * animation = [AccelerationAnimation animationWithKeyPath:@"position.y"
                                                                         startValue:startY
                                                                           endValue:endY
                                                                   evaluationObject:[[SecondOrderResponseEvaluator alloc] initWithOmega:20.0 zeta:0.33]
                                                                  interstitialSteps:kAnimationInterstitialSteps];
    [animation setDelegate:self];
    [animation setValue:completion forKey:(NSString*)kAnimationCompletionBlock];
    [[self layer] setValue:[NSNumber numberWithDouble:endY] forKey:@"position.y"];
    switch ( fromDirection ) {
        case kAnimationDirectionFromTop:
            [animation setValue:kAnimationDirectionFromTopInLabel forKey:(NSString*)kAnimationLabel];
            break;
        case kAnimationDirectionFromBottom:
            [animation setValue:kAnimationDirectionFromBottomInLabel forKey:(NSString*)kAnimationLabel];
            break;
    }
    [[self layer] addAnimation:animation forKey:@"position"];
    [CATransaction commit];
    
    [self setNeedsDisplay];
}

- (void)slideOut:(kAnimationDirection)fromDirection completion:(void (^)(void))completion {
    CGFloat startY = self.center.y;
    CGFloat endY;
    switch ( fromDirection ) {
        case kAnimationDirectionFromTop:
            endY = self.center.y - self.frame.size.height;
            break;
        case kAnimationDirectionFromBottom:
            endY = self.center.y + self.frame.size.height;
            break;
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:kAnimationDurationSlideOut] forKey:kCATransactionAnimationDuration];
    [[self layer] setPosition:CGPointMake(self.center.x, endY)];
    
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:@"position.y"
                                                                        startValue:startY
                                                                          endValue:endY
                                                                  evaluationObject:[[ReverseQuadraticEvaluator alloc] initWithA:9.0f b:0.35f]
                                                                 interstitialSteps:kAnimationInterstitialSteps];
    [animation setDelegate:self];
    [animation setValue:completion forKey:(NSString*)kAnimationCompletionBlock];
    [[self layer] setValue:[NSNumber numberWithDouble:endY] forKey:@"position.y"];
    switch ( fromDirection ) {
        case kAnimationDirectionFromTop:
            [animation setValue:kAnimationDirectionFromTopOutLabel forKey:(NSString*)kAnimationLabel];
            break;
        case kAnimationDirectionFromBottom:
            [animation setValue:kAnimationDirectionFromBottomOutLabel forKey:(NSString*)kAnimationLabel];
            break;
    }
    [[self layer] addAnimation:animation forKey:@"position"];
    [CATransaction commit];
    
    [self setNeedsDisplay];
}

- (void)popIn:(void (^)(void))completion {
    // Clear exiting animations
    [self.layer removeAllAnimations];
    
    // Add new animation
    self.alpha = 1.0f;
    CAAnimation * animation = [self generatePopInAnimation];
    [animation setDelegate:self];
    [animation setValue:completion forKey:(NSString*)kAnimationCompletionBlock];
    [self.layer addAnimation:animation forKey:(NSString*)kAnimationPopIn];
}

- (void)popOut:(void (^)(void))completion {
    // Remove any pre-existing animations
    [self.layer removeAllAnimations];
    
    // Add a new animation
    CAAnimation *animation = [self generatePopOutAnimation];
    [animation setDelegate:self];
    [animation setValue:kAnimationPopOut forKey:(NSString*)kAnimationLabel];
    [animation setValue:completion forKey:(NSString*)kAnimationCompletionBlock];
    [self.layer addAnimation:animation forKey:(NSString*)kAnimationPopOut];
}

#pragma mark -
#pragma mark Animation Callbacks
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString * identifer = [anim valueForKey:(NSString*)kAnimationLabel];
    void (^completion)(void) = [anim valueForKey:(NSString*)kAnimationCompletionBlock];
    
    // SlideOut Animation
    if ( [identifer isEqualToString:(NSString*)kAnimationDirectionFromBottomOutLabel] ) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.alpha = 0.0f;
    }
    if ( [identifer isEqualToString:(NSString*)kAnimationDirectionFromTopOutLabel] ) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.alpha = 0.0f;
    }
    
    // Pop Animations
    if ( [identifer isEqualToString:(NSString*)kAnimationPopOut] ) {
        if ( flag ) self.alpha = 0.0f;
    }
    
    // Completion Block
    if ( completion != NULL ) {
        completion();
    }
}

#pragma mark -
#pragma mark Internal Methods
- (CAAnimation*)generatePopInAnimation {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = kAnimationDurationPop;
    scale.values = @[@0.50f, @1.20f, @0.85f, @1.05f, @0.98f, @1.00f];
    
    CABasicAnimation * fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration  = kAnimationDurationPop * 0.4f;
    fadeIn.fromValue = @0.0f;
    fadeIn.toValue   = @1.0f;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    
    return [self generateAnimationGroup:[NSArray arrayWithObjects:scale, fadeIn, nil]];
}

- (CAAnimation*)generatePopOutAnimation {
    CGFloat duration = kAnimationDurationPop * 0.8f;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = @[@1.0f, @1.2f, @0.75f];
    
    CGFloat fraction = 0.4f;
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration  = duration * fraction;
    fadeOut.fromValue = @1.0f;
    fadeOut.toValue   = @0.0f;
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeOut.beginTime = duration * (1.0f - fraction);
    fadeOut.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [self generateAnimationGroup:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.fillMode = kCAFillModeForwards;
    return group;
}

- (CAAnimationGroup*)generateAnimationGroup:(NSArray*)animations {
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = animations;
    group.delegate = self;
    group.duration = kAnimationDurationPop;
    group.removedOnCompletion = NO;
    
    return group;
}

@end
