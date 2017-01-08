//
//  StickyNotesTabViewCell.h
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "NotesFrameItems.h"

@interface StickyNotesTabViewCell : SWTableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *botomView;
@property (nonatomic, strong) NotesFrameItems *notesItem;

- (void)setNotesItem:(NotesFrameItems *)notesItem withDelegate:(id<SWTableViewCellDelegate>)delegate;
@end
