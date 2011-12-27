//
//  JBBoggleTablePanelDelegate.m
//  Boggle
//
//  Created by jerome on Sun Jul 01 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBBoggleTablePanelDelegate.h"
#import "JBBoggleTable.h"
#import "JBBoggleDie.h"
#import "JBApplicationDelegate.h"

@implementation JBBoggleTablePanelDelegate

- (id)initWithBoggleTable:(JBBoggleTable *)newBoggleTable
{
    [super init];
    selectedDies = nil;
    boggleTable = [newBoggleTable retain];
    [NSBundle loadNibNamed:@"BoggleTable" owner:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boggleTableSelectionChangedNotification:) name:BoggleTableSelectionChangedNotification object:boggleTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boggleTableChangedNotification:) name:BoggleTableChangedNotification object:boggleTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boggleTableChangedNotification:) name:BoggleTableTurnedNotification object:boggleTable];
    [self boggleTableChangedNotification:nil];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:nil object:self];
    [selectedDies release];
    [boggleTable release];
    [boggleTablePanel release];
    [dieValueEditorPanel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [timerProgressIndicator setMaxValue:[[NSApp delegate] gameLength]];
    [timerProgressIndicator setMinValue:0];
    [dieValueMatrix setAllowsEmptySelection:YES];
    [dieValueMatrix deselectAllCells];
    [boggleTablePanel setFrameAutosaveName:@"BoggleTable"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStartedNotification:) name:GameStartedNotification object:[NSApp delegate]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePausedNotification:) name:GamePausedNotification object:[NSApp delegate]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStoppedNotification:) name:GameStoppedNotification object:[NSApp delegate]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tickTimerNotification:) name:TickTimerNotification object:[NSApp delegate]];
}

- (IBAction)editDieValueAction:(id)sender
{
    char cString[2];
    int x, y;
    
    cString[1] = 0;
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            NSString * title;
            
            cString[0] = [[boggleTable boggleDieAtRow:y column:x] value];
            title = [[NSString alloc] initWithUTF8String:cString];
            [[dieValueEditorMatrix cellAtRow:y column:x] setTitle:title];
            [title release];
        }
    }
    [NSApp beginSheet:dieValueEditorPanel modalForWindow:boggleTablePanel modalDelegate:self didEndSelector:@selector(dieValueEditorSheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)cancelBoggleDieValueAction:(id)sender
{
    [NSApp endSheet:dieValueEditorPanel returnCode:NO];
}

- (IBAction)confirmBoggleDieValueAction:(id)sender
{
    char buffer[17];
    char * cursorPtr;
    int x, y;
    
    cursorPtr = buffer;
    for(y = 0; y < 4; y++) {
        for(x = 0; x < 4; x++) {
            *cursorPtr = [[[dieValueEditorMatrix cellAtRow:y column:x] title] UTF8String][0];
            cursorPtr++;
        }
    }
    *cursorPtr = 0;
    [boggleTable setBoggleDies:buffer];
    [NSApp endSheet:dieValueEditorPanel returnCode:NO];
}

- (void)dieValueEditorSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:nil];
    [sheet close];
}

- (void)shuffleBoggleAction:(id)sender
{
    [boggleTable shuffle];
}

- (void)turnBoggleAction:(id)sender
{
    if([[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSAlternateKeyMask) {
        [boggleTable turnLeft];
    } else {
        [boggleTable turnRight];
    }
}

- (IBAction)startGameAction:(id)sender
{
    [[NSApp delegate] startGameAction:sender];
}

- (void)selectNextDie:(id)unused
{
    if([selectedDies count]) {
        JBBoggleDie * boggleDie;
        
        boggleDie = [selectedDies objectAtIndex:0];
        [selectedDies removeObjectAtIndex:0];
        [dieValueMatrix selectCellAtRow:[boggleDie y] column:[boggleDie x]];
        [self performSelector:@selector(selectNextDie:) withObject:nil afterDelay:0.3];
    } else {
        [selectedDies release];
        selectedDies = nil;
        [dieValueMatrix deselectAllCells];
    }
}

- (void)boggleTableChangedNotification:(NSNotification *)newNotification
{
    char cString[2];
    int x, y;
    
    cString[1] = 0;
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            NSString * title;
            
            cString[0] = [[boggleTable boggleDieAtRow:y column:x] value];
            title = [[NSString alloc] initWithUTF8String:cString];
            [[dieValueMatrix cellAtRow:y column:x] setTitle:title];
            [title release];
        }
    }
}

- (void)boggleTableSelectionChangedNotification:(NSNotification *)newNotification
{
    BOOL shouldCallSelectNextDie;

    shouldCallSelectNextDie = selectedDies == nil;
    [selectedDies release];
    selectedDies = [[boggleTable selectedDies] mutableCopy];
    if(shouldCallSelectNextDie) {
        [self selectNextDie:nil];
    }
}

- (void)windowDidResize:(NSNotification *)aNotification
{
    int x, y;
    int fontSize;
    NSSize cellSize;
    NSFont * font;
    
    cellSize = [dieValueMatrix cellSize];
    if(cellSize.height > cellSize.width) {
        fontSize = cellSize.width - 10;
    } else {
        fontSize = cellSize.height - 10;
    }
    font = [[NSFontManager sharedFontManager] convertFont:[NSFont systemFontOfSize:fontSize] toHaveTrait:NSBoldFontMask];
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            [[dieValueMatrix cellAtRow:y column:x] setFont:font];
        }
    }
}

- (void)gameStartedNotification:(NSNotification *)notification
{
    [startPlayingButton setTitle:@"Pause Game"];
    [timerProgressIndicator setDoubleValue:0];
}

- (void)gamePausedNotification:(NSNotification *)notification
{
    [startPlayingButton setTitle:@"Continue Game"];
}

- (void)gameStoppedNotification:(NSNotification *)notification
{
    [startPlayingButton setTitle:@"Start Game"];
}

- (void)tickTimerNotification:(NSNotification *)notification
{
    [timerProgressIndicator setDoubleValue:[[NSApp delegate] timerValue]];
}
@end
