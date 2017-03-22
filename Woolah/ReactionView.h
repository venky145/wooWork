//
//  ReactionView.h
//  Woolah
//
//  Created by Apple on 09/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiDelegate <NSObject>

-(void)didSelectEmoji:(NSString *)emojiStr atPath:(NSIndexPath *)emojiPath;

@end

@interface ReactionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *loveView;
@property (weak, nonatomic) IBOutlet UIButton *inspireView;
@property (weak, nonatomic) IBOutlet UIButton *interestView;
@property (weak, nonatomic) IBOutlet UIButton *superbView;
@property (weak, nonatomic) IBOutlet UIButton *notmytypeView;

@property(nonatomic,retain) NSIndexPath *selectedPath;

@property (nonatomic,weak) id <EmojiDelegate> delegate;

- (IBAction)loveAction:(UIButton *)sender;
- (IBAction)inspireAction:(id)sender;
- (IBAction)interestAction:(id)sender;
- (IBAction)superbAction:(id)sender;
- (IBAction)notMyTypeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *mainView;


@end
