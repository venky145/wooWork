//
//  ReactionCollectionView.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReactionDelegate <NSObject>

-(void)handleTouchEventOnReactionWithPath:(NSIndexPath *)selectedPath;

-(void)handleTouchEventOnLocation:(CGPoint)touchPoint withPath:(NSIndexPath *)selectedPath;

@end


@interface ReactionCollectionView : UIView{
    
//    NSMutableArray *rectArray;
}

@property(nonatomic,retain) NSArray *emotionsArray;
@property (nonatomic,weak) id <ReactionDelegate> delegate;
@property(assign) BOOL isLiked;
@property(assign) BOOL isIliked;
@property(nonatomic,retain) UIButton *loveButton;
@property(nonatomic,retain) NSIndexPath *selectedPath;
@property(nonatomic) NSInteger likesCount;

-(void)reloadView;

@end
