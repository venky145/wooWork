//
//  Context.m
//  PDMS
//
//  Created by Venkatesh M on 01/03/17.
//  Copyright © 2017 Venkatesh. All rights reserved.
//

#import "Context.h"
#import <UIKit/UIKit.h>

@implementation Context

static Context *contextManager_instance = nil;

+ (Context *)contextSharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contextManager_instance = [[self alloc] init];
    });
    return contextManager_instance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}
-(void)makeClearNavigationBar:(UINavigationController *)navController
{
    
    [navController.navigationBar setHidden:NO];
    navController.navigationBar.barStyle = 1;
    [navController.navigationBar setBackgroundImage:[UIImage new]
                                      forBarMetrics:UIBarMetricsDefault];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.translucent = YES;
    navController.view.backgroundColor = [UIColor clearColor];
    navController.navigationBar.backgroundColor = [UIColor clearColor];
    [navController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
-(void)makeBorderUndertextField:(UITextField *)textField withColor:(UIColor *)color{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;

}
-(void)requestGetRequestWithAPI:(NSString *)apiName withCompletionHandler:(void (^)(NSDictionary *dataDictionary, NSError *error))handler{
    NSURL *URL = [NSURL URLWithString:apiName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:&error];
    //    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (handler == nil) {
            return;
        }
        if (error) {
            handler(nil, error);
            return;
        }
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@", dataJSON);
        NSString * converted =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", converted);
        
        handler(dataJSON, nil);
        
    }];
    [dataTask resume];    
}
;

-(void)requestPostRequestWithAPI:(NSString *)apiName withData:(NSString *)dataString withCompletionHandler:(void (^)(NSDictionary *data, NSError *error))handler{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:apiName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0]; 
    
//    NSString *dataStr = [NSString stringWithFormat:@"is_mobile=%@&api_key=%@&fbjson=%@",[dict objectForKey:@"is_mobile"],[dict objectForKey:@"api_key"],[dict objectForKey:@"fbjson"]];
    
    NSData *postData = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [request setValue:dataString forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (handler == nil) {
            return;
        }
        if (error) {
            handler(nil, error);
            return;
        }
        
        //        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
        
        NSLog(@"Success");
        
        handler(json, nil);
        
    }];
    
    [postDataTask resume];
}

- (void)fetchContentsOfURL:(NSURL *)url
                completion:(void (^)(NSData *data, NSError *error)) completionHandler{
    
}

-(void)showAlertView:(UIViewController *)controller withMessage:(NSString *)alertString withAlertTitle:(NSString *)alertTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) checkValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)roundImageView:(UIImageView *)imgView
{
    imgView.layer.cornerRadius=imgView.frame.size.height/2;
    imgView.layer.masksToBounds=YES;
    imgView.clipsToBounds=YES;
}

-(NSString *)getAppUserID{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] == nil) {
        return nil;
    }else
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

@end
