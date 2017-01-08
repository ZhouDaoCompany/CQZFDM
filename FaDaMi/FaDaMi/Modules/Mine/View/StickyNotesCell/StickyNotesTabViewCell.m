//
//  StickyNotesTabViewCell.m
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import "StickyNotesTabViewCell.h"

@implementation StickyNotesTabViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    [self.contentView addSubview:self.botomView];
    [_botomView addSubview:self.timeLabel];
    [_botomView addSubview:self.contentLabel];

}
- (void)setNotesItem:(NotesFrameItems *)notesItem withDelegate:(id<SWTableViewCellDelegate>)delegate {
    
    self.delegate = delegate;
    _notesItem = nil;
    _notesItem = notesItem;
    // 1> 设置数据
    [self settingData];
    // 2> 设置位置
    [self settingFrame];

}
- (void)settingData {
    
    AdvantagesModel *model = self.notesItem.notesModel;
    _contentLabel.text = model.content;
    _timeLabel.text = [self editTimestamp];
}
- (void)settingFrame {
    
    _contentLabel.frame = _notesItem.contentLabelF;
}
//MARK: 时间戳转换 年月日 时分 星期几
- (NSString *)editTimestamp {
    
    AdvantagesModel *model = self.notesItem.notesModel;

    NSString *stringOne = [QZManager changeTimeMethods:[model.time doubleValue] withType:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [QZManager timeStampChangeNSDate:[model.time doubleValue]];
    NSDateComponents *beginComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSUInteger weekDay = [beginComponets weekday];
    
    NSArray *weekArrays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *stringTwo = [NSString stringWithFormat:@"%@",weekArrays[weekDay -1]];

    return [NSString stringWithFormat:@"%@ %@",stringOne,stringTwo];
}
#pragma mark - setter and getter
- (UIView *)botomView {
    
    if (!_botomView) {
        _botomView = [[UIView alloc] initWithFrame:CGRectMake(5.f, 5.f, SCREENWIDTH - 10.f, 80.f)];
        [_botomView setBackgroundColor:LRRGBColor(239, 239, 243)];
    }
    return _botomView;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9, 200, 15)];
        _timeLabel.textColor = hexColor(999999);
        _timeLabel.font = [UIFont fontWithName:@"Noteworthy" size:12.f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, SCREENWIDTH - 20.f, 50.f)];
        _contentLabel.textColor = hexColor(333333);
        //Noteworthy  Marker Felt
        _contentLabel.font = [UIFont fontWithName:@"Noteworthy" size:14.f];;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
