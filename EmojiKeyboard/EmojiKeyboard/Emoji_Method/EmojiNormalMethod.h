//
//  EmojiNormalMethod.h
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Emoji_Keyboard_ToolView.h"

@protocol EmojiNormalMethodDelegate <NSObject>

@optional
- (void)getNormalEmoji:(NSString *)emoji kit:(id)kit;
- (void)emojiDeleteEvent:(id)kit;
@end;

@interface EmojiNormalMethod : NSObject
@property (nonatomic,strong)Emoji_Keyboard_ToolView *toolView;
@property (nonatomic,assign)id<EmojiNormalMethodDelegate>normalDelegate;

- (instancetype)initWithBecomeFirstResponder:(NSArray *)sender;
- (instancetype)initWithBecomeFirstResponder:(NSArray *)sender onView:(UIView *)view;
- (void)ishidden;
- (void)isRemoveWhenVCDisappear;
@end
