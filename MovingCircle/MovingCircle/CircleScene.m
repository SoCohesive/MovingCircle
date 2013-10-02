//
//  CircleScene.m
//  MovingCircle
//
//  Created by Sonam Dhingra on 9/30/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import "CircleScene.h"

static const uint32_t frameEdgesCategory   =  0x1 << 0;
static const uint32_t circleCategory       =  0x1 << 1;

@implementation CircleScene
{
    SKSpriteNode *circle;
    CGPoint      *lowerBound;
    CGPoint      *upperBound;
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

        //Set up path for edges to interact with circle
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.dynamic = YES;
        
        // set up collision logic
        self.physicsBody.categoryBitMask = frameEdgesCategory;
        self.physicsBody.contactTestBitMask = circleCategory;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsWorld.gravity = CGVectorMake(0,-9);
        [self addChild:[self createCircle]];
    }
    return self;
}

#pragma mark create circle
- (SKSpriteNode *)createCircle {
    if (!circle) {
        
        circle = [SKSpriteNode spriteNodeWithImageNamed:@"FlatCircle_1.png"];
        circle.position = CGPointMake([self makeRandomXBetween:0 and:self.size.width],[self makeRandomYBetween:0 and:self.frame.size.height]);
        
        //set up collision logic
        circle.physicsBody.categoryBitMask = circleCategory;
        circle.physicsBody.contactTestBitMask = frameEdgesCategory;
        circle.physicsBody.collisionBitMask = 1;


        //configure properties for physics handling
        //Add it to the physics subsystem by giving it a SKPhysicsBody object and can interact with the scissor
        circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width/2];
        circle.physicsBody.dynamic = YES;
        circle.physicsBody.linearDamping =  0;
        circle.physicsBody.angularDamping = 0;
        
        //Set restitution so node does not lose energy after reacting to edge
        circle.physicsBody.restitution = 1;
        circle.physicsBody.mass = 0;
        circle.physicsBody.friction = 0;
        circle.physicsBody.velocity = CGVectorMake(400,400);
        circle.physicsBody.affectedByGravity = NO;
        circle.physicsBody.angularVelocity =.2f;

    }
    
    return circle;
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    

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




@end
