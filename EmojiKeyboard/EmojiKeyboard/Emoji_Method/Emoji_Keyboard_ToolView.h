//
//  Emoji_Keyboard_ToolView.h
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji_Keyboard_View.h"

@protocol Emoji_Keyboard_ToolViewDelegate <NSObject>

@optional
- (void)getEmoji:(NSString *)emoji;
- (void)getEmoji:(NSString *)emoji kit:(id)kit;
- (void)emojiDeleteEventOnKit:(id)kit;
@end

@interface Emoji_Keyboard_ToolView : UIView
@property (nonatomic,strong)Emoji_Keyboard_View *emojiView;
@property (nonatomic,assign)id<Emoji_Keyboard_ToolViewDelegate>toolDelegate;
- (instancetype)initWithFrame:(CGRect)frame responder:(NSArray *)responderArr onView:(UIView *)view;
@end
