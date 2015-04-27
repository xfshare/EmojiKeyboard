//
//  Emoji_Keyboard_ToolView.m
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import "Emoji_Keyboard_ToolView.h"

#define Emoji_Btn_W 40
@interface Emoji_Keyboard_ToolView ()<Emoji_Keyboard_ViewDelegate>
{
    NSArray *needShowEmojiArr;
    id currentResponderKit;
    CGAffineTransform curTransfrom;
    UIView *onView;
    UIButton *emojiBtn;
}
@property (nonatomic,strong)NSArray * firstResponderArr;//那些控件,需要显示emoji


@end


@implementation Emoji_Keyboard_ToolView
@synthesize emojiView;
- (instancetype)initWithFrame:(CGRect)frame responder:(NSArray *)responderArr onView:(UIView *)view{
    self = [super initWithFrame:frame];
    if (self) {
        onView = view;
        [self buildEmojiBtn];
        needShowEmojiArr = responderArr;
        [self registerNotification];
    }
    return self;
}


- (void)buildEmojiBtn{
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiBtn.frame = CGRectMake(CGRectGetMaxX(self.frame) - Emoji_Btn_W - 10, 0, Emoji_Btn_W, Emoji_Btn_W);
    [emojiBtn setImage:[UIImage imageNamed:@"ico_expression"] forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emojiBtn];
    
}
#define Skip_Keyboard_Hidden_Action_Notification @"Skip_Keyboard_Hidden_Action_Notification"
- (void)emojiBtnAction:(id)sender{
    
    for (UIView *view in needShowEmojiArr) {
        if (view.isFirstResponder) {
            
            currentResponderKit = view;
            if (!emojiView) {
                emojiView = [[Emoji_Keyboard_View alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetHeight([[UIScreen mainScreen] bounds]),
                                                                                  CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                                                                  216)];
                [[UIApplication sharedApplication].keyWindow addSubview:emojiView];
                emojiView.keyDelegate = self;
                
            }
            break;
        }
    }
    
    
    if (!emojiView.showing) {
        curTransfrom = self.transform;
        [emojiView isshow];
        [[NSNotificationCenter defaultCenter] postNotificationName:Skip_Keyboard_Hidden_Action_Notification object:nil];
        [currentResponderKit resignFirstResponder];

        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformMakeTranslation(0,-CGRectGetHeight(emojiView.frame)-CGRectGetHeight(self.frame));
                             
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [emojiBtn setImage:[UIImage imageNamed:@"ico_keyboard"] forState:UIControlStateNormal];

        
    }
    else{
        [emojiBtn setImage:[UIImage imageNamed:@"ico_expression"] forState:UIControlStateNormal];
        [emojiView ishidden];
        [currentResponderKit becomeFirstResponder];
    }

    
}

- (void)registerNotification{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    
}
- (void)keyboardShow:(NSNotification *)notification{

    [emojiBtn setImage:[UIImage imageNamed:@"ico_expression"] forState:UIControlStateNormal];

}


- (void)setTransform:(CGAffineTransform)transform{
    [super setTransform:transform];
    
    if (transform.ty == 0) {
        [emojiBtn setImage:[UIImage imageNamed:@"ico_expression"] forState:UIControlStateNormal];

    }
}

- (void)getEmojiKey:(NSString *)emoji{
    
    if ([_toolDelegate respondsToSelector:@selector(getEmoji:kit:)]){
        [_toolDelegate getEmoji:emoji kit:currentResponderKit];
    }
    
}

- (void)emojikeyboardDeleteEvent{
    if ([_toolDelegate respondsToSelector:@selector(emojiDeleteEventOnKit:)]){
        [_toolDelegate emojiDeleteEventOnKit:currentResponderKit];
    }

}

@end
