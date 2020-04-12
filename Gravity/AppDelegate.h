//
//  AppDelegate.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class MainScene;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GLKViewDelegate, GLKViewControllerDelegate> {
    MainScene *scene;
    GLKViewController *controller;
    GLKViewController *controllerPtr;
    UINavigationController *navigation;
    UITextView *textView;
    int textUpdateTimer;
    int textUpdateMax;
}

@property (strong, nonatomic) UIWindow *window;
@property int textUpdateTimer;
@property int textUpdateMax;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)glkViewControllerUpdate:(GLKViewController *)controller;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
