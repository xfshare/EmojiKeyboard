//
//  Emoji_Keyboard_View.m
//  thirdTest
//
//  Created by mac on 15/4/8.
//  Copyright (c) 2015年 iDveOS. All rights reserved.
//

#import "Emoji_Keyboard_View.h"
#import "Emoji_Keyboard_CollectionViewCell.h"

#define CellIdentifier @"collectionCell"
#define EmojiPlistName @"expressionImage.plist"

#define PageControlHeight 30


#define OneCell_Row   3 //行
#define OneCell_Colum 7 //列


@interface Emoji_Keyboard_View()<UICollectionViewDelegate,UICollectionViewDataSource,Emoji_Keyboard_CollectionViewCellDelegate>
{
    CGRect bgframe;
    NSDictionary *allEmojiDict;
    UIPageControl *pageControl;
    
}
@property (nonatomic,strong)UICollectionView *collectionV;
@end

@implementation Emoji_Keyboard_View
@synthesize collectionV;
@synthesize showing;

- (instancetype)initWithFrame:(CGRect)frame{
    
    frame = CGRectMake(0,CGRectGetHeight([[UIScreen mainScreen] bounds]),
                       CGRectGetWidth([[UIScreen mainScreen] bounds]),
                       216);
    
    self = [super initWithFrame:frame];
    if (self) {
        bgframe = frame;
        self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
        
        allEmojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:EmojiPlistName ofType:nil]];
        
        [self buildCollection];
        [self buildPageControl];
        [self registerNotification];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        CGRect frame =CGRectMake(0,CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64,
                                 CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                 216);
        self.frame =frame;
        
        bgframe = frame;
        self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
        
        allEmojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:EmojiPlistName ofType:nil]];
        
        [self buildCollection];
        [self buildPageControl];
        [self registerNotification];

    }
    return self;
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
    if (showing) {
        [self ishidden];
    }
    
}
- (void)buildPageControl{
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight(self.frame) - PageControlHeight - 20,
                                                                  CGRectGetWidth(self.frame),
                                                                  PageControlHeight)];
    pageControl.numberOfPages =allEmojiDict.allKeys.count/ 21 + 1;
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    [self addSubview:pageControl];
}

- (void)isshow{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGAffineTransform transform;
                         if (!showing) {
                             transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
                         }
                         else{
                             transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                         
                         //通知 ,使用的
                         if ([_keyDelegate respondsToSelector:@selector(emojiKeyboardViewtransform:)]) {
                             [_keyDelegate emojiKeyboardViewtransform:transform];
                         }
                         
                         
                         self.transform = transform;
                        
                         showing = !showing;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)ishidden{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);

                         self.transform = transform;
                         
                     } completion:^(BOOL finished) {
                         showing = NO;
                     }];
}




- (void)buildCollection{
    if (collectionV) {
        return;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];//最小水平间距
    [flowLayout setMinimumLineSpacing:2.0];//最小行间距
    collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     CGRectGetWidth(bgframe),
                                                                     CGRectGetHeight(bgframe))
                                     collectionViewLayout:flowLayout];
    
    [collectionV registerClass:[Emoji_Keyboard_CollectionViewCell class]forCellWithReuseIdentifier:CellIdentifier];
    collectionV.backgroundColor = [UIColor whiteColor];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.pagingEnabled = YES;
    collectionV.delegate = self;
    collectionV.dataSource = self;
    [self addSubview:collectionV];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(collectionV.frame);
    
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return allEmojiDict.allKeys.count/ (OneCell_Row * OneCell_Colum - 1) + 1;
}
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath

{	Emoji_Keyboard_CollectionViewCell *cell =
    
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
     
                                              forIndexPath:indexPath];
    
    [cell.cellView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//防止重用的时候都有了
    
    cell.emKeyBoardDelegate = self;
    
    cell.indexPath = indexPath;
    
    
    return cell;
    
}

//定义每个UICollectionView 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView

                  layout:(UICollectionViewLayout *)collectionViewLayout

  sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    return CGSizeMake(CGRectGetWidth(bgframe),
                      
                      CGRectGetHeight(bgframe)-2);
    
}

//定义每个UICollectionView 的 margin

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView

                        layout:(UICollectionViewLayout *)collectionViewLayout

        insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(2, 0, 0, 0); //{top, left, bottom, right};
    
}



- (void)clickImageViewInCellKey:(NSString *)keyStr{
    NSLog(@"%@",keyStr);
    if ([_keyDelegate respondsToSelector:@selector(getEmojiKey:)]) {
        [_keyDelegate getEmojiKey:keyStr];
    }
}


- (void)emojiDeleteEvent{
    NSLog(@"emoji UI delete action");
    if ([_keyDelegate respondsToSelector:@selector(emojikeyboardDeleteEvent)]) {
        [_keyDelegate emojikeyboardDeleteEvent];
    }

}



@end
