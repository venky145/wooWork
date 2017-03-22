//
//  HandShakeViewController.h
//  Woolah
//
//  Created by Apple on 05/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactionCollectionView.h"
#import "ReactionView.h"
#import "ActivityBaseViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface HandShakeViewController : ActivityBaseViewController<ReactionDelegate,EmojiDelegate,NSURLSessionDelegate,FBSDKSharingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UITableView *postTableView;

@property (weak, nonatomic) IBOutlet ReactionView *reactionView;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *postIndicatorView;



@end
