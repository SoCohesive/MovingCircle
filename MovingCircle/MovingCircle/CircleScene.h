//
//  CircleScene.h
//  MovingCircle
//
//  Created by Sonam Dhingra on 9/30/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface CircleScene : SKScene <SKPhysicsContactDelegate>

//number of times the circle tooks slices from the scissor 
@property (nonatomic) int takenHits;


-(void)resetCircleAndStarPosition;
-(void) createCircleVelocity;


@end
