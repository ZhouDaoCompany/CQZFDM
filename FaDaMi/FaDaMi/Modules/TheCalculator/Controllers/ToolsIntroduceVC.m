//
//  ToolsIntroduceVC.m
//  ZhouDao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsIntroduceVC.h"

@interface ToolsIntroduceVC ()


@property (nonatomic, strong) UITextView *textView;
@end

@implementation ToolsIntroduceVC
- (void)dealloc {
    
    TTVIEW_RELEASE_SAFELY(_textView);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}
#pragma mark - methods
- (void)initUI{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupNaviBarWithTitle:@"计算说明"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.textView];
}
#pragma mark - setter and getter
- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, SCREENWIDTH - 20, SCREENHEIGHT-64)];
        _textView.text = _introContent;
        _textView.backgroundColor =ViewBackColor;
        _textView.editable = NO;
        _textView.font = Font_15;
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
