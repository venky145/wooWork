//
//  PostCustomCell.m
//  Woolah
//
//  Created by Apple on 07/03/17.
//  Copyright © 2017 Luecas Aspera Technologies Pvt Ltd. All rights reserved.
//

#import "PostCustomCell.h"
#import "Context.h"

@implementation PostCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[Context contextSharedManager] roundImageView:_profileImage];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
