//
//  PostModelClass.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModelClass.h"
#import "ChallengeModelClass.h"

@interface PostModelClass : NSObject

@property(nonatomic,strong) NSString *post_id;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSArray *comments;
@property(nonatomic,strong) NSArray *postimages;
@property(nonatomic,strong) NSArray *all_reactions;
@property(nonatomic) NSInteger like_count;
@property(nonatomic,strong) UserModelClass *user_details;
@property(nonatomic,strong) ChallengeModelClass *challenge_object;
@property(nonatomic,strong) NSArray *reactionObjectArray;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *date_recorded;
@property(nonatomic) NSInteger comments_count;
@property(nonatomic,strong) NSString *plain_content;
@property(nonatomic,strong) NSString *short_url;
@property(nonatomic,strong) NSString *i_liked;
@property(nonatomic,strong) NSString *my_reaction;

@end


/*
 "post_id":"2489",
 "id":"14887268131601",
 "user_id":"773",
 "content":"<div class=\"extended-post\"><\/div>",
 "comments":[],
 "postimages":[],
 "all_reactions":[],
 "like_count":0,
 "user_details":{},
 "address":"Add Location",
 "date_recorded":"2017-03-05 20:43:33",
 */
