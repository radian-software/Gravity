//
//  RXShape.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "RXShape.h"

@implementation RXShape

@synthesize vertexData;

- (int)numVertices {
    return 0;
}

- (GLKVector2 *)vertices {
    if (!vertexData) {
        vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2)*[self numVertices]];
    }
    return [vertexData mutableBytes];
}

- (void)render {
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, [self vertices]);
    glDrawArrays(glMode, 0, [self numVertices]);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
