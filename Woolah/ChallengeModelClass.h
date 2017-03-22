//
//  ChallengeModelClass.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeModelClass : NSObject

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSString *user_id;
@property(nonatomic,retain) NSString *owner_id;
@property(nonatomic,retain) NSString *challenge_name;
@property(nonatomic,retain) NSString *challenge_desc;
@property(nonatomic,retain) NSString *challenge_type;
@property(nonatomic,retain) NSString *commit_time;
@property(nonatomic,retain) NSString *Pledge;
@property(nonatomic,retain) NSString *date_created;

@end

//"id":"2",
//"user_id":"157",
//"owner_id":null,
//"challenge_name":"go and statue",
//"challenge_desc":"challenge name is go and statue",
//"challenge_type":"2",
//"commit_time":"4",
//"Pledge":"Pledge is coming soon",
//"date_created":"2017-03-03 12:59:24"
