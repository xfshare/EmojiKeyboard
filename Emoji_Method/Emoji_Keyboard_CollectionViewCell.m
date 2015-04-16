//
//  Emoji_Keyboard_CollectionViewCell.m
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import "Emoji_Keyboard_CollectionViewCell.h"


#define EmojiPlistName @"expressionImage.plist"
#define EmojiSortKeyPlistName @"expressionImageArr.plist"
#define OneCell_Row   3 //行
#define OneCell_Colum 7 //列
#define OneCell_Img_W 24 //图片大小
#define EdgeDistance 20 //左右
#define EdgeInterVal 5 //上下

@implementation Emoji_Keyboard_CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 20.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.contentView addSubview:_cellView];
    
    allEmojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:EmojiPlistName ofType:nil]];
//    allKey = [allEmojiDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSComparisonResult result = [obj1 compare:obj2];
//        return result;
//
//    }];
    allKey = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:EmojiSortKeyPlistName ofType:nil]];

        
    return self;
}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [self cellView];
    
}

- (UIView *)cellView{
    
    CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-OneCell_Colum*OneCell_Img_W -2*EdgeDistance)/(OneCell_Colum-1);
    // 上下垂直间隔
    CGFloat verticalInterval = (CGRectGetHeight(self.bounds) - 72-2*EdgeInterVal -OneCell_Row*OneCell_Img_W)/(OneCell_Row-1);

    
    
    for (int i = 0; i< OneCell_Row; i ++) {
        for (int j= 0; j < OneCell_Colum; j ++) {
            
            //最后一个,添加一个删除键
            if(i== OneCell_Row - 1 && j==OneCell_Colum-1){
            
                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                delBtn.frame = CGRectMake(EdgeDistance + j * OneCell_Img_W + j * horizontalInterval,
                                          i * OneCell_Img_W + i * verticalInterval + EdgeInterVal ,
                                          OneCell_Img_W, OneCell_Img_W);
                [delBtn setImage:[UIImage imageNamed:@"delete_48"] forState:UIControlStateNormal];
                delBtn.contentMode=UIViewContentModeScaleAspectFit;
                [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [_cellView addSubview:delBtn];
                break;
            }
            
            NSUInteger num =(NSUInteger)(_indexPath.row * (OneCell_Row * OneCell_Colum-1) + i*OneCell_Colum+j);
            if (num < allKey.count) {
                Emoji_ImageView *imageV = [[Emoji_ImageView alloc] init];
                imageV.frame = CGRectMake(EdgeDistance + j * OneCell_Img_W + j * horizontalInterval,
                                          i * OneCell_Img_W + i * verticalInterval + EdgeInterVal ,
                                          OneCell_Img_W, OneCell_Img_W);
                NSString *imgName = [allEmojiDict objectForKey:[allKey objectAtIndex:num]];
                imageV.image = [UIImage imageNamed:imgName];
                imageV.num = num;
                imageV.emojiDelegate = self;
                [_cellView addSubview:imageV];
            }
        }
    }
    return _cellView;
}

- (void)delBtnAction:(id)sender{
    
    if ([_emKeyBoardDelegate respondsToSelector:@selector(emojiDeleteEvent)]) {
        [_emKeyBoardDelegate emojiDeleteEvent];
    }
    
}
- (void)clickImageViewNum:(NSUInteger)num{
    
    if ([_emKeyBoardDelegate respondsToSelector:@selector(clickImageViewInCellKey:)]) {
        [_emKeyBoardDelegate clickImageViewInCellKey:[allKey objectAtIndex:num]];
    }
    
}
@end
