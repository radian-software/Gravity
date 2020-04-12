//
//  MainScene.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "MainScene.h"
#import "MainViewController.h"
#import "SettingsViewController.h"

@implementation MainScene

@synthesize spheres;
@synthesize speed;
@synthesize lastScale;
@synthesize netScale;
@synthesize lastTime;
@synthesize resolution;
@synthesize lastX, lastY;
@synthesize netX, netY;
@synthesize selection;
@synthesize displayText;
@synthesize controller;
@synthesize editButton;
@synthesize settingsButton;
@synthesize addButton;
@synthesize paused;
@synthesize collisionType;
@synthesize app;
@synthesize notNewSphere;
@synthesize addingSphere;
@synthesize navigation;
@synthesize vertexRatio;

- (void)setup {
    [super setup];
    
    clearColor = GLKVector4Make(0, 0, 0, 1);
    left = -30;
    right = 30;
    bottom = -20;
    top = 20;
    
    spheres = [NSMutableArray new];
    [spheres addObject:[[Sphere alloc] initWithX:20 y:10 r:2 m:1000 vx:0 vy:0]];
    [spheres addObject:[[Sphere alloc] initWithX:0 y:0 r:1 m:200 vx:0 vy:0]];
    [spheres addObject:[[Sphere alloc] initWithX:10 y:-7 r:0.75 m:150 vx:0 vy:0]];
    
    speed = 10e+4;
    resolution = 200;
    
    lastTime = [NSDate timeIntervalSinceReferenceDate];
    
    lastScale = 1.0;
    netScale = 1.0;
    lastX = 0; lastY = 0;
    netX = 0; netY = 0;
    
    [self setDisplayText:@""];
    collisionType = 1;
    vertexRatio = 25;
    
    paused = NO;
}

- (void)update {
    if (paused) return;
    double currentTime = [NSDate timeIntervalSinceReferenceDate];
    for (int i=0; i<resolution; i++) {
        for (Sphere *sphere in spheres) {
            [sphere setCollided:NO];
        }
        for (Sphere *sphere in spheres) {
            [sphere physics:spheres withCollisionType:collisionType];
        }
        for (Sphere *sphere in spheres) {
            [sphere updateOverTime:(currentTime - lastTime) * speed / resolution];
        }
    }
    lastTime = currentTime;
    
    if (selection) {
        [self setDisplayText:[NSString stringWithFormat:@"Position: (%.3e, %.3e) m\nVelocity: (%.3e, %.3e) m/s\nAcceleration: (%.3e, %.3e) m/s^2\nRadius: %.3e m\nMass: %.3e kg", selection.x, selection.y, selection.vx, selection.vy, selection.ax, selection.ay, selection.r, selection.m]];
        [editButton setHidden:addingSphere];
    }
    else {
        [editButton setHidden:YES];
    }
}

- (void)render {
    if (paused) return;
    [super render];
    [[effect transform] setModelviewMatrix:GLKMatrix4Scale([[effect transform] modelviewMatrix], netScale, netScale, netScale)];
    
    [[effect transform] setModelviewMatrix:GLKMatrix4Translate([[effect transform] modelviewMatrix], netX / [[UIScreen mainScreen] bounds].size.width * (right - left), netY / [[UIScreen mainScreen] bounds].size.height * (bottom - top), 0)];
    
    for (Sphere *sphere in spheres) {
        [sphere drawWithMatrix:effect];
    }
}

- (void)panned:(UIPanGestureRecognizer *)sender {
    CGPoint translated = [sender translationInView:[sender view]];
    
    netX += (translated.x - lastX) / netScale;
    netY += (translated.y - lastY) / netScale;
    lastX = translated.x; lastY = translated.y;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        lastX = 0; lastY = 0;
    }
}

- (void)pinched:(UIPinchGestureRecognizer *)sender {
    netScale *= [sender scale] / lastScale;
    lastScale = [sender scale];
    if ([sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
    }
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    CGPoint tap = [sender locationInView:[sender view]];
    bool success;
    GLKMatrix4 antiScreen = GLKMatrix4MakeOrtho(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 0, 1, -1);
    GLKMatrix4 projection = GLKMatrix4Invert(GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1), &success);
    GLKMatrix4 model = GLKMatrix4Invert([[effect transform] modelviewMatrix], &success);
    GLKMatrix4 netMatrix = GLKMatrix4Multiply(GLKMatrix4Multiply(model, projection), antiScreen);
    GLKVector4 location = GLKMatrix4MultiplyVector4(netMatrix, GLKVector4Make(tap.x, tap.y, 0, 1.0));
    if (addingSphere) {
        paused = YES;
        [[self editButton] setHidden:YES];
        [[self settingsButton] setHidden:YES];
        
        MainViewController *modal = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        notNewSphere = [[Sphere alloc] initWithX:location.x y:location.y r:0 m:0 vx:0 vy:0];
        [modal setSphere:notNewSphere];
        [modal setPresentingScene:self];
        
        [navigation setModalPresentationStyle:UIModalPresentationCurrentContext];
        
        [controller presentViewController:modal animated:YES completion:nil];
    }
    else {
        BOOL done = NO;
        for (double i=1; i<1000000; i*=1.1) {
            for (Sphere *sphere in spheres) {
                if (hypot(sphere.x - location.x, sphere.y - location.y) <= i) {
                    [[selection circle] setColor:GLKVector4Make(1, 1, 1, 1)];
                    selection = sphere;
                    [[selection circle] setColor:GLKVector4Make(1, 0, 0, 1)];
                    done = YES;
                    break;
                }
            }
            if (done) break;
        }
    }
}

- (void)editButtonPressed {
    paused = YES;
    [[self editButton] setHidden:YES];
    [[self settingsButton] setHidden:YES];
    [[self addButton] setHidden:YES];
    
    MainViewController *modal = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [modal setSphere:selection];
    [modal setPresentingScene:self];
    
    [navigation setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [controller presentViewController:modal animated:YES completion:nil];
}

- (void)settingsButtonPressed {
    paused = YES;
    [[self editButton] setHidden:YES];
    [[self settingsButton] setHidden:YES];
    [[self addButton] setHidden:YES];
    
    SettingsViewController *modal = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [modal setPresentingScene:self];
    [modal setSpeed:[self speed]];
    [modal setCollisionType:[self collisionType]];
    [modal setAccuracy:[self resolution]];
    [modal setApp:[self app]];
    [modal setOffsetX:netX];
    [modal setOffsetY:netY];
    [modal setScale:netScale];
    [modal setVertexRatio:vertexRatio];
    
    [navigation setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [controller presentViewController:modal animated:YES completion:nil];
}

- (void)addButtonPressed {
    [[self editButton] setHidden:YES];
    [[self settingsButton] setHidden:YES];
    [[self addButton] setHidden:YES];
    addingSphere = YES;
}

- (UIImage *)getScreenshot {
    return [(GLKView *)[controller view] snapshot];
    
    // Much longer way of accomplishing the same thing:
    
    GLint width, height;
    
    GLint renderBuffer;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &renderBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height);
    
    GLint x = 0, y = 0;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte *)malloc(dataLength * sizeof(GLubyte));
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast, ref, NULL, true, kCGRenderingIntentDefault);
    
    NSInteger pwidth, pheight;
    CGFloat scale = [(GLKView *)[controller view] contentScaleFactor];
    pwidth = width / scale;
    pheight = height / scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(pwidth, pheight), NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, pwidth, pheight), iref);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    free(data);
    CFRelease(ref);
    CFRelease(colorSpace);
    CGImageRelease(iref);
    
    return image;
}

@end
