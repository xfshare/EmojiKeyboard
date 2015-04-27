//
//  Emoji_Keyboard_View.h
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Emoji_Keyboard_ViewDelegate <NSObject>
@optional
- (void)getEmojiKey:(NSString *)emoji;
- (void)emojiKeyboardViewtransform:(CGAffineTransform)transform;
- (void)emojikeyboardDeleteEvent;
@end

@interface Emoji_Keyboard_View : UIView
@property (nonatomic,assign)id<Emoji_Keyboard_ViewDelegate>keyDelegate;
@property (nonatomic,assign)__block BOOL showing;

- (void)isshow;
- (void)ishidden;
@end
