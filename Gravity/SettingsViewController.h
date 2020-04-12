//
//  SettingsViewController.h
//  Gravity
//
//  Created by raxod502 on 12/24/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScene.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

@property MainScene *presentingScene;
@property double speed;
@property int collisionType;
@property int accuracy;
@property AppDelegate *app;
@property double offsetX;
@property double offsetY;
@property double scale;
@property int vertexRatio;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *speedField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collisionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *accuracyField;
@property (weak, nonatomic) IBOutlet UITextField *updateField;
@property (weak, nonatomic) IBOutlet UITextField *positionFieldX;
@property (weak, nonatomic) IBOutlet UITextField *positionFieldY;
@property (weak, nonatomic) IBOutlet UITextField *scaleField;
@property (weak, nonatomic) IBOutlet UITextField *vertexField;

- (void)viewDidLoad;
- (IBAction)submitValues:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
