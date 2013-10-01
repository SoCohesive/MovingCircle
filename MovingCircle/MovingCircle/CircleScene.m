//
//  CircleScene.m
//  MovingCircle
//
//  Created by Sonam Dhingra on 9/30/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import "CircleScene.h"

@implementation CircleScene
{
    SKSpriteNode *circle;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        self.backgroundColor = [SKColor lightGrayColor];
        self.physicsWorld.contactDelegate=self;
        //Initialize your properties
         self.takenHits=0;
        [self addChild:[self createCircle]];
    }
    return self;
}

#pragma make random X start position
- (CGFloat)makeRandomXBetween:(CGFloat)low and:(CGFloat)high
{
  
    CGFloat randomValue = (arc4random() % (int) (high - low));
    return randomValue;

}

#pragma make random Y start position
- (CGFloat)makeRandomYBetween:(CGFloat)low and:(CGFloat)high
{
    CGFloat randomValue = (arc4random() % (int) (high - low));
    return randomValue;
}

#pragma mark create circle
- (SKSpriteNode *)createCircle {
    if (!circle) {
        
        circle = [SKSpriteNode spriteNodeWithImageNamed:@"FlatCircle_1.png"];
        circle.position = CGPointMake([self makeRandomXBetween:0 and:self.size.width],[self makeRandomYBetween:0 and:self.frame.size.height]);
        
        //Add it to the physics subsystem by giving it a SKPhysicsBody object and can interact with the scissor
        circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width/2];
        circle.physicsBody.dynamic = NO;
    }
    
    return circle;
}



@end
