//
//  RXScene.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RXScene : NSObject {
    GLKVector4 clearColor;
    double left, right, bottom, top;
    GLKBaseEffect *effect;
}

@property GLKVector4 clearColor;
@property double left, right, bottom, top;
@property GLKBaseEffect *effect;

- (void)setup;
- (void)update;
- (void)render;

@end
