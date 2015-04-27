//
//  Emoji_Keyboard_CollectionViewCell.h
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji_ImageView.h"

@protocol Emoji_Keyboard_CollectionViewCellDelegate <NSObject>

- (void)clickImageViewInCellKey:(NSString *)keyStr;
- (void)emojiDeleteEvent;

@end


@interface Emoji_Keyboard_CollectionViewCell : UICollectionViewCell<Emoji_ImageViewDelegate>
{
    @private
    NSDictionary *allEmojiDict;
    NSArray *allKey;
}
@property(nonatomic, strong) UIView *cellView;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) id<Emoji_Keyboard_CollectionViewCellDelegate>emKeyBoardDelegate;

@end
