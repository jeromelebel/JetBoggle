//
//  JBApplicationDelegate.m
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBApplicationDelegate.h"
#import "JBBoggleTable.h"
#import "JBBoggleDie.h"
#import "JBFileBuffer.h"
#import "JBComputerPlayer.h"
#import "JBDictionary.h"
#import "JBBoggleTablePanelDelegate.h"
#import "JBDictionaryNode.h"

#define TimerUnit 0.5
#define GameLength 60 * 3

@implementation JBApplicationDelegate

- (void)dealloc
{
    [boggleTable release];
    [boggleTablePanelDelegate release];
    [dictionary release];
    [computerPlayer release];
    [super dealloc];
}

- (void)awakeFromNib
{
    gameRunning = 0;
    
    srandom([[NSDate date] timeIntervalSince1970]);
    boggleTable = [[JBBoggleTable alloc] init];
    [boggleTable setBoggleDies:"reticeaomrnbousa"];
    boggleTablePanelDelegate = [[JBBoggleTablePanelDelegate alloc] initWithBoggleTable:boggleTable];
    dictionary = [[JBDictionary alloc] initWithFileName:[[NSBundle bundleForClass:[self class]] pathForResource:@"dictionary" ofType:@"txt"]];

    computerPlayer = [[JBComputerPlayer alloc] initWithBoggleTable:boggleTable dictionary:dictionary];
    [self searchWordsWithLetters:"critknog"];
}

- (void)searchWordsWithLetters:(const char *)test
{
    const char * cursor;
    NSMutableArray * letterArray;
    NSMutableDictionary * result;
    char buffer[2];

    letterArray = [[NSMutableArray alloc] init];
    result = [[NSMutableDictionary alloc] init];
    buffer[1] = 0;
    cursor = test;
    while(*cursor) {
        NSString *letterString;
        
        buffer[0] = *cursor;
        letterString = [[NSString alloc] initWithUTF8String:buffer];
        [letterArray addObject:letterString];
        [letterString release];
        cursor++;
    }
    [self searchWordsWithLetters:letterArray dictionaryNode:[dictionary dictionaryNode] result:result];
    [letterArray release];
    [result release];
}

- (void)searchWordsWithLetters:(NSMutableArray *)newLettreArray dictionaryNode:(JBDictionaryNode *)newDictionaryNode result:(NSMutableDictionary *)newResult
{
    NSUInteger i;
    
    i = [newLettreArray count];
    if([newDictionaryNode words]) {
        [newResult setObject:@"" forKey:[[newDictionaryNode words] objectAtIndex:0]];
    }
    while(i--) {
        NSString * letter;
        JBDictionaryNode * dictionaryNode;
        
        letter = [newLettreArray objectAtIndex:i];
        [newLettreArray removeObjectAtIndex:i];
        dictionaryNode = [newDictionaryNode dictionaryNodeWithLetter:*[letter UTF8String]];
        if(dictionaryNode) {
            [self searchWordsWithLetters:newLettreArray dictionaryNode:dictionaryNode result:newResult];
        }
        [newLettreArray insertObject:letter atIndex:i];
    }
}

- (IBAction)shuffleBoggleAction:(id)sender
{
    [boggleTable shuffle];
}

- (IBAction)editDieValueAction:(id)sender
{
    [boggleTablePanelDelegate editDieValueAction:sender];
}

- (IBAction)startGameAction:(id)sender
{
    counter = 0;
    [computerPlayer startPlaying];
    [[NSNotificationCenter defaultCenter] postNotificationName:TickTimerNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:GameStartedNotification object:self];
    [self performSelector:@selector(timerTicker:) withObject:nil afterDelay:TimerUnit];
}

- (IBAction)showComputerWindowAction:(id)sender
{
    [computerPlayer showComputerWindow];
}

- (void)timerTicker:(id)unused
{
    counter += TimerUnit;

    [[NSNotificationCenter defaultCenter] postNotificationName:TickTimerNotification object:self];
    if(counter < GameLength) {
        [self performSelector:@selector(timerTicker:) withObject:nil afterDelay:TimerUnit];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GameStoppedNotification object:self];
    }
}

- (int)gameLength
{
    return GameLength;
}

- (int)timerValue
{
    return counter;
}

@end
