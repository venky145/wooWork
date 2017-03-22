//
//  ReactionView.m
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import "ReactionView.h"
#import "Common.h"

@implementation ReactionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ReactionView" owner:self options:nil] objectAtIndex:0]];
    }
    return self;
}

- (IBAction)loveAction:(UIButton *)sender {
    
    NSLog(@"love");
    //for zoom in
   //    [UIView animateWithDuration:0.5f animations:^{
//        sender.transform = CGAffineTransformMakeScale(1, 1);
//        
//    }];
    
    [self showTransition:sender withString:@"love"];
   
}


-(void)showTransition:(UIButton *)button withString:(NSString *)emojiString{
    [UIView animateWithDuration:0.5f animations:^{
        button.transform = CGAffineTransformMakeScale(3, 3);
    }];
    
    // for zoom out
    [UIView animateWithDuration:0.5f animations:^{
        button.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self delegateCall:emojiString atPath:_selectedPath];
    }];
    

}

- (IBAction)inspireAction:(id)sender {
    
    [self showTransition:sender withString:INSPIRE];
}

- (IBAction)interestAction:(id)sender {
    [self showTransition:sender withString:INTEREST];
}

- (IBAction)superbAction:(id)sender {
    [self showTransition:sender withString:SUPERB];
}

- (IBAction)notMyTypeAction:(id)sender {
    [self showTransition:sender withString:NOTMYTYPE];
}


-(void)delegateCall:(NSString *)emojiStr atPath:(NSIndexPath *)emojiPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectEmoji:atPath:)]) {
        [self.delegate didSelectEmoji:emojiStr atPath:_selectedPath];
    }
}

@end
