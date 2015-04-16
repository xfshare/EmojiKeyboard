//
//  Emoji_ImageView.m
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import "Emoji_ImageView.h"

@implementation Emoji_ImageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addImageViewGesture];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addImageViewGesture];
        
    }
    return self;
}

- (void)addImageViewGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap{
    if ([_emojiDelegate respondsToSelector:@selector(clickImageViewNum:)]) {
        [_emojiDelegate clickImageViewNum:self.num];
    }
}
@end
