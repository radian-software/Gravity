//
//  Sphere.m
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "Sphere.h"

@implementation Sphere

- (Sphere *)initWithX:(double)x y:(double)y r:(double)r m:(double)m vx:(double)vx vy:(double)vy {
    self.x = x; self.y = y; self.r = r; self.m = m;
    self.vx = vx; self.vy = vy; self.ax = 0; self.ay = 0;
    [self setCircle:[[RXCircle alloc] initWithRadius:self.r x:self.x y:self.y]];
    [[self circle] setColor:GLKVector4Make(1, 1, 1, 1)];
    [[self circle] calculateVertices];
    return self;
}

- (void)drawWithMatrix:(GLKBaseEffect *)effect {
    [[self circle] renderWithMatrix:(GLKBaseEffect *)effect];
}

- (void)physics:(NSMutableArray *)others withCollisionType:(int)collisionType {
    self.ax = 0;
    self.ay = 0;
    for (Sphere *other in others) {
        if (other == self) continue;
        double d = hypot(other.x - self.x, other.y - self.y);
        double angle = atan2(other.y - self.y, other.x - self.x);
        if (d < self.r + other.r) {
            if (collisionType == 0) {
                self.vx = -self.vx;
                self.vy = -self.vy;
                self.ax = 0;
                self.ay = 0;
                continue;
            }
            else if (collisionType == 1) {
                self.oldvx = self.vx;
                self.oldvy = self.vy;
                self.collided = YES;
                double ovx, ovy;
                if (other.collided) {
                    ovx = other.oldvx;
                    ovy = other.oldvy;
                }
                else {
                    ovx = other.vx;
                    ovy = other.vy;
                }
                double change = 2 * hypot(self.oldvx - ovx, self.oldvy - ovy) / (1/self.m + 1/other.m) / self.m;
                self.vx = self.oldvx + change * cos(angle + M_PI);
                self.vy = self.oldvy + change * sin(angle + M_PI);
            }
            else if (collisionType == 2) {
                self.oldvx = self.vx;
                self.oldvy = self.vy;
                self.collided = YES;
                double ovx, ovy;
                if (other.collided) {
                    ovx = other.oldvx;
                    ovy = other.oldvy;
                }
                else {
                    ovx = other.vx;
                    ovy = other.vy;
                }
                self.vx = (self.oldvx * (self.m - other.m) + 2 * other.m * ovx) / (self.m + other.m);
                self.vy = (self.oldvy * (self.m - other.m) + 2 * other.m * ovy) / (self.m + other.m);
            }
            else if (collisionType == 3) {
                self.ax = 0;
                self.ay = 0;
                continue;
            }
        }
        double force = G * self.m * other.m / pow(d, 2);
        double a = force / self.m;
        self.ax += a * cos(angle);
        self.ay += a * sin(angle);
    }
}

- (void)updateOverTime:(double)time {
    self.x += self.vx * time + 0.5 * self.ax * time * time;
    self.y += self.vy * time + 0.5 * self.ay * time * time;
    self.vx += self.ax * time;
    self.vy += self.ay * time;
    RXCircle *circle = [self circle];
    [circle setXpos:self.x]; // [self circle] takes up 0.7% of processing time? Really?
    [circle setYpos:self.y];
}

@end
