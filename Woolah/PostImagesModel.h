//
//  PostImagesModel.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostImagesModel : NSObject

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *user_id;
@property(nonatomic,retain)NSString *image_path;
@property(nonatomic,retain)NSString *image_key;
@property(nonatomic,retain)NSString *image_caption;
@property(nonatomic,retain)NSString *group_flag;
@property(nonatomic,retain)NSString *camera_metadata;

@end


/*
 id":"2959",
 "user_id":"773",
 "image_path":"activity\/773\/f5e8301e8ac74fee8dc0f09649bc4d9f\/0ff05b7c944660c06eecf34b7b4e673a",
 "image_key":"f5e8301e8ac74fee8dc0f09649bc4d9f",
 "image_caption":null,
 "group_flag":"0",
 "camera_metadata":null
*/
