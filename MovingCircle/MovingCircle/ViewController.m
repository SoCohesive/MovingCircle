//
//  ViewController.m
//  MovingCircle
//
//  Created by Sonam Dhingra on 9/30/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import "ViewController.h"
#import "CircleScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *circleView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene *circleScene = [CircleScene sceneWithSize:circleView.bounds.size];
    circleScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [circleView presentScene:circleScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
