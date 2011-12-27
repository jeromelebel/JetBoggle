//
//  JBBoggleTable.h
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BoggleTableChangedNotification @"BoggleTableChanged"
#define BoggleTableTurnedNotification @"BoggleTableTurned"
#define BoggleTableSelectionChangedNotification @"BoggleTableSelectionChanged"

@class JBBoggleDie;

@interface JBBoggleTable : NSObject
{
    NSMutableArray * dieArray;
    NSMutableArray * selectedDieArray;
    JBBoggleDie * boggleTable[4][4];
}
- (void)initializeDies;
- (void)shuffle;
- (void)turnLeft;
- (void)turnRight;
- (JBBoggleDie *)boggleDieAtRow:(int)newY column:(int)newX;
- (void)setMarkForAllDies:(BOOL)newMark;
- (BOOL)setBoggleDies:(const char *)newBoggleDieValues;
- (void)configureBoggleDies;
- (NSArray *)selectedDies;
- (void)selectWord:(NSString *)newSelectedWord;
@end
