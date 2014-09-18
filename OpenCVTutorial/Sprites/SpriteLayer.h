//
//  SpriteLayer.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SpriteLayer : CALayer

@property (readwrite, nonatomic) NSUInteger spriteIndex;

+ (id)layerWithImage:(CGImageRef)image spriteSize:(CGSize)size;

- (NSUInteger)currentSpriteIndex;

@end
