//
//  UIView+Animations.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

typedef enum {
    kAnimationDirectionFromTop = 0,
    kAnimationDirectionFromBottom
} kAnimationDirection;

@interface UIView (Animations)

- (void)slideIn:(kAnimationDirection)fromDirection  completion:(void (^)(void))completion;
- (void)slideOut:(kAnimationDirection)fromDirection completion:(void (^)(void))completion;

- (void)popIn:(void (^)(void))completion;
- (void)popOut:(void (^)(void))completion;

@end