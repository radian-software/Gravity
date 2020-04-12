//
//  RXCircle.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "RXCircle.h"

@implementation RXCircle

@synthesize radius;
@synthesize xpos;
@synthesize ypos;

- (RXCircle *)initWithRadius:(double)r x:(double)x y:(double)y {
    self = [super init];
    [self setRadius:r];
    [self setXpos:x];
    [self setYpos:y];
    glMode = GL_TRIANGLE_FAN;
    self.ratio = 25;
    return self;
}

- (int)numVertices {
    return self.ratio * sqrt([self radius]) + 1;
}

- (void)calculateVertices {
    [self setVertexData:nil];
    int segments = [self numVertices] - 1;
    double theta = 2*M_PI/(segments - 1);
    double tangent = tan(theta);
    double radial = cos(theta);
    double x = radius;
    double y = 0;
    self.vertices[0] = GLKVector2Make(0, 0);
    for (int i=0; i<segments; i++) {
        self.vertices[i+1] = GLKVector2Make(x, y);
        double tx = -y;
        double ty = x;
        x += tx * tangent;
        y += ty * tangent;
        x *= radial;
        y *= radial;
    }
}

- (void)renderWithMatrix:(GLKBaseEffect *)effect {
    GLKMatrix4 original = [[effect transform] modelviewMatrix];
    [[effect transform] setModelviewMatrix:GLKMatrix4Translate(original, xpos, ypos, 0)];
    [effect setUseConstantColor:YES];
    [effect setConstantColor:[self color]];
    [effect prepareToDraw];
    
    [super render];
    
    [[effect transform] setModelviewMatrix:original];
}

@end
