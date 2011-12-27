//
//  JBApplicationDelegate.h
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class JBBoggleTable;
@class JBComputerPlayer;
@class JBDictionary;
@class JBBoggleTablePanelDelegate;
@class JBDictionaryNode;

#define TickTimerNotification @"TickTimerNotification"
#define GameStartedNotification @"GameStartedNotification"
#define GamePausedNotification @"GamePausedNotification"
#define GameStoppedNotification @"GameStoppedNotification"

@interface JBApplicationDelegate : NSObject
{
    JBBoggleTablePanelDelegate * boggleTablePanelDelegate;
    JBBoggleTable * boggleTable;
    JBComputerPlayer * computerPlayer;
    JBDictionary * dictionary;
    BOOL gameRunning;
    float counter;
}

- (IBAction)startGameAction:(id)sender;
- (IBAction)shuffleBoggleAction:(id)sender;
- (IBAction)editDieValueAction:(id)sender;
- (IBAction)showComputerWindowAction:(id)sender;

- (void)searchWordsWithLetters:(const char *)test;
- (void)searchWordsWithLetters:(NSMutableArray *)newLettreArray dictionaryNode:(JBDictionaryNode *)newDictionaryNode result:(NSMutableDictionary *)newResult;
- (int)gameLength;
- (int)timerValue;
@end
