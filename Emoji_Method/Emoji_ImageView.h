//
//  Emoji_ImageView.h
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Emoji_ImageViewDelegate <NSObject>

- (void)clickImageViewNum:(NSUInteger)num;

@end

@interface Emoji_ImageView : UIImageView
@property (nonatomic,assign)NSUInteger num;
@property (nonatomic,assign)id <Emoji_ImageViewDelegate>emojiDelegate;
@end
