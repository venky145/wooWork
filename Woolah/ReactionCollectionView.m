//
//  ReactionCollectionView.m
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import "ReactionCollectionView.h"
#import "ReactionModelClass.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReactionCollectionView

@synthesize loveButton;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];

    }
    return self;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
//    CGPoint location = [recognizer locationInView:[[[[[[[recognizer.view superview] superview]superview]superview]superview]superview]superview]];
//    
//    CGPoint currentLocation = [recognizer locationInView:recognizer.view];
//    
////    CGPoint finalLocation = location.x-(CGFloat)finalLocation.x;
//    
//    CGPoint point=CGPointMake(location.x-currentLocation.x, location.y-currentLocation.y);
//    
//    
//    NSLog(@"location - %f,%f",point.x,point.y);
//
//    
//    if ([self.delegate respondsToSelector:@selector(handleTouchEventOnLocation:withPath:)]) {
//        [self.delegate handleTouchEventOnLocation:point withPath:_selectedPath];
//    }
    
    if ([self.delegate respondsToSelector:@selector(handleTouchEventOnReactionWithPath:)]) {
        [self.delegate handleTouchEventOnReactionWithPath:_selectedPath];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        CGPoint location = [recognizer locationInView:[[[[[[[recognizer.view superview] superview]superview]superview]superview]superview]superview]];
        
        CGPoint currentLocation = [recognizer locationInView:recognizer.view];
        
        //    CGPoint finalLocation = location.x-(CGFloat)finalLocation.x;
        
        CGPoint point=CGPointMake(location.x-currentLocation.x, location.y-currentLocation.y);
        
        
        NSLog(@"location - %f,%f",point.x,point.y);
        
        
        if ([self.delegate respondsToSelector:@selector(handleTouchEventOnLocation:withPath:)]) {
            [self.delegate handleTouchEventOnLocation:point withPath:_selectedPath];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSArray *rectArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:33.0],[NSNumber numberWithDouble:25.0],[NSNumber numberWithDouble:19.0],[NSNumber numberWithDouble:13.0],[NSNumber numberWithDouble:7.0], nil];
    
//    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSMutableArray *countArray=[[NSMutableArray alloc]init];
    
    
    for (int i=0;i<self.emotionsArray.count;i++) {
        
        
        ReactionModelClass *reactionObj=self.emotionsArray[i];
        if (reactionObj.reaction_count>0) {
            [countArray addObject:reactionObj];
            
        }
    }

        NSString *imageStr;
    if (countArray.count>0) {
        
        CGRect finalFrame = CGRectMake(0, 3, 25, 25);
        
        for (int i=0; i<countArray.count; i++) {
            ReactionModelClass *reactionObj=countArray[i];
            
            if ([reactionObj.reaction_type isEqualToString:FAVORITE]) {
                //            imageView.image=[UIImage imageNamed:self.emotionsArray[i]];
                imageStr = @"loveEmoji";
                
            }else if ([reactionObj.reaction_type isEqualToString:INSPIRE]) {
                imageStr = @"inspiringEmoji";
            }else if ([reactionObj.reaction_type isEqualToString:INTEREST]) {
                imageStr = @"interestEmoji";
            }else if ([reactionObj.reaction_type isEqualToString:SUPERB]) {
                imageStr = @"superbEmoji";
            }else if ([reactionObj.reaction_type isEqualToString:NOTMYTYPE]) {
                imageStr = @"notmytypeEmoji";
            }
            
            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
            imageView.frame=CGRectMake( [rectArray[countArray.count-1] floatValue]+(i*10), 3, 25, 25);
        
            finalFrame=imageView.frame;
            [self addSubview:imageView];
            [self sendSubviewToBack:imageView];
        }
        
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(finalFrame)+2, 3, 25, 25)];
//        countLabel.backgroundColor=[UIColor greenColor];
        countLabel.font=[UIFont systemFontOfSize:12];
        countLabel.textColor=[UIColor lightGrayColor];
        
        countLabel.text=[NSString stringWithFormat:@"%ld",(long)_likesCount];
        
        [self addSubview:countLabel];
        
    }
    else{
        loveButton = [[UIButton alloc]initWithFrame:self.frame];
//        if (self.isLiked) {
//             [loveButton setImage:[UIImage imageNamed:@"loveEmoji"] forState:UIControlStateNormal];
//        }else{
             [loveButton setImage:[UIImage imageNamed:@"loveEmoji_unselect"] forState:UIControlStateNormal];
//        }
       
        [loveButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:loveButton];
    }
}
-(void)reloadView{
    [self setNeedsDisplay];
}
-(void)likeAction:(UIButton *)likeButton{
    NSLog(@"like action");
    if ([self.delegate respondsToSelector:@selector(handleTouchEventOnReactionWithPath:)]) {
        [self.delegate handleTouchEventOnReactionWithPath:_selectedPath];
    }
    
}




@end
