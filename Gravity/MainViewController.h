//
//  MainViewController.h
//  Gravity
//
//  Created by raxod502 on 12/23/13.
//  Copyright (c) 2013–2022 Radian LLC and contributors.
//

#import "MainScene.h"
#import "Sphere.h"
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *positionX;
@property(weak, nonatomic) IBOutlet UITextField *positionY;
@property(weak, nonatomic) IBOutlet UITextField *velocityX;
@property(weak, nonatomic) IBOutlet UITextField *velocityY;
@property(weak, nonatomic) IBOutlet UITextField *radius;
@property(weak, nonatomic) IBOutlet UITextField *mass;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIButton *deleteButton;

@property Sphere *sphere;
@property MainScene *presentingScene;

- (void)viewDidLoad;
- (IBAction)submitValues:(id)sender;
- (IBAction)deleteBody:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
