//
//  NotesFrameItems.h
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvantagesModel.h"

@interface NotesFrameItems : NSObject


@property (nonatomic, assign) CGRect contentLabelF;// 内容坐标
/** 行高 */
@property (nonatomic, assign) CGFloat cellHeight;


/** 所有控件的尺寸都可以通过Status来计算得出 */
@property (nonatomic, strong)  AdvantagesModel *notesModel;


+ (NSMutableArray *)notesFramesWithDataArr:(NSArray *)dataArr;

@end
