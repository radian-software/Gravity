//
//  MainViewController.m
//  Gravity
//
//  Created by raxod502 on 12/23/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [[self positionX] setText:[NSString stringWithFormat:@"%.3e", self.sphere.x]];
    if ([[[self positionX] text] isEqualToString:@"0.000e+00"]) {
        [[self positionX] setText:@"0"];
    }
    [[self positionY] setText:[NSString stringWithFormat:@"%.3e", self.sphere.y]];
    if ([[[self positionY] text] isEqualToString:@"0.000e+00"]) {
        [[self positionY] setText:@"0"];
    }
    [[self velocityX] setText:[NSString stringWithFormat:@"%.3e", self.sphere.vx]];
    if ([[[self velocityX] text] isEqualToString:@"0.000e+00"]) {
        [[self velocityX] setText:@"0"];
    }
    [[self velocityY] setText:[NSString stringWithFormat:@"%.3e", self.sphere.vy]];
    if ([[[self velocityY] text] isEqualToString:@"0.000e+00"]) {
        [[self velocityY] setText:@"0"];
    }
    [[self radius] setText:[NSString stringWithFormat:@"%.3e", self.sphere.r]];
    if ([[[self radius] text] isEqualToString:@"0.000e+00"]) {
        [[self radius] setText:@""];
    }
    [[self mass] setText:[NSString stringWithFormat:@"%.3e", self.sphere.m]];
    if ([[[self mass] text] isEqualToString:@"0.000e+00"]) {
        [[self mass] setText:@""];
    }
    if ([[self presentingScene] addingSphere]) {
        [[self deleteButton] setTitle:@"Cancel" forState:UIControlStateNormal];
    }
}

- (IBAction)submitValues:(id)sender {
    @try {
        self.sphere.x = [[[self positionX] text] doubleValue];
        self.sphere.y = [[[self positionY] text] doubleValue];
        self.sphere.vx = [[[self velocityX] text] doubleValue];
        self.sphere.vy = [[[self velocityY] text] doubleValue];
        self.sphere.r = [[[self radius] text] doubleValue];
        self.sphere.circle.radius = self.sphere.r;
        self.sphere.circle.xpos = self.sphere.x;
        self.sphere.circle.ypos = self.sphere.y;
        [self.sphere.circle calculateVertices];
        self.sphere.m = [[[self mass] text] doubleValue];
        NSAssert(self.sphere.m > 0, @"Mass must be positive.");
        NSAssert(self.sphere.r > 0, @"Radius must be positive.");
        if ([[self presentingScene] addingSphere]) {
            [[[self presentingScene] spheres] addObject:self.sphere];
            [[self presentingScene] setAddingSphere:NO];
        }
        [[[self presentingScene] settingsButton] setHidden:NO];
        [[[self presentingScene] addButton] setHidden:NO];
        NSLog(@"Finishing.");
        [self dismissViewControllerAnimated:YES completion:^{[[self presentingScene] setPaused:NO]; [[self presentingScene] setLastTime:[NSDate timeIntervalSinceReferenceDate]];}];
    }
    @catch (id e) {
        //
    }
}

- (IBAction)deleteBody:(id)sender {
    [[[self presentingScene] spheres] removeObject:self.sphere];
    [[self presentingScene] setSelection:nil];
    if (![[self presentingScene] addingSphere]) {
        [[self presentingScene] setDisplayText:@""];
    }
    [self dismissViewControllerAnimated:YES completion:^{[[self presentingScene] setPaused:NO]; [[self presentingScene] setLastTime:[NSDate timeIntervalSinceReferenceDate]]; [[[self presentingScene] settingsButton] setHidden:NO]; [[[self presentingScene] addButton] setHidden:NO];}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
