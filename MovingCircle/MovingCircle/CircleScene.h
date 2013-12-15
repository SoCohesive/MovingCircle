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
@property (strong,nonatomic) SKSpriteNode *elephantTrunk;
@property (strong,nonatomic) SKSpriteNode *elephantBody;
@property(nonatomic) UISwipeGestureRecognizerDirection direction;
@property(nonatomic) NSUInteger numberOfTouchesRequired;
@property (nonatomic, strong) SKSpriteNode *selectedNode;



-(void)resetCircleAndStarPosition;
-(void) createCircleVelocity;


@end
