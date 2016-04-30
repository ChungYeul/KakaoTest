//
//  KKOThirdViewController.m
//  KakaoTest
//
//  Created by In Chung Yeul on 2016. 4. 30..
//  Copyright © 2016년 inchung. All rights reserved.
//

#import "KKOThirdViewController.h"

@interface KKOThirdViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation KKOThirdViewController
#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"VC03";
    self.textView.text = self.sTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end