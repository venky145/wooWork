//
//  Common.h
//  Woolah
//
//  Created by Apple on 07/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define BASE_API @"http://code1.woolah.co/"

#define SOCIAL_LOGIN_API @"/hauth/index"
//http;//code1.woolah.co/
#define  IMAGE_URL @"http://code1.woolah.co/"

#define  POST_IMAGE_URL @"http://images.woolah.co.s3-website-us-west-2.amazonaws.com/"

#define REPORT_API @"l5-api/activity/report"
#define LIKE_POST_API @"l5-api/activity/like"

#define SUCCESS_LOGIN @"success_login"



//Reaction Images

typedef enum
{
     favorite = 1,
     interesting,
     inspiring,
     superb,
     notmytype,
} REACTIONS;

#define FAVORITE @"favorite"
#define INTEREST @"interesting"
#define INSPIRE @"inspiring"
#define SUPERB @"superb"
#define NOTMYTYPE @"not my type"



#endif /* Common_h */
