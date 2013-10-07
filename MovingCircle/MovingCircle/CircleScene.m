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
static const uint32_t starCategory         =  0x1 << 2;


@implementation CircleScene
{
    SKSpriteNode   *circle;
    SKSpriteNode   *star;
    SKSpriteNode   *rightWing;
    SKSpriteNode   *leftWing;
    SKSpriteNode   *ladybugHead;
    
    NSMutableArray *starTextures;
    NSArray        *starFrames;
    
    SKEmitterNode  *sparkle;
    
    CGPoint        *lowerBound;
    CGPoint        *upperBound;
    NSTimer        *timer;
    
    AVAudioPlayer  *magicSoundEffect;
    

}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        SKSpriteNode *backgroundSprite;
        SKTexture    *backgroundImageTexture =[SKTexture textureWithImage:[UIImage imageNamed:@"Jungle_BG.png"]];
        backgroundSprite = [SKSpriteNode spriteNodeWithTexture:backgroundImageTexture];
        backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backgroundSprite];

        
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
        [self addChild:[self createStar]];
        //[self addChild:[self createShapeDot]];
        [self animateStar];
    }
    return self;
}

#pragma mark create circle
- (SKSpriteNode *)createCircle {
        circle = [SKSpriteNode spriteNodeWithImageNamed:@"BaseCircle_Bug.png"];
        circle.position = CGPointMake([self makeRandomXBetween:circle.frame.size.width and:self.size.width with:circle],
                                      [self makeRandomYBetween:circle.frame.size.height and:self.frame.size.height with:circle]);
        circle.physicsBody.velocity = CGVectorMake(0, 0);
    
        timer = [NSTimer scheduledTimerWithTimeInterval:.8
                                                 target:self
                                               selector:@selector(createCircleVelocity)
                                               userInfo:nil
                                                repeats:NO];
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
}

#pragma mark add parts to circle on collision
-(SKSpriteNode *)createLeftWing  {
    
    leftWing  = [SKSpriteNode spriteNodeWithImageNamed:@"LeftWing.png"];
    return leftWing;
}

-(SKSpriteNode *)createRightWing {
    
    SKTexture *rightWingTexture = [SKTexture textureWithImageNamed:@"RightWing.png"];
    rightWing = [SKSpriteNode spriteNodeWithTexture:rightWingTexture];

    return  rightWing;
}

-(SKSpriteNode *)createLadybugHead {
    
    ladybugHead = [SKSpriteNode spriteNodeWithImageNamed:@"HeadCircle.png"];
    return  ladybugHead;
}

#pragma mark animate wings and circle flying up
-(void)animatLadybugWings {
    
    rightWing.anchorPoint = CGPointMake(0.5, .5);
    leftWing.anchorPoint  = CGPointMake(0.5, 0.5);
    
    //RightSide Wing position
    CGPoint position = rightWing.position;
    CGFloat posX= position.x;
    CGFloat posY = 20;
    rightWing.position = CGPointMake(posX, posY);
    rightWing.anchorPoint = CGPointMake(0.5, 1.0);
    

    //LeftWing position
    CGPoint leftPosition = leftWing.position;
    CGFloat leftPosX= leftPosition.x-5;
    CGFloat leftPosY = 26;
    leftWing.position = CGPointMake(leftPosX,leftPosY);
    leftWing.anchorPoint = CGPointMake(0, 1.0);
    

    SKAction *rotateAction = [SKAction sequence:@[
                                                 [SKAction rotateByAngle:1 duration:.5],
                                                 [SKAction rotateByAngle:-1 duration:.5]]];
    SKAction *rotateInfinite = [SKAction repeatActionForever:rotateAction];
    [rightWing runAction:rotateInfinite];
    
    
    SKAction *leftRotateAction = [SKAction sequence:@[
                                                      [SKAction rotateByAngle:-1 duration:.5],
                                                      [SKAction rotateByAngle:1 duration:.5]]];
    SKAction *leftRotateInfinite = [SKAction repeatActionForever:leftRotateAction];
    [leftWing runAction:leftRotateInfinite];
    
    SKAction *moveCircle = [SKAction sequence:@[
                                                [SKAction moveToY:self.size.height+circle.frame.size.height duration:1.0]]];
    [circle runAction:moveCircle];
    [sparkle removeFromParent];
    //reset the game after circle moves off screen
    [self performSelector:@selector(resetCircleAndStarPosition)
               withObject:self
               afterDelay:1.5];

}

-(void)createCollisionLogicForCircle {
    
    //set up collision logic for wall edges
    circle.physicsBody.categoryBitMask = circleCategory;
    circle.physicsBody.contactTestBitMask = frameEdgesCategory;
    circle.physicsBody.collisionBitMask = 1;
    
    //set up collision logic for gozilla
    circle.physicsBody.contactTestBitMask = starCategory;
    circle.physicsBody.collisionBitMask = 2;
}

#pragma create star
-(SKSpriteNode *)createStar
{
    
    //create atlas for starframes to animate properly
    SKTextureAtlas *starAtlas = [SKTextureAtlas atlasNamed:@"Star_Wand"];
    starTextures = [[NSMutableArray alloc] init];
    
    float numImages = starAtlas.textureNames.count;
    for (int i=1; i <= numImages/2; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"Star_%d", i];
        SKTexture *temp =[starAtlas textureNamed:textureName];
        [starTextures addObject:temp];
    
    }
    
    starFrames = [NSArray arrayWithArray:starTextures];
    star = [SKSpriteNode spriteNodeWithTexture:starFrames[0]];
    
    star.position = CGPointMake([self makeRandomXBetween:star.frame.size.width and:self.frame.size.width with:star],
                                [self makeRandomYBetween:star.frame.size.height and:self.frame.size.height with:star]);

    star.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(15,15)];
    star.physicsBody.dynamic = NO;
    star.physicsBody.usesPreciseCollisionDetection = YES;
    [self createCollisionLogicForStar];
    return star;
    [self animateStar];
    
}

#pragma animate star
-(void)animateStar {
    
    SKAction *starAction = [SKAction group:@[[SKAction animateWithTextures:starTextures timePerFrame:0.1 resize:YES restore:YES]]];
    [star runAction:[SKAction repeatActionForever:starAction]];
    
}

#pragma mark collision logic for star
-(void)createCollisionLogicForStar {
    star.physicsBody.categoryBitMask = starCategory;
    star.physicsBody.contactTestBitMask = circleCategory;
    star.physicsBody.collisionBitMask = 2;
    
}

#pragma mark set up emitter
- (SKEmitterNode*) newSparkleEmitter {
    NSString *sparklePath = [[NSBundle mainBundle] pathForResource: @"MyParticle" ofType:@"sks"];
    sparkle = [NSKeyedUnarchiver unarchiveObjectWithFile:sparklePath];
    
    sparkle.particleBirthRate=80.0;
    sparkle.numParticlesToEmit=200;
    sparkle.emissionAngle = 60.0;
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"magic-chime-02" withExtension:@"aif"];
    magicSoundEffect = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
                              
    return sparkle;
                            
}

#pragma set up collision logic
- (void)didBeginContact:(SKPhysicsContact *)contact {
    

    //Create two physics body objects for circle and 
    SKPhysicsBody *firstBody, *secondBody;
    //set up bodies so they are dynamic. First body here is mean to be Circle, second is Star
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    }
    else {
        
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & starCategory) != 0) {
        
        [self collision:circle didCollideWithMonster:star];
        sparkle = [self newSparkleEmitter];
        sparkle.position = star.position;
        sparkle.name = @"sparkle";
        [self addChild:sparkle];
         magicSoundEffect.numberOfLoops = 1;
        [magicSoundEffect prepareToPlay];
        [magicSoundEffect play];
    
    }
    
}

- (void)collision:(SKSpriteNode *)_circle didCollideWithMonster:(SKSpriteNode *)_star
{
    NSLog(@"Circle was hit");
    self.takenHits++;
    NSLog(@"taken hits is now %i",self.takenHits);
    circle.physicsBody.velocity = CGVectorMake(0, 0);
    
    //add wings to base circle
    [circle addChild:[self createRightWing]];
    rightWing.position = CGPointMake(15,-2);
    [circle addChild:[self createLeftWing]];
    leftWing.position  = CGPointMake(-15,0);
    [circle addChild:[self createLadybugHead]];
    ladybugHead.position = CGPointMake(2, 25);
    
    [self animatLadybugWings];
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
-(void) resetCircleAndStarPosition {
    
    [sparkle removeFromParent];
    //reset position
    [circle removeAllChildren];
    circle.position = CGPointMake([self makeRandomXBetween:circle.frame.size.width and:self.frame.size.width with:circle],
                                  [self makeRandomYBetween:circle.frame.size.height and:self.frame.size.height with:circle]);
    circle.physicsBody.velocity = CGVectorMake(0, 0);
    
    star.position = CGPointMake([self makeRandomXBetween:star.frame.size.width and:self.frame.size.width with:star],
                                [self makeRandomYBetween:star.frame.size.height and:self.frame.size.height with:star]);
   
    
    //delay movement
    timer = [NSTimer scheduledTimerWithTimeInterval:.8
                                             target:self
                                           selector:@selector(createCircleVelocity)
                                           userInfo:nil
                                            repeats:NO];
}

#pragma make random X start position
- (CGFloat)makeRandomXBetween:(CGFloat)low and:(CGFloat)high with:(SKSpriteNode *)nodeBounds
{

    int xMin = ([nodeBounds frame].size.width)/2;
    CGFloat randomValue = xMin + (arc4random() % (int) (high - low));
    
    if (circle.frame.origin.x != star.frame.origin.x) {
   
        return randomValue;
        
}
 else
    
     [self resetCircleAndStarPosition];
     return randomValue;
    
}

#pragma make random Y start position
- (CGFloat)makeRandomYBetween:(CGFloat)low and:(CGFloat)high with:(SKSpriteNode *)nodeBounds
{
    int yMin = ([nodeBounds frame].size.height)/2;
    CGFloat randomValue = yMin + (arc4random() % (int) (high - low));
    
    if (circle.frame.origin.y != star.frame.origin.y) {
        
        return randomValue;
    }
    
    [self resetCircleAndStarPosition];
    return randomValue;
}



@end
