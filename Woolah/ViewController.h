//
//  ViewController.h
//  Woolah
//
//  Created by Venkatesh M on 04/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>

#import "ActivityBaseViewController.h"

@interface ViewController : ActivityBaseViewController <FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

- (IBAction)facebookLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
- (IBAction)googleSignIn:(id)sender;

@end

