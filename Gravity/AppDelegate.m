//
//  AppDelegate.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScene.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize textUpdateTimer;
@synthesize textUpdateMax;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    EAGLContext  *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    [view setDelegate:self];
    
    scene = [MainScene new];
    [scene setup];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:scene action:@selector(panned:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [view addGestureRecognizer:panGesture];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:scene action:@selector(pinched:)];
    [view addGestureRecognizer:pinchGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:scene action:@selector(tapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:tapGesture];
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(2, CGFLOAT_MAX)];
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:@"You should not be reading this.\nGo away."];
    NSLayoutManager *manager = [NSLayoutManager new];
    [storage addLayoutManager:manager];
    [storage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[UIFont systemFontSize]] range:NSMakeRange(0, [storage length])];
    [manager addTextContainer:container];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.width-100, [[UIScreen mainScreen] bounds].size.height, 100) textContainer:container];
    [textView setOpaque:NO];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setTextColor:[UIColor whiteColor]];
    [textView setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    [textView setUserInteractionEnabled:NO];
    [view addSubview:textView];
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 725, 100, 40)];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton addTarget:scene action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [editButton setHidden:YES];
    [view addSubview:editButton];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(925, 725, 100, 40)];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton addTarget:scene action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:settingsButton];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(840, 725, 100, 40)];
    [addButton setTitle:@"Add Body" forState:UIControlStateNormal];
    [addButton addTarget:scene action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    
    controller = [[GLKViewController alloc] init];
    [controller setDelegate:self];
    [controller setView:view];
    
    controllerPtr = controller;
    
    navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [navigation setNavigationBarHidden:YES];
    
    [scene setController:controller];
    [scene setEditButton:editButton];
    [scene setSettingsButton:settingsButton];
    [scene setAddButton:addButton];
    [scene setApp:self];
    [scene setNavigation:navigation];
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setRootViewController:navigation];
    [[self window] makeKeyAndVisible];
    
    textUpdateMax = 100;
    
    textUpdateTimer = textUpdateMax;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [scene setLastTime:[NSDate timeIntervalSinceReferenceDate]];
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    [scene update];
    if (textUpdateTimer <= 0) {
        textUpdateTimer = textUpdateMax;
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(2, CGFLOAT_MAX)];
        NSTextStorage *storage = [[NSTextStorage alloc] initWithString:@"You should not be reading this.\nGo away."];
        NSLayoutManager *manager = [NSLayoutManager new];
        [storage addLayoutManager:manager];
        [storage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[UIFont systemFontSize]] range:NSMakeRange(0, [storage length])];
        [manager addTextContainer:container];
        
        [textView removeFromSuperview];
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.width-100, [[UIScreen mainScreen] bounds].size.height, 100) textContainer:container];
        [textView setOpaque:NO];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setTextColor:[UIColor whiteColor]];
        [textView setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [textView setUserInteractionEnabled:NO];
        
        [[controllerPtr view] addSubview:textView];
    }
    else {
        textUpdateTimer -= 1;
    }
    [textView setText:[scene displayText]];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [scene render];
}

// DEFAULT FUNCTIONS BELOW

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Gravity" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Gravity.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
