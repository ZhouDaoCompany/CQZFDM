//
//  StickyNotesDetialVC.m
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import "StickyNotesDetialVC.h"

@interface StickyNotesDetialVC () <QMUITextViewDelegate>

@property (nonatomic, assign) NotesDetailType noteType;
@property (nonatomic, strong) AdvantagesModel *model;
@property (nonatomic, strong) QMUITextView *contentText;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation StickyNotesDetialVC

- (instancetype)initWithModel:(AdvantagesModel *)model
                     withType:(NotesDetailType)noteType withIndex:(NSUInteger)index withNoteDelegate:(id<NotesDetialVCPro>)delegate {
    
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        _index = index;
        _model = model;
        _noteType = noteType;
    }
    return self;
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary* dict = @{NSFontAttributeName:[UIFont fontWithName:@"Noteworthy" size:15.f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

#pragma mark - methods
- (void)initUI {
    
    [self.view addSubview:self.contentText];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    if (_noteType == NotesCreateType) {
        
        [self setupNaviBarWithTitle:@"添加便签"];
        [self setupNaviBarWithBtn:NaviRightBtn title:@"" img:@"mine_commitBQ"];
        [_contentText becomeFirstResponder];
    } else {
        
        [self setupNaviBarWithTitle:[self getTimeDescribe]];
        UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"mine_commitBQ") style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction)];
        UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"mine_deleteBQ") style:UIBarButtonItemStyleDone target:self action:@selector(deleteBianQianContent)];
        [self.navigationItem setRightBarButtonItems:@[btnItem1,btnItem2]];
        _contentText.text = _model.content;
    }
}
#pragma mark - UIButton Event
- (void)rightBtnAction { WEAKSELF;
    
    DLog(@"提交");
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"uid",_contentText.text,@"con", nil];
    NSString *urlString = @"";
    if (_noteType == NotesCreateType) {
        urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,BIANQIANADD];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,BIANQIANEDIT];
        [paraDict setObjectWithNullValidate:_model.id forKey:@"id"];
    }
    [NetWorkMangerTools generalPostURLString:urlString WithDictionary:paraDict RequestSuccess:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(addOREditSuccessThisNotes)]) {
            [weakSelf.delegate addOREditSuccessThisNotes];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^{
    }];

}
- (void)deleteBianQianContent { WEAKSELF
    
    DLog(@"删除");
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&id=%@",kProjectBaseUrl,BIANQIANDELETE,UID,_model.id];
    [NetWorkMangerTools generalGetURLString:urlString
                             RequestSuccess:^{
                                 
                                 if ([weakSelf.delegate respondsToSelector:@selector(deleteSuccessThisNotes:)]) {
                                     [weakSelf.delegate deleteSuccessThisNotes:weakSelf.index];
                                 }
                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                             } fail:^{
                             }];

}
//MARK: 得到时间描述
- (NSString *)getTimeDescribe {
    
    NSString *stringOne = [QZManager changeTimeMethods:[_model.time doubleValue] withType:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [QZManager timeStampChangeNSDate:[_model.time doubleValue]];
    NSDateComponents *beginComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSUInteger weekDay = [beginComponets weekday];
    
    NSArray *weekArrays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *stringTwo = [NSString stringWithFormat:@"%@",weekArrays[weekDay -1]];
    
    return [NSString stringWithFormat:@"%@ %@",stringOne,stringTwo];
}
#pragma mark - QMUITextViewDelegate
//通过委托来放弃第一响应者
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - setter and getter
- (QMUITextView *)contentText {
    
    if (!_contentText) {
        _contentText = [[QMUITextView alloc] initWithFrame:CGRectMake(15, 74.f, SCREENWIDTH - 30, 240)];
        _contentText.delegate =self;
        _contentText.font = [UIFont fontWithName:@"Noteworthy" size:14.f];
        _contentText.backgroundColor = [UIColor whiteColor];
        _contentText.placeholder = @" 请输入内容";
//        _contentText.placeholderColor = [UIColor lightGrayColor];
        _contentText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _contentText.layer.borderWidth = 1.f;
    }
    return _contentText;
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissKeyBoard];
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
