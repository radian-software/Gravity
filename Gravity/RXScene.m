//
//  RXScene.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "RXScene.h"

@implementation RXScene

@synthesize clearColor;
@synthesize left, right, bottom, top;
@synthesize effect;

- (void)setup {
    effect = [GLKBaseEffect new];
}

- (void)update {
    //
}

- (void)render {
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT);

    [[effect transform] setProjectionMatrix:GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1)];
    [[effect transform] setModelviewMatrix:GLKMatrix4Identity];
}

@end
