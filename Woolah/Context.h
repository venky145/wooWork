//
//  Context.h
//  PDMS
//
//  Created by Venkatesh M on 01/03/17.
//  Copyright © 2017 Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Common.h"

@interface Context : NSObject<NSURLSessionDelegate>

+ (Context *) contextSharedManager;

-(void)makeClearNavigationBar:(UINavigationController *)navController;

-(void)makeBorderUndertextField:(UITextField *)textField withColor:(UIColor *)color;

-(void)roundImageView:(UIImageView *)imgView;

-(void)requestGetRequestWithAPI:(NSString *)apiName withCompletionHandler:(void (^)(NSDictionary *dataDictionary, NSError *error))handler;

-(void)requestPostRequestWithAPI:(NSString *)apiName withData:(NSString *)dataString withCompletionHandler:(void (^)(NSDictionary *data, NSError *error))handler;


- (void)fetchContentsOfURL:(NSURL *)url completion:(void (^)(NSData *data, NSError *error)) completionHandler;

-(void)showAlertView:(UIViewController *)controller withMessage:(NSString *)alertString withAlertTitle:(NSString *)alertTitle;

-(BOOL) checkValidEmail:(NSString *)checkString;

-(NSString *)getAppUserID;

@end
