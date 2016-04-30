//
//  KKOFirstViewController.m
//  KakaoTest
//
//  Created by In Chung Yeul on 2016. 4. 30..
//  Copyright © 2016년 inchung. All rights reserved.
//

#import "KKOFirstViewController.h"
#import "KakaoTest-swift.h"

#define USER_DEFAULTS_KEY @"TitleList"

@interface KKOFirstViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (nonatomic, strong) NSMutableArray *arrList;
@end

@implementation KKOFirstViewController {
    NSUserDefaults *_defaults;
}
#pragma mark - IBAction
- (IBAction)addBtn:(id)sender {
    [self addTitle];
    
    KKOSecondViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KKOSecondVC"];
    [self.navigationController pushViewController:secondVC animated:YES];
    
    [self.textView resignFirstResponder];
    self.textView.text = @"";
    self.btnAdd.enabled = NO;
} // 추가 버튼을 터치시, 호출 된다.

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        self.arrList = [[NSMutableArray alloc] initWithArray:[_defaults objectForKey:USER_DEFAULTS_KEY]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
        });
    });
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
    [self.indicatorView startAnimating];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Function
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    self.keyboardHeight.constant = height;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
} // 키보드 노출될때, 호출된다.

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardHeight.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
} // 키보드 사라질때, 호출된다.

- (void)addTitle {
    [self.arrList insertObject:self.textView.text atIndex:0];
    _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:self.arrList forKey:USER_DEFAULTS_KEY];
} // 타이틀 추가시, 호출된다.

#pragma mark - Notification
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
} // 키보드 Show/Hide 노티를 등록한다.
- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
} // 키보드 Show/Hide 노티피를 제거한다.

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.btnAdd.enabled = NO;
    }
    else {
        if (self.btnAdd.enabled == NO) {
            self.btnAdd.enabled = YES;
        }
    }
} // 텍스트뷰 입력될때 호출된다.
@end