//
//  ReactonModelClass.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReactionModelClass : NSObject

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSString *reaction_type;
@property(nonatomic,retain) NSString *reaction_image;
@property(nonatomic,assign) int reaction_count;


@end

//"id":"1",
//"reaction_type":"favorite",
//"reaction_image":"fa-fa heart",
//"reaction_count":0
