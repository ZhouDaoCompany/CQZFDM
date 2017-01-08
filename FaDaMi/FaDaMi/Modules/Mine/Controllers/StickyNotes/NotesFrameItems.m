//
//  NotesFrameItems.m
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import "NotesFrameItems.h"

@implementation NotesFrameItems

- (void)setNotesModel:(AdvantagesModel *)notesModel {
    
    _notesModel = nil;
    _notesModel = notesModel;
    
    CGFloat labelWidth = SCREENWIDTH - 20.f;
    //内容高度计算
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size = [_notesModel.content boundingRectWithSize:CGSizeMake(labelWidth, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;


    CGFloat contentheight = 0.0f;
    if (size.height < 50.f) {
        
        contentheight = size.height;
        self.cellHeight = 25 + size.height + 5.f + 10.f;
    } else {
        contentheight = 50.f;
        self.cellHeight = 90.f;
    }
    
    self.contentLabelF = CGRectMake(5, 25, SCREENWIDTH - 20.f, contentheight);
}

+ (NSMutableArray *)notesFramesWithDataArr:(NSArray *)dataArr {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (AdvantagesModel *objModel in dataArr) {
        
        NotesFrameItems *noteFrame = [[NotesFrameItems alloc] init];
        noteFrame.notesModel = objModel;
        [arrayM addObject:noteFrame];
    }
    
    return arrayM;
}
@end
