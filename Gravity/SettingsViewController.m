//
//  SettingsViewController.m
//  Gravity
//
//  Created by raxod502 on 12/24/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [[self speedField] setText:[NSString stringWithFormat:@"%.3e", [self speed]]];
    [[self collisionSwitch] setSelectedSegmentIndex:[self collisionType]];
    [[self accuracyField] setText:[NSString stringWithFormat:@"%i", [self accuracy]]];
    [[self updateField] setText:[NSString stringWithFormat:@"%i", [[self app] textUpdateMax]]];
    [[self positionFieldX] setText:[NSString stringWithFormat:@"%.3e", [self offsetX]]];
    if ([[[self positionFieldX] text] isEqualToString:@"0.000e+00"]) {
        [[self positionFieldX] setText:@"0"];
    }
    [[self positionFieldY] setText:[NSString stringWithFormat:@"%.3e", [self offsetY]]];
    if ([[[self positionFieldY] text] isEqualToString:@"0.000e+00"]) {
        [[self positionFieldY] setText:@"0"];
    }
    [[self scaleField] setText:[NSString stringWithFormat:@"%.3e", [self scale]]];
    if ([[[self scaleField] text] isEqualToString:@"1.000e+00"]) {
        [[self scaleField] setText:@"1"];
    }
    [[self vertexField] setText:[NSString stringWithFormat:@"%i", [self vertexRatio]]];
}

- (IBAction)submitValues:(id)sender {
    @try {
        [[self app] setTextUpdateMax:[[[self updateField] text] intValue]];
        [self setSpeed:[[[self speedField] text] doubleValue]];
        [self setCollisionType:(int)[[self collisionSwitch] selectedSegmentIndex]];
        [self setAccuracy:[[[self accuracyField] text] intValue]];
        [self setOffsetX:[[[self positionFieldX] text] doubleValue]];
        [self setOffsetY:[[[self positionFieldY] text] doubleValue]];
        [self setScale:[[[self scaleField] text] doubleValue]];
        [self setVertexRatio:[[[self vertexField] text] intValue]];
        [[self presentingScene] setSpeed:[self speed]];
        [[self presentingScene] setCollisionType:[self collisionType]];
        [[self presentingScene] setResolution:[self accuracy]];
        [[self presentingScene] setNetX:[self offsetX]];
        [[self presentingScene] setNetY:[self offsetY]];
        [[self presentingScene] setNetScale:[self scale]];
        [[self presentingScene] setVertexRatio:[self vertexRatio]];
        for (Sphere *sphere in [[self presentingScene] spheres]) {
            [[sphere circle] setRatio:[self vertexRatio]];
            [[sphere circle] calculateVertices];
        }
        [[[self presentingScene] settingsButton] setHidden:NO];
        [[[self presentingScene] addButton] setHidden:NO];
        [self dismissViewControllerAnimated:YES completion:^{[[self presentingScene] setPaused:NO]; [[self presentingScene] setLastTime:[NSDate timeIntervalSinceReferenceDate]];}];
    }
    @catch (NSException *e) {
        //
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
