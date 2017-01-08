//
//  StickyNotesDetialVC.h
//  FaDaMi
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 CQZ. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NotesDetailType){
    
    NotesEditType = 0,
    NotesCreateType = 1,
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AdvantagesModel.h"
@protocol NotesDetialVCPro;

@interface StickyNotesDetialVC : BaseViewController

@property (nonatomic, weak) id<NotesDetialVCPro>delegate;

- (instancetype)initWithModel:(AdvantagesModel *)model
                     withType:(NotesDetailType)noteType withIndex:(NSUInteger)index withNoteDelegate:(id<NotesDetialVCPro>)delegate;
@end

@protocol NotesDetialVCPro <NSObject>

- (void)deleteSuccessThisNotes:(NSUInteger)index;
- (void)addOREditSuccessThisNotes;

@end
