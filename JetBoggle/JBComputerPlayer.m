//
//  JBComputerPlayer.m
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBComputerPlayer.h"
#import "JBBoggleTable.h"
#import "JBBoggleDie.h"
#import "JBDictionary.h"
#import "JBDictionaryNode.h"

static NSInteger sortResultFunction(id newResult1, id newResult2, void * unused)
{
    return [(NSString *)[newResult1 objectAtIndex:0] compare:[newResult2 objectAtIndex:0]];
}

@implementation JBComputerPlayer

- (id)initWithBoggleTable:(JBBoggleTable *)newBoggleTable dictionary:(JBDictionary *)newDictionary
{
    if (self = [super init]) {
        boggleTable = [newBoggleTable retain];
        dictionary = [newDictionary retain];
        resultWords = [[NSMutableArray alloc] init];
        [NSBundle loadNibNamed:@"ComputerPlayer" owner:self];
        [numberOfWord setStringValue:@""];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boggleTableChangedNotification:) name:BoggleTableChangedNotification object:boggleTable];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:nil object:self];
    [window release];
    [resultWords release];
    [dictionary release];
    [boggleTable release];
    [super dealloc];
}

- (void)awakeFromNib
{
}

- (void)showComputerWindow
{
    [window makeKeyAndOrderFront:nil];
}

- (void)startPlaying
{
    keepPlaying = YES;
    [NSThread detachNewThreadSelector:@selector(playing:)toTarget:self withObject:nil];
}
    
- (void)stopPlaying
{
    keepPlaying = NO;
}

- (void)playingFinished:(id)unused
{
    [numberOfWord setStringValue:[NSString stringWithFormat:@"%d words found (%f seconds).", [resultWords count], searchTime]];
    [tableView reloadData];
}

- (void)playing:(id)unused
{
    int x, y;
    NSAutoreleasePool * pool;
    NSDate * startDate;
    int i;
    NSArray * firstObject = nil;
    
    pool = [[NSAutoreleasePool alloc] init];
    [resultWords removeAllObjects];
    startDate = [NSDate date];
    [boggleTable setMarkForAllDies:NO];
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            JBBoggleDie * boggleDie;
            JBDictionaryNode * dictionaryNode;
        
            boggleDie = [boggleTable boggleDieAtRow:y column:x];
            dictionaryNode = [[dictionary dictionaryNode] dictionaryNodeWithLetter:[boggleDie value]];
            if(dictionaryNode) {
                [self searchForWordsWithBoggleDie:boggleDie dictionaryNode:dictionaryNode];
            }
        }
    }
    searchTime = -[startDate timeIntervalSinceNow];
    [resultWords sortUsingFunction:sortResultFunction context:nil];
    i = 1;
    if([resultWords count] > 0) {
        firstObject = [resultWords objectAtIndex:0];
    }
    while(i < [resultWords count]) {
        NSArray * secondObject;
        
        secondObject = [resultWords objectAtIndex:i];
        if([firstObject isEqualTo:secondObject]) {
            [resultWords removeObjectAtIndex:i];
        } else {
            firstObject = secondObject;
            i++;
        }
    }
    keepPlaying = NO;
    [self performSelectorOnMainThread:@selector(playingFinished:) withObject:nil waitUntilDone:NO];
    [pool release];
    [NSThread exit];
}

- (BOOL)keepPlaying
{
    return keepPlaying;
}

- (void)searchForWordsWithBoggleDie:(JBBoggleDie *)newBoggleDie dictionaryNode:(JBDictionaryNode *)newDictionaryNode
{
    NSArray * wordPtr;
    NSArray * dieNearByArray;
    NSUInteger numberOfDieNearBy;
    
    wordPtr = [newDictionaryNode words];
    if(wordPtr && ([newDictionaryNode depth] > 2)) {
        [resultWords addObject:wordPtr];
    }
    [newBoggleDie setMark:YES];
    dieNearByArray = [newBoggleDie diesNearBy];
    numberOfDieNearBy = [dieNearByArray count];
    while(numberOfDieNearBy--) {
        JBBoggleDie * nextDie;
        
        nextDie = [dieNearByArray objectAtIndex:numberOfDieNearBy];
        if(![nextDie mark]) {
            JBDictionaryNode *nextDictionaryNode;

            nextDictionaryNode = [newDictionaryNode dictionaryNodeWithLetter:[nextDie value]];
            if(nextDictionaryNode) {
                [self searchForWordsWithBoggleDie:nextDie dictionaryNode:nextDictionaryNode];
            }
        }
    }
    [newBoggleDie setMark:NO];
}

- (void)selectWordAction:(id)sender
{
    NSUInteger selectedRow;

    selectedRow = [tableView selectedRow];
    if(selectedRow != -1) {
        id item;

        item = [tableView itemAtRow:selectedRow];
        if([item respondsToSelector:@selector(objectAtIndex:)]) {
            item = [item objectAtIndex:0];
        }
        [boggleTable selectWord:item];
    } else {
        [boggleTable selectWord:@""];
    }
}

@end

@implementation JBComputerPlayer(DataSource)

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    id result;
    
    if(item) {
        result = [item objectAtIndex:index];
    } else {
        result = [resultWords objectAtIndex:index];
    }
    return result;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item respondsToSelector:@selector(objectAtIndex:)] && ([item count] > 1);
}
	 
- (NSUInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSUInteger result;
    
    if(item) {
        result = [item count];
    } else {
        result = [resultWords count];
    }
    return result;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if([item respondsToSelector:@selector(objectAtIndex:)]) {
        return [item objectAtIndex:0];
    } else {
        return item;
    }
}
/*
- (int)numberOfRowsInTableView:(NSTableView *)newTableView
 {
    return [resultWords count];
}

- (id)tableView:(NSTableView *)newTableView objectValueForTableColumn:(NSTableColumn *)newTableColumn row:(int)newRowIndex
{
    return [[resultWords objectAtIndex:newRowIndex] objectAtIndex:0];
}*/

@end

@implementation JBComputerPlayer(Notification)

- (void)boggleTableChangedNotification:(NSNotification *)newNotification
{
    [resultWords removeAllObjects];
    [numberOfWord setStringValue:@""];
    [tableView reloadData];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    [self selectWordAction:self];

}
@end