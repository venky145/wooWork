//
//  AppDelegate.h
//  Woolah
//
//  Created by Venkatesh M on 04/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

