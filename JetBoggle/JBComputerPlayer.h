//
//  JBComputerPlayer.h
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class JBBoggleTable;
@class JBDictionary;
@class JBBoggleDie;
@class JBDictionaryNode;

@interface JBComputerPlayer : NSObject {
    IBOutlet NSTextField * numberOfWord;
    IBOutlet NSButton * startStopPlaying;
    IBOutlet NSOutlineView * tableView;
    IBOutlet NSWindow * window;
    
    float searchTime;
    JBBoggleTable * boggleTable;
    BOOL keepPlaying;
    JBDictionary * dictionary;
    NSMutableArray * resultWords;
}
- (id)initWithBoggleTable:(JBBoggleTable *)newBoggleTable dictionary:(JBDictionary *)newDictionary;
- (void)showComputerWindow;
- (void)startPlaying;
- (void)stopPlaying;
- (void)playing:(id)unused;
- (BOOL)keepPlaying;
- (void)searchForWordsWithBoggleDie:(JBBoggleDie *)newBoggleDie dictionaryNode:(JBDictionaryNode *)newDictionaryNode;

- (void)selectWordAction:(id)sender;
@end
