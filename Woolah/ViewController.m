//
//  ViewController.m
//  Woolah
//
//  Created by Venkatesh M on 04/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "HandShakeViewController.h"
#import "AFNetworking.h"
#import "Context.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Facebook

- (IBAction)facebookLogin:(id)sender {
    
//    [self performSegueWithIdentifier:@"homePageSegue" sender:nil];
    
   [self showActivityWithMessage:nil];
    
    NSArray *permissionsArray = @[@"public_profile",@"user_about_me",@"email", @"user_relationships", @"user_birthday", @"user_location",@"user_hometown",@"user_friends"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: permissionsArray
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hideActivity];
             });

         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hideActivity];
             });
            
         } else {
             NSLog(@"Logged in");
             NSLog(@"%@",result);
            
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email, first_name, last_name, gender, link" forKey:@"fields"];
             
//             [parameters setValue:@"id,name,email, first_name, last_name, gender, link, cover,picture, timezone, verified, age_range, updated_time" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id results, NSError *error) {
                  
                  NSLog(@"%@",results);
                  
                  NSMutableDictionary *dict=(NSMutableDictionary *)results;
//                  [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[results objectForKey:@"id"]]
                  
                  
                  [self serverRequest:dict withType:@"facebook"];
                  
              }];
             
         }
     }];
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
    if (error) {
        NSLog(@"Facebook login error");
    }else{
        NSLog(@"Facebook login success");
    }
    
    
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"homePageSegue"]) {
//         HandShakeViewController  *shakeViewCOntoleer=[HandShakeViewController]
     }
     
 }

#pragma mark Google

- (IBAction)googleSignIn:(id)sender {
    [self showActivityWithMessage:nil];
    [[GIDSignIn sharedInstance]signIn];
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //    [myActivityIndicator stopAnimating];
//    [self hideActivity];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.userID,@"id",user.profile.name,@"name",user.profile.givenName,@"first_name",user.profile.familyName,@"last_name",user.profile.email,@"email", nil];
    
    [self serverRequest:dict withType:@"google"];
    
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark Server request

-(void)serverRequest:(NSDictionary *)dict withType:(NSString *)loginType{

    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"is_mobile": @"1", @"api_key":@"!@#%%",@"fbjson":myString};
    
    NSString *dataStr = [NSString stringWithFormat:@"is_mobile=%@&api_key=%@&platform=%@&fbjson=%@",[parameters objectForKey:@"is_mobile"],[parameters objectForKey:@"api_key"],loginType,[parameters objectForKey:@"fbjson"]];
    
    [[Context contextSharedManager] requestPostRequestWithAPI:[NSString stringWithFormat:@"%@%@",BASE_API,SOCIAL_LOGIN_API] withData:dataStr withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
        
        if (error) {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            
            NSLog(@"%@",data);
            
            [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"ID"] forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"user_email"] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"first_name"] forKey:@"first_name"];
            [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"last_name"] forKey:@"last_name"];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SUCCESS_LOGIN];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self performSegueWithIdentifier:@"homePageSegue" sender:nil];
            });
        
        }
    }];

}

@end
