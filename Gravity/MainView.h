//
//  MainView.h
//  Gravity
//
//  Created by raxod502 on 12/23/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "Sphere.h"
#import <UIKit/UIKit.h>

@interface MainView : UIView

@property(weak, nonatomic) IBOutlet UITextField *positionX;
@property(weak, nonatomic) IBOutlet UITextField *positionY;
@property(weak, nonatomic) IBOutlet UITextField *velocityX;
@property(weak, nonatomic) IBOutlet UITextField *velocityY;
@property(weak, nonatomic) IBOutlet UITextField *radius;
@property(weak, nonatomic) IBOutlet UITextField *mass;

@property Sphere *sphere;

- (IBAction)submitValues:(id)sender;

@end
