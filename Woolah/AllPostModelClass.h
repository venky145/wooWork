//
//  AllPostModelClass.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModelClass.h"

@interface AllPostModelClass : NSObject

@property(nonatomic,strong) UserModelClass *userDetails;
@property(nonatomic,strong) NSString *activityCount;
@property(nonatomic,strong) NSArray *posts;
@property(nonatomic) BOOL postStatus;


@end
