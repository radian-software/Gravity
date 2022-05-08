//
//  Sphere.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "RXCircle.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define G 6.67384e-11
#define dist(x1, y1, x2, y2) sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))

@interface Sphere : NSObject

@property double x;
@property double y;
@property double r;
@property double m;
@property double vx;
@property double vy;
@property double ax;
@property double ay;
@property RXCircle *circle;
@property BOOL collided;
@property double oldvx;
@property double oldvy;

- (Sphere *)initWithX:(double)x
                    y:(double)y
                    r:(double)r
                    m:(double)m
                   vx:(double)vx
                   vy:(double)vy;
- (void)drawWithMatrix:(GLKBaseEffect *)effect;
- (void)physics:(NSMutableArray *)others withCollisionType:(int)collisionType;
- (void)updateOverTime:(double)time;

@end
