//
//  RXShape.h
//  Gravity
//
//  Created by raxod502 on 12/22/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RXShape : NSObject {
  NSMutableData *vertexData;
  int glMode;
}

@property(readonly) int numVertices;
@property(readonly) GLKVector2 *vertices;
@property NSMutableData *vertexData;

- (void)render;

@end
