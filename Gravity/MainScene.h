//
//  MainScene.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "AppDelegate.h"
#import "RXScene.h"
#import "Sphere.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MainScene : RXScene <UIGestureRecognizerDelegate> {
  NSMutableArray *spheres;
  double speed;
  int resolution;
  double lastScale;
  double netScale;
  double lastTime;
  double lastX, lastY;
  double netX, netY;
  Sphere *selection;
  NSString *displayText;
  GLKViewController *controller;
  UIButton *editButton;
  UIButton *settingsButton;
  UIButton *addButton;
  BOOL paused;
  int collisionType;
  AppDelegate *app;
  Sphere *notNewSphere;
  BOOL addingSphere;
  UINavigationController *navigation;
  int vertexRatio;
}

@property NSMutableArray *spheres;
@property double speed;
@property int resolution;
@property double lastScale;
@property double netScale;
@property double lastTime;
@property double lastX, lastY;
@property double netX, netY;
@property Sphere *selection;
@property NSString *displayText;
@property GLKViewController *controller;
@property UIButton *editButton;
@property UIButton *settingsButton;
@property UIButton *addButton;
@property BOOL paused;
@property int collisionType;
@property AppDelegate *app;
@property Sphere *notNewSphere;
@property BOOL addingSphere;
@property UINavigationController *navigation;
@property int vertexRatio;

- (void)setup;
- (void)update;
- (void)render;
- (void)panned:(UIPanGestureRecognizer *)sender;
- (void)pinched:(UIPinchGestureRecognizer *)sender;
- (void)tapped:(UITapGestureRecognizer *)sender;
- (void)editButtonPressed;
- (void)settingsButtonPressed;
- (void)addButtonPressed;
- (UIImage *)getScreenshot;

@end
