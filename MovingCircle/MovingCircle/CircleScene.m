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
static const uint32_t godzillaCategory     =  0x1 << 2;


@implementation CircleScene
{
    SKSpriteNode   *circle;
    SKSpriteNode   *godzilla;
    SKSpriteNode   *rightWing;
    SKSpriteNode   *leftWing;
    
    NSMutableArray *godzillaTextures;
    NSArray        *godzillaFrames;
    
    CGPoint        *lowerBound;
    CGPoint        *upperBound;
    NSTimer        *timer;
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

        //Set up  edges to interact with circle
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.dynamic = YES;
        
        // set up collision logic
        self.physicsBody.categoryBitMask = frameEdgesCategory;
        self.physicsBody.contactTestBitMask = circleCategory;
        self.physicsBody.collisionBitMask = 0;
    
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsWorld.gravity = CGVectorMake(0,-9);
        
        [self addChild:[self createCircle]];
        [self addChild:[self createGodzilla]];
        //[self addChild:[self createShapeDot]];
        [self animateGodzilla];
    }
    return self;
}

#pragma mark create circle
- (SKSpriteNode *)createCircle {

if (!circle) {
    
        circle = [SKSpriteNode spriteNodeWithImageNamed:@"BaseCircle_Bug.png"];
        circle.position = CGPointMake([self makeRandomXBetween:0 and:self.size.width],[self makeRandomYBetween:0 and:self.frame.size.height]);
        circle.physicsBody.velocity = CGVectorMake(0, 0);
    
        timer = [NSTimer scheduledTimerWithTimeInterval:.8
                                                 target:self
                                               selector:@selector(createCircleVelocity)
                                               userInfo:nil
                                                repeats:NO];
}
    return circle;
}

-(void) createCircleVelocity {
    
    [self createCollisionLogicForCircle];

    //Add it to the physics subsystem by giving it a SKPhysicsBody object and can interact with the other objects
    circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width/2];
    circle.physicsBody.dynamic = YES;
    circle.physicsBody.linearDamping =  0;
    circle.physicsBody.angularDamping = 0;
    
    //Set restitution so node does not lose energy after reacting to edge
    circle.physicsBody.restitution = 1;
    // set mass and friction to 0 so object remains at constant velocity
    circle.physicsBody.mass = 0;
    circle.physicsBody.friction = 0;
    circle.physicsBody.velocity = CGVectorMake(200,200);
    
    circle.physicsBody.allowsRotation = NO;
    circle.physicsBody.affectedByGravity = NO;
    circle.physicsBody.angularVelocity =.0;

//    
//    CGVector circleVelocity = CGVectorMake(200, 200);
//    circle.physicsBody.velocity = circleVelocity;
//    NSLog(@"the circle velocity is %@", circle.physicsBody);

}

-(SKSpriteNode *)createLeftWing  {
    
    leftWing  = [SKSpriteNode spriteNodeWithImageNamed:@"LeftWing.png"];
    return leftWing;
}

-(SKSpriteNode *)createRightWing {
    
    rightWing = [SKSpriteNode spriteNodeWithImageNamed:@"RightWing.png"];
    return  rightWing;
}

-(void)createCollisionLogicForCircle {
    
    //set up collision logic for wall edges
    circle.physicsBody.categoryBitMask = circleCategory;
    circle.physicsBody.contactTestBitMask = frameEdgesCategory;
    circle.physicsBody.collisionBitMask = 1;
    
    //set up collision logic for gozilla
    circle.physicsBody.contactTestBitMask = godzillaCategory;
    circle.physicsBody.collisionBitMask = 2;
}

#pragma create godzilla
-(SKSpriteNode *)createGodzilla
{
    
    //create atlas for godzilla frames to animate properly
    SKTextureAtlas *godzillaAtlas = [SKTextureAtlas atlasNamed:@"godzilla"];
    
    godzillaTextures = [[NSMutableArray alloc] init];
    int numImages = godzillaAtlas.textureNames.count;
    for (int i=1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Godzilla%d", i];
        SKTexture *temp = [godzillaAtlas textureNamed:textureName];
        [godzillaTextures addObject:temp];
        //godzilla = [SKSpriteNode spriteNodeWithTexture:temp];
        //   NSMutableArray *godzillaNoes = [NSMutableArray arrayWithObjects:godzilla, nil];
    }
    godzillaFrames = [NSArray arrayWithArray:godzillaTextures];
    godzilla = [SKSpriteNode spriteNodeWithTexture:godzillaFrames[0]];
    
    godzilla.position = CGPointMake([self makeRandomXBetween:godzilla.frame.size.width/2 and:self.frame.size.width- godzilla.frame.size.width],[self makeRandomYBetween:godzilla.frame.size.height and:self.frame.size.height]);
    
    //    for (int i=0; i<=7;i++ ) {
    //        SKTexture *test = godzillaFrames[i];
    //        godzilla = [SKSpriteNode spriteNodeWithTexture:test];
    //    }
    
    godzilla.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(15,9)];
    godzilla.physicsBody.dynamic = NO;
    godzilla.physicsBody.usesPreciseCollisionDetection = YES;
    [self createCollisionLogicForGodzilla];
    return godzilla;
    [self animateGodzilla];
    
}

#pragma animate godzilla
-(void)animateGodzilla {
    
    SKAction *godzillaEatingAction = [SKAction group:@[[SKAction animateWithTextures:godzillaTextures timePerFrame:0.1]]];
    [godzilla runAction:[SKAction repeatActionForever:godzillaEatingAction]];
    
}

#pragma mark collision logic for godzilla
-(void)createCollisionLogicForGodzilla {
    godzilla.physicsBody.categoryBitMask = godzillaCategory;
    godzilla.physicsBody.contactTestBitMask = circleCategory;
    godzilla.physicsBody.collisionBitMask = 2;
    
}
- (SKEmitterNode*) newSparkleEmitter {
    NSString *sparklePath = [[NSBundle mainBundle] pathForResource: @"MyParticle" ofType:@"sks"];
    SKEmitterNode *sparkle = [NSKeyedUnarchiver unarchiveObjectWithFile:sparklePath];
    
    sparkle.particleBirthRate=80.0;
    sparkle.numParticlesToEmit=200;
    sparkle.emissionAngle = 60.0;
                              
    return sparkle;
                            
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    

    //Create two physics body objects for circle and godzilla
    SKPhysicsBody *firstBody, *secondBody;
    //set up bodies so they are dynamic. First body here is mean to be Circle, second is Godzilla
   

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    }
    else {
        
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & godzillaCategory) != 0) {
        
        [self collision:circle didCollideWithMonster:godzilla];
        SKEmitterNode *sparkle = [self newSparkleEmitter];
        sparkle.position = godzilla.position;
        sparkle.name = @"sparkle";
        [self addChild:sparkle];
        
        //add wings to base circle
        [circle addChild:[self createRightWing]];
        rightWing.position = CGPointMake(15,-2);
        [circle addChild:[self createLeftWing]];
        leftWing.position  = CGPointMake(-15,0);
        
        
    }
    
}

- (void)collision:(SKSpriteNode *)_circle didCollideWithMonster:(SKSpriteNode *)_godzilla
{
    NSLog(@"Circle was hit");
    self.takenHits++;
    circle.physicsBody.velocity = CGVectorMake(0, 0);
}

#pragma progamattically create a circle using SKShapeNode
-(SKShapeNode * )createShapeDot {
    
SKShapeNode *testCircle = [[SKShapeNode alloc] init];
    CGMutablePathRef dotPath = CGPathCreateMutable();
    CGPathAddArc(dotPath, NULL,0,0,9,0,M_PI*2,YES);
    testCircle.path=dotPath;
    testCircle.position=CGPointMake(160,400);
    testCircle.fillColor=[SKColor whiteColor];
    testCircle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:testCircle.frame.size.width/2];
    testCircle.physicsBody.dynamic = YES;

    return testCircle;

}
#pragma mark reset node positions 
-(void) resetCircleAndGorillaPosition {
    
    //reset position
    circle.position = CGPointMake([self makeRandomXBetween:0 and:self.frame.size.width],[self makeRandomYBetween:0 and:self.frame.size.height]);
    circle.physicsBody.velocity = CGVectorMake(0, 0);
    
    godzilla.position = CGPointMake([self makeRandomXBetween:0 and:self.frame.size.width-godzilla.frame.size.width],[self makeRandomYBetween:0 and:self.frame.size.height-godzilla.frame.size.height]);
    
    //delay movement
    timer = [NSTimer scheduledTimerWithTimeInterval:.8
                                             target:self
                                           selector:@selector(createCircleVelocity)
                                           userInfo:nil
                                            repeats:NO];
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
