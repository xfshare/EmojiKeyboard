//
//  EmojiNormalMethod.m
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

/**
 *  onview 废弃 tabbar会挡住
 *  toolView 和 emoji 放到window 上,
 *  需要在viewdisapper中调用 isRemoveWhenVCDisappear ,清空
 *  @return <#return value description#>
 */

#import "EmojiNormalMethod.h"

#define Skip_Keyboard_Hidden_Action_Notification @"Skip_Keyboard_Hidden_Action_Notification"

@interface EmojiNormalMethod()<Emoji_Keyboard_ToolViewDelegate>
{
    CGRect showKeyboard;
    UIView *onView;
    __block BOOL skip;
}
@property (nonatomic,strong)NSArray * firstResponderArr;//那些控件,需要显示emoji
@end

@implementation EmojiNormalMethod
- (instancetype)initWithBecomeFirstResponder:(NSArray *)sender onView:(UIView *)view{
    self = [super init];
    if (self) {
        onView = view;
        _firstResponderArr = sender;
        [self registerNotification];
    }
    return self;
}
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeFirstResponderNotification:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeFirstResponderNotification:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboarkHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipKeyboard)
                                                 name:Skip_Keyboard_Hidden_Action_Notification
                                               object:nil];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:Skip_Keyboard_Hidden_Action_Notification
                                                  object:nil];


}

- (void)ishidden{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _toolView.transform = CGAffineTransformMakeTranslation(0,0);
                         [_toolView.emojiView ishidden];
                         
                     } completion:^(BOOL finished) {
                         
                     }];

}

- (void)isRemoveWhenVCDisappear{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _toolView.transform = CGAffineTransformMakeTranslation(0,0);
                         [_toolView.emojiView ishidden];
                         
                         [_toolView.emojiView removeFromSuperview];
                         [_toolView removeFromSuperview];
                         _toolView = nil;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void)becomeFirstResponderNotification:(NSNotification *)notification{
    id obj = notification.object;
   
    //如果满足,emoji弹出的toolview
    if ([_firstResponderArr containsObject:obj]) {
        
        if (!_toolView) {
            _toolView = [[Emoji_Keyboard_ToolView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetHeight([[UIScreen mainScreen] bounds]),
                                                                                  CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                                                                  40)
                                                             responder:_firstResponderArr
                                                                onView:onView];
            _toolView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
            _toolView.toolDelegate  = self;
            [[UIApplication sharedApplication].keyWindow addSubview:_toolView];
        }
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _toolView.transform = CGAffineTransformMakeTranslation(0,- CGRectGetHeight(_toolView.frame) - CGRectGetHeight(showKeyboard));
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    else{
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _toolView.transform = CGAffineTransformMakeTranslation(0,0);
                             [_toolView.emojiView ishidden];
                         } completion:^(BOOL finished) {
                             
                         }];
        

    }
    
}
- (void)keyboardShow:(NSNotification *)notification{
    
    NSDictionary *keyboardUserInfo = notification.userInfo;
    
    CGRect keyboardRect = [[keyboardUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    showKeyboard = keyboardRect;
    
    for (UIView *view in _firstResponderArr) {
        if (view.isFirstResponder) {
            [UIView animateWithDuration:0.2
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 _toolView.transform = CGAffineTransformMakeTranslation(0,- CGRectGetHeight(_toolView.frame) - CGRectGetHeight(keyboardRect));
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            break;
        }
    }
    [_toolView.emojiView ishidden];

    



}
- (void)keyboarkHidden:(NSNotification *)notification{
    
    showKeyboard = CGRectZero;
    if (!skip) {
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _toolView.transform = CGAffineTransformMakeTranslation(0,0);
                             
                         } completion:^(BOOL finished) {
                             
                         }];

    }
    else{
        skip = NO;
    }

    
}

- (void)skipKeyboard{
    skip = YES;
}


- (void)getEmoji:(NSString *)emoji kit:(id)kit{
    if ([_normalDelegate respondsToSelector:@selector(getNormalEmoji:kit:)]){
        [_normalDelegate getNormalEmoji:emoji kit:kit];
    }
    else{
        if ([kit isKindOfClass:[UITextView class]]) {
            UITextView *tv = kit;
            tv.text = [tv.text stringByAppendingString:emoji];
        }
        else if ([kit isKindOfClass:[UITextField class]]) {
            UITextField *tf = kit;
            tf.text = [tf.text stringByAppendingString:emoji];
        }
        
    }

}

- (void)emojiDeleteEventOnKit:(id)kit{
    if ([_normalDelegate respondsToSelector:@selector(emojiDeleteEvent:)]){
        [_normalDelegate emojiDeleteEvent:kit];
    }
    else{
        
        if ([kit isKindOfClass:[UITextView class]]) {
            UITextView *tv = kit;
            if(tv.text.length == 0){
                return;
            }
            
            NSString *regexStr = @"\\[[a-zA-Z0-9_-]{1,15}\\]";//中括号类型的正则，15为文件名字的长度
            NSRegularExpression *customEmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *arr = [customEmojiRegularExpression matchesInString:tv.text
                                                                 options:NSMatchingWithTransparentBounds
                                                                   range:NSMakeRange(0, [tv.text length])];
            if (arr.count > 0) {
                NSTextCheckingResult *result = [arr lastObject];
                NSRange range = result.range;
                NSString *lastStr = [tv.text substringWithRange:range];
                if ([tv.text hasSuffix:lastStr]) {
                    tv.text = [tv.text substringToIndex:tv.text.length - lastStr.length];
                }
                else{
                    tv.text = [tv.text substringToIndex:tv.text.length - 1];
                }
            }
            else{
                tv.text = [tv.text substringToIndex:tv.text.length - 1];
            }


            
        }
        else if ([kit isKindOfClass:[UITextField class]]) {
            UITextField *tf = kit;
            
            
            if(tf.text.length == 0){
                return;
            }
            
            NSString *regexStr = @"\\[[a-zA-Z0-9_-]{1,15}\\]";//中括号类型的正则，15为文件名字的长度
            NSRegularExpression *customEmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *arr = [customEmojiRegularExpression matchesInString:tf.text
                                                                 options:NSMatchingWithTransparentBounds
                                                                   range:NSMakeRange(0, [tf.text length])];
            if (arr.count > 0) {
                NSTextCheckingResult *result = [arr lastObject];
                NSRange range = result.range;
                NSString *lastStr = [tf.text substringWithRange:range];
                if ([tf.text hasSuffix:lastStr]) {
                    tf.text = [tf.text substringToIndex:tf.text.length - lastStr.length];
                }
                else{
                    tf.text = [tf.text substringToIndex:tf.text.length - 1];
                }
            }
            else{
                tf.text = [tf.text substringToIndex:tf.text.length - 1];
            }

            
        }

        
        
        
    }

    
}
@end
