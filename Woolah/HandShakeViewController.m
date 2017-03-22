//
//  HandShakeViewController.m
//  Woolah
//
//  Created by Apple on 05/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import "HandShakeViewController.h"
#import "PostCustomCell.h"
#import "Context.h"
#import "Common.h"
#import "ReactionView.h"
#import "CustomAlertControllerViewController.h"


#import "AllPostModelClass.h"
#import "PostModelClass.h"
#import "UserModelClass.h"
#import "PostImagesModel.h"
#import "ChallengeModelClass.h"
#import "ReactionModelClass.h"
#import "UIImageView+WebCache.h"
#import <Social/Social.h>

@interface HandShakeViewController ()
{
    NSMutableArray *postsArray;
    AllPostModelClass *allPostModel;
    int currentPageIndex;
    NSInteger selectedButtonIndex;
    NSInteger reloadCellIndexPath;
    PostModelClass *mainPostObj;
    BOOL isReload;
    
    NSAttributedString *nextStr;
}
@end

@implementation HandShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"LoggedIn with facebook");
    }else{
        NSLog(@"Not loggedIn with Facebook");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAplhaValue:) name:@"SetAlpha" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareOption:) name:@"shareOption" object:nil];
    [[Context contextSharedManager] roundImageView:_profileImageView];
       postsArray=[[NSMutableArray alloc]init];
    allPostModel=[[AllPostModelClass alloc]init];
    reloadCellIndexPath = 0;
    _reactionView.layer.cornerRadius=_reactionView.frame.size.height/2;
    _reactionView.layer.masksToBounds=YES;
    _reactionView.delegate=self;
    
    nextStr = [[NSAttributedString alloc] initWithString: @"\n"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.postTableView addGestureRecognizer:tap];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadrequest)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.postTableView setRefreshControl:self.refreshControl];
    
    currentPageIndex=1;
    
    [self.postTableView setTableFooterView:[UIView new]];
    
    self.postTableView.rowHeight = UITableViewAutomaticDimension;
    self.postTableView.estimatedRowHeight = 44.0;
    
    [self refreshControleAction];
}

-(void)viewWillAppear:(BOOL)animated{
//    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
    
}

-(void)refreshControleAction{
    [postsArray removeAllObjects];
    [self.postIndicatorView startAnimating];
    self.postIndicatorView.hidden=NO;
    [self reloadDataFromServer];
}
-(void)reloadrequest{
    reloadCellIndexPath = 0;
    currentPageIndex = 1 ;
    [postsArray removeAllObjects];
    isReload=YES;
    [self reloadDataFromServer];
}
-(void)reloadDataFromServer{

    NSLog(@"Hello");
    
    int indexNumber;
    
    if (isReload) {
        indexNumber = 1;
    }else{
        indexNumber = currentPageIndex;
    }
    
    NSString *urlStr= [NSString stringWithFormat:@"%@/l5-api/activity/allpost?id=1&is_challenge=1&thisPage=%d&postLimit=10",BASE_API,indexNumber];
    
    [[Context contextSharedManager] requestGetRequestWithAPI:urlStr withCompletionHandler:^(NSDictionary *dataDictionary, NSError *error) {
        if (error) {
            [self.postIndicatorView stopAnimating];
            self.postIndicatorView.hidden=YES;
        }else{
            allPostModel.postStatus = [[dataDictionary objectForKey:@"status"] boolValue];
            allPostModel.activityCount=[dataDictionary objectForKey:@"activity_count"];
            
            NSArray *getPosts=[dataDictionary objectForKey:@"0"];
            
            NSUInteger index = 0;
            
            for (NSDictionary *postDict in getPosts) {
                PostModelClass *postObject=[[PostModelClass alloc]init];
                for (NSString *key in postDict) {
                    if ([postObject respondsToSelector:NSSelectorFromString(key)]) {
                    
                        if ([postDict valueForKey:key] != NULL) {
                            if ([key isEqualToString:@"user_details"]) {
                                UserModelClass *userObject = [[UserModelClass alloc]init];
                                NSDictionary *userDict = [postDict valueForKey:key];
                                
                                for (NSString *key in userDict){
                                    if ([userObject respondsToSelector:NSSelectorFromString(key)]) {
                                        
                                        if ([userDict valueForKey:key] != NULL) {
                                            [userObject setValue:[userDict valueForKey:key] forKey:key];
                                        }else{
                                        [userObject setValue:@"" forKey:key];
                                            }
                                        }
                                    }
                                [postObject setValue:userObject forKey:key];
                            }else if ([key isEqualToString:@"postimages"]){
                                NSMutableArray *imageObjArray=[[NSMutableArray alloc]init];
                                NSArray *imageArray = [postDict valueForKey:key];
                                for (NSDictionary *imagesDict in imageArray) {
                                    PostImagesModel *postImageObject = [[PostImagesModel alloc]init];
                                    for (NSString *key in imagesDict){
                                        if ([postImageObject respondsToSelector:NSSelectorFromString(key)]) {
                                            
                                            if ([imagesDict valueForKey:key] != NULL) {
                                                [postImageObject setValue:[imagesDict valueForKey:key] forKey:key];
                                            }else{
                                                [postImageObject setValue:@"" forKey:key];
                                            }
                                        }
                                    }
                                     [imageObjArray addObject:postImageObject];
                                    
                                }
                                
                                [postObject setValue:imageObjArray forKey:key];
                            }else if ([key isEqualToString:@"challenge_object"]){
                                
                                    NSDictionary *challengeDict = [postDict valueForKey:key];
                                    ChallengeModelClass *challengeObject = [[ChallengeModelClass alloc]init];
                                    for (NSString *key in challengeDict){
                                        if ([challengeObject respondsToSelector:NSSelectorFromString(key)]) {
                                            
                                            if ([challengeDict valueForKey:key] != NULL) {
                                                [challengeObject setValue:[challengeDict valueForKey:key] forKey:key];
                                            }else{
                                                [challengeObject setValue:@"" forKey:key];
                                            }
                                        }
                                    }
    
                                [postObject setValue:challengeObject forKey:key];
                            }else if ([key isEqualToString:@"all_reactions"]){
                                NSMutableArray *reactionArray=[[NSMutableArray alloc]init];
                                NSArray *getReactionArray = [postDict valueForKey:key];
                                for (NSDictionary *reactionDict in getReactionArray) {
                                    ReactionModelClass *reactionObj = [[ReactionModelClass alloc]init];
                                    for (NSString *key in reactionDict){
                                        if ([reactionObj respondsToSelector:NSSelectorFromString(key)]) {
                                            
                                            if ([reactionDict valueForKey:key] != NULL) {
                                                [reactionObj setValue:[reactionDict valueForKey:key] forKey:key];
                                            }else{
                                                [reactionObj setValue:@"" forKey:key];
                                            }
                                        }
                                    }
                                    [reactionArray addObject:reactionObj];
                                    
                                }
                                
                                [postObject setValue:reactionArray forKey:key];
                            }

                            else{
                                [postObject setValue:[postDict valueForKey:key] forKey:key];
                            }
                        }else{
                            [postObject setValue:@"" forKey:key];
                        }
                    }
                }
                if (isReload) {
                    
                    [postsArray insertObject:postObject atIndex:index];
            
                }else{
                   [postsArray addObject:postObject];
                }
                index ++;
            }
            if (postsArray.count>0) {
                
                if (isReload){
                    isReload=NO;
                }
                allPostModel.posts=[postsArray mutableCopy];
            }
            
            NSArray *detailsArray=[dataDictionary objectForKey:@"thisUserDetails"];
            if (detailsArray.count>0) {
                NSDictionary *getUserDict=[detailsArray objectAtIndex:0];
                UserModelClass *userObject=[[UserModelClass alloc]init];
                for (NSString *key in getUserDict) {
                    if ([userObject respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([getUserDict valueForKey:key] != NULL) {
                            [userObject setValue:[getUserDict valueForKey:key] forKey:key];
                        }else{
                            [userObject setValue:@"" forKey:key];
                        }
                    }
                }
                
                allPostModel.userDetails=userObject;
            
                 [_profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,allPostModel.userDetails.user_profile_image]] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.postIndicatorView stopAnimating];
                self.postIndicatorView.hidden=YES;
                [self.refreshControl endRefreshing];
                [self.postTableView reloadData];
            
            });
        }
    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allPostModel.posts.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"postCell";
    
    PostCustomCell *cell=(PostCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    PostModelClass *postObject = [allPostModel.posts objectAtIndex:indexPath.row];
    
    cell.profileName.text=postObject.user_details.display_name;
    cell.hashTagName.text=[NSString stringWithFormat:@"#%@",postObject.challenge_object.challenge_name];
   
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[postObject.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    if (attrStr.length<=1) {
        cell.contentLabel.text=@"";
    }else
        cell.contentLabel.attributedText=attrStr;
    
    PostImagesModel *imageObj=postObject.postimages[0];
    
    UserModelClass *userObj = postObject.user_details;
    
    NSString *postImageUrl=[NSString stringWithFormat:@"%@%@",POST_IMAGE_URL,imageObj.image_path];
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:userObj.user_profile_image] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    [cell.postImageView sd_setImageWithURL:[NSURL URLWithString:postImageUrl] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    [cell.commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)postObject.comments_count] forState:UIControlStateNormal];
    
    if (postObject.like_count>0) {
        cell.emojiView.emotionsArray=postObject.all_reactions;
        cell.emojiView.likesCount=postObject.like_count;
    }
    
    cell.emojiView.delegate=self;
    cell.emojiView.selectedPath=indexPath;
    
    [cell.emojiView setNeedsDisplay];

    [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tag=indexPath.row;
    [cell.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareButton.tag=indexPath.row;
    [cell.reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.reportButton.tag=indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==allPostModel.posts.count-1){
        currentPageIndex+=1;
        if (reloadCellIndexPath != indexPath.row) {
            reloadCellIndexPath=indexPath.row;
            [self reloadDataFromServer];
        }
    }
}

#pragma mark ReactionDelegate

//reaction button Delegate
-(void)handleTouchEventOnReactionWithPath:(NSIndexPath *)selectedPath{
    
    if (_reactionView.hidden==NO) {
        _reactionView.hidden=YES;
    }else{
    
    
    mainPostObj=[allPostModel.posts objectAtIndex:selectedPath.row];
    
    int likeStatus=1;
    int reactionType = 1;
    
    if ([mainPostObj.my_reaction isKindOfClass:[NSNull class]]) {
//            selectedCell.emojiView.isLiked=YES;
            likeStatus = 0;

    }else{
        
        if ([mainPostObj.my_reaction isEqualToString:FAVORITE]) {
            
            reactionType = favorite;
            
        }else if ([mainPostObj.my_reaction isEqualToString:INTEREST]) {
            reactionType = interesting;
            
        }else if ([mainPostObj.my_reaction isEqualToString:INSPIRE]) {
            reactionType = inspiring;
            
        }else if ([mainPostObj.my_reaction isEqualToString:SUPERB]) {
            reactionType = superb;
            
        }else if ([mainPostObj.my_reaction isEqualToString:NOTMYTYPE]) {
            reactionType = notmytype;
            
        }
        
        likeStatus=1;
    }

    NSString *likeStr=[NSString stringWithFormat:@"user_id=%@&activity_id=%@&reaction_type=%ld&unlike=%ld",[[Context contextSharedManager] getAppUserID],mainPostObj.id,(long)reactionType,(long)likeStatus];
    
    [self likeRequest:likeStr withIndex:selectedPath];
    }
}
//reaction Location delegate
-(void)handleTouchEventOnLocation:(CGPoint)touchPoint withPath:(NSIndexPath *)selectedPath{
    
     mainPostObj=[allPostModel.posts objectAtIndex:selectedPath.row];
    
    if (_reactionView.hidden) {
        CGRect rect=_reactionView.frame;
        rect.origin.x=10;
        
        if (touchPoint.y >154) {
            rect.origin.y=touchPoint.y-rect.size.height-10;
        }else{
            rect.origin.y=touchPoint.y+10;
        }
        _reactionView.frame=rect;
        _reactionView.selectedPath=selectedPath;
        _reactionView.hidden=NO;
    }else{
       _reactionView.hidden=YES;
    }
}
-(void)likeRequest:(NSString *)parseStr withIndex:(NSIndexPath *)selectedPath{
    
    PostCustomCell *selectedCell = [_postTableView cellForRowAtIndexPath:selectedPath];
    
    [[Context contextSharedManager] requestPostRequestWithAPI:[NSString stringWithFormat:@"%@%@",BASE_API,LIKE_POST_API] withData:parseStr withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        if (error) {
            
        }else{

            
            BOOL statusStr = [data objectForKey:@"status"];
            if (statusStr) {
                
                NSArray *postArray = [data objectForKey:@"post_details"];
                
                //            NSDictionary *postDict = [dictionary objectForKey:@"0"];
                
                PostModelClass *postObject=[allPostModel.posts objectAtIndex:selectedPath.row];
                
                            NSLog(@"post_id %@",postObject.post_id);
                
                for (NSDictionary *keyDict in postArray) {
                    
                    postObject.like_count=[[data objectForKey:@"like_count"] intValue];
                    postObject.my_reaction=[keyDict objectForKey:@"my_reaction"];
                    NSArray *reactionsArray=[keyDict objectForKey:@"all_reactions"];
                    
                    NSMutableArray *reactionArray=[[NSMutableArray alloc]init];
                    
                    for (NSDictionary *reactionDict in reactionsArray) {
                        ReactionModelClass *reactionObj = [[ReactionModelClass alloc]init];
                        for (NSString *key in reactionDict){
                            if ([reactionObj respondsToSelector:NSSelectorFromString(key)]) {
                                
                                if ([reactionDict valueForKey:key] != NULL) {
                                    [reactionObj setValue:[reactionDict valueForKey:key] forKey:key];
                                }else{
                                    [reactionObj setValue:@"" forKey:key];
                                }
                            }
                        }
                        [reactionArray addObject:reactionObj];
                        
                    }
                    
                    [postObject setValue:reactionArray forKey:@"all_reactions"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                [self showActivityWithMessage:@""];
                    //[selectedCell.emojiView setNeedsDisplay];
//                    [self.postTableView beginUpdates];
//                    [self.postTableView reloadRowsAtIndexPaths:@[selectedPath] withRowAnimation:UITableViewRowAnimationNone];
//                    [self.postTableView endUpdates];
                    
//                    postObject.like_count>0{
//                        
//                    }
                    
                    selectedCell.emojiView.emotionsArray=postObject.all_reactions;
                    selectedCell.emojiView.likesCount=postObject.like_count;
                    [selectedCell.emojiView setNeedsDisplay];
                    
                });
                
            }
//
//                for (NSString *key in keyDict) {
//
//                if ([postObject respondsToSelector:NSSelectorFromString(key)]) {
//
//                    if ([data valueForKey:key] != NULL) {
//                        if ([key isEqualToString:@"user_details"]) {
//                            UserModelClass *userObject = [[UserModelClass alloc]init];
//                            NSDictionary *userDict = [data valueForKey:key];
//                            
//                            for (NSString *key in userDict){
//                                if ([userObject respondsToSelector:NSSelectorFromString(key)]) {
//                                    
//                                    if ([userDict valueForKey:key] != NULL) {
//                                        [userObject setValue:[userDict valueForKey:key] forKey:key];
//                                    }else{
//                                        [userObject setValue:@"" forKey:key];
//                                    }
//                                }
//                            }
//                            [postObject setValue:userObject forKey:key];
//                        }else if ([key isEqualToString:@"postimages"]){
//                            NSMutableArray *imageObjArray=[[NSMutableArray alloc]init];
//                            NSArray *imageArray = [data valueForKey:key];
//                            for (NSDictionary *imagesDict in imageArray) {
//                                PostImagesModel *postImageObject = [[PostImagesModel alloc]init];
//                                for (NSString *key in imagesDict){
//                                    if ([postImageObject respondsToSelector:NSSelectorFromString(key)]) {
//                                        
//                                        if ([imagesDict valueForKey:key] != NULL) {
//                                            [postImageObject setValue:[imagesDict valueForKey:key] forKey:key];
//                                        }else{
//                                            [postImageObject setValue:@"" forKey:key];
//                                        }
//                                    }
//                                }
//                                [imageObjArray addObject:postImageObject];
//                                
//                            }
//                            
//                            [postObject setValue:imageObjArray forKey:key];
//                        }else if ([key isEqualToString:@"challenge_object"]){
//                            
//                            NSDictionary *challengeDict = [data valueForKey:key];
//                            ChallengeModelClass *challengeObject = [[ChallengeModelClass alloc]init];
//                            for (NSString *key in challengeDict){
//                                if ([challengeObject respondsToSelector:NSSelectorFromString(key)]) {
//                                    
//                                    if ([challengeDict valueForKey:key] != NULL) {
//                                        [challengeObject setValue:[challengeDict valueForKey:key] forKey:key];
//                                    }else{
//                                        [challengeObject setValue:@"" forKey:key];
//                                    }
//                                }
//                            }
//                            
//                            [postObject setValue:challengeObject forKey:key];
//                        }else if ([key isEqualToString:@"all_reactions"]){
//                            NSMutableArray *reactionArray=[[NSMutableArray alloc]init];
//                            NSArray *getReactionArray = [data valueForKey:key];
//                            for (NSDictionary *reactionDict in getReactionArray) {
//                                ReactionModelClass *reactionObj = [[ReactionModelClass alloc]init];
//                                for (NSString *key in reactionDict){
//                                    if ([reactionObj respondsToSelector:NSSelectorFromString(key)]) {
//                                        
//                                        if ([reactionDict valueForKey:key] != NULL) {
//                                            [reactionObj setValue:[reactionDict valueForKey:key] forKey:key];
//                                        }else{
//                                            [reactionObj setValue:@"" forKey:key];
//                                        }
//                                    }
//                                }
//                                [reactionArray addObject:reactionObj];
//                                
//                            }
//                            
//                            [postObject setValue:reactionArray forKey:key];
//                        }
//                        
//                        else{
//                            [postObject setValue:[data valueForKey:key] forKey:key];
//                        }
//                    }else{
//                        [postObject setValue:@"" forKey:key];
//                    }
//                }
//            }
//            }
            
//            [postsArray replaceObjectAtIndex:selectedPath.row withObject:postObject];
//            allPostModel.posts=postsArray;
            
          
        }
    }];
}

-(void)didSelectEmoji:(NSString *)emojiStr atPath:(NSIndexPath *)emojiPath;{
    
    _reactionView.hidden=YES;
    
    int reactionType ;
    
    if ([emojiStr isEqualToString:FAVORITE]) {
        
        reactionType = favorite;
        
    }else if ([emojiStr isEqualToString:INTEREST]) {
        reactionType = interesting;
        
    }else if ([emojiStr isEqualToString:INSPIRE]) {
        reactionType = inspiring;
        
    }else if ([emojiStr isEqualToString:SUPERB]) {
        reactionType = superb;
        
    }else if ([emojiStr isEqualToString:NOTMYTYPE]) {
        reactionType = notmytype;
        
    }
    

    
    NSString *likeStr=[NSString stringWithFormat:@"user_id=%@&activity_id=%@&reaction_type=%ld&unlike=0",[[Context contextSharedManager] getAppUserID],mainPostObj.id,(long)reactionType];
    
    [self likeRequest:likeStr withIndex:emojiPath];
    
}

-(void)commentAction:(UIButton *)commentButton{
    
    NSLog(@"Comment action");
    
}
-(void)shareAction:(UIButton *)shareButton{

    selectedButtonIndex=shareButton.tag;
    
    CustomAlertControllerViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"customAlert"];;
    self.view.alpha=0.7;
    modalVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.definesPresentationContext=YES;
    [self presentViewController:modalVC animated:NO completion:nil];

}
-(void)setAplhaValue:(NSNotification *)notification{
    self.view.alpha=1;
}
-(void)shareOption:(NSNotification *)notification{
    self.view.alpha=1;
    mainPostObj = [allPostModel.posts objectAtIndex:selectedButtonIndex];
    PostImagesModel *imageObj = [mainPostObj.postimages objectAtIndex:0];

    if ([notification.object isEqualToString:@"Facebook"]) {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
         if (mainPostObj.short_url.length>0) {
         content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_API,mainPostObj.short_url]];
         }
         content.contentDescription = mainPostObj.plain_content;
         content.contentTitle=imageObj.image_caption;
        NSString *pathString = [NSString stringWithFormat:@"%@%@",POST_IMAGE_URL,imageObj.image_path];

        [pathString stringByRemovingPercentEncoding];
                 content.imageURL=[NSURL URLWithString:pathString];
        
//        content.imageURL=[NSURL URLWithString:@"http://images.woolah.co.s3-website-us-west-2.amazonaws.com/activity/669/168c419421f1e8a28b41901f3821b203/DSC_4150.jpg"];
        
        FBSDKShareDialog *dialog= [[FBSDKShareDialog alloc]init];
        
        dialog.delegate=self;
         dialog.fromViewController = self;
         dialog.shareContent = content;
         dialog.mode = FBSDKShareDialogModeShareSheet;
        if (!dialog.canShow) {
            dialog.mode = FBSDKShareDialogModeFeedWeb;
        }
         [dialog show];
    }else if ([notification.object isEqualToString:@"Twitter"]){
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            NSString *twitterText=[NSString stringWithFormat:@"%@ @my_woolah",mainPostObj.plain_content];
            
            [tweetSheet setInitialText:twitterText];
            
//            UIImageView *tweetImage;
//            [tweetImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POST_IMAGE_URL,imageObj.image_path]]];
            
//            [tweetSheet addImage:tweetImage.image];
            
            [tweetSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_API,mainPostObj.short_url]]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else{
            [[Context contextSharedManager] showAlertView:self withMessage:@"Please login to a twitter to tweet" withAlertTitle:@"Twitter"];
        }
        
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results;

{
 NSLog(@"facebook Share success");
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error;

{
    NSLog(@"facebook Share failed");
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"facebook Share Cancelled");
}

-(void)reportAction:(UIButton *)reportButton{
    
    mainPostObj=[allPostModel.posts objectAtIndex:reportButton.tag];

    NSString *dataStr=[NSString stringWithFormat:@"id=%@&activity_id=%@",[[Context contextSharedManager] getAppUserID],mainPostObj.id];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Report" message:@"Do you really want to report the issue"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
     UIAlertAction* done = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         dispatch_async(dispatch_get_main_queue(), ^{
             
              [self showActivityWithMessage:@""];
         });
         [[Context contextSharedManager] requestPostRequestWithAPI:[NSString stringWithFormat:@"%@%@",BASE_API,REPORT_API] withData:dataStr withCompletionHandler:^(NSDictionary *data, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                  [self hideActivity];
             });
            
             if (error) {

             }else{
                 
                 NSLog(@"%@",data);
                 
                 [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:@"msg"] withAlertTitle:nil];
             }
         }];
         
     }];
    [alertController addAction:ok];
    [alertController addAction:done];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}
//ScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_reactionView.hidden) {
        _reactionView.hidden=YES;
    }
}
//Touch Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_reactionView.hidden) {
        _reactionView.hidden=YES;
    }
}

-(void)didTapOnTableView:(UITapGestureRecognizer *)recognizer{
    if (!_reactionView.hidden) {
        _reactionView.hidden=YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
