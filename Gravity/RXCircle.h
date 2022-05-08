//
//  RXCircle.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "RXShape.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RXCircle : RXShape

@property double radius;
@property double xpos;
@property double ypos;
@property GLKVector4 color;
@property int ratio;

- (RXCircle *)initWithRadius:(double)r x:(double)x y:(double)y;
- (int)numVertices;
- (void)calculateVertices;
- (void)renderWithMatrix:(GLKBaseEffect *)effect;

@end
