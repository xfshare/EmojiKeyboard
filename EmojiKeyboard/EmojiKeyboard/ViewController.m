//
//  ViewController.m
//  EmojiKeyboard
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 VKan. All rights reserved.
//

#import "ViewController.h"

#import "Emoji.h"
@interface ViewController ()<EmojiNormalMethodDelegate>
{
    EmojiNormalMethod *emojiNormalMethod;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    emojiNormalMethod = [[EmojiNormalMethod alloc] initWithBecomeFirstResponder:@[self.textField]];
    
    
//    emojiNormalMethod.normalDelegate = self;
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    if (emojiNormalMethod) {
        [emojiNormalMethod isRemoveWhenVCDisappear];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isEqual:self.view]) {
        [self.view endEditing:YES];
        [emojiNormalMethod ishidden];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
