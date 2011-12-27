//
//  JBBoggleTable.m
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBBoggleTable.h"
#import "JBBoggleDie.h"

@interface JBBoggleTable(PrivateApi)
- (BOOL)_selectionWord:(const char *)newCWordPtr withDies:(NSArray *)newDieArray;
- (BOOL)_setBoggleDiesWithPosition:(const char *)newBoggleDieValues setDiesArrayPtr:(JBBoggleDie * *)newSetDiesPtr unsetDiesArrayPtr:(JBBoggleDie * *)newUnsetDiesArrayPtr level:(int)newLevel;
@end

@implementation JBBoggleTable

- (id)init
{
    [super init];
    dieArray = [[NSMutableArray alloc] init];
    selectedDieArray = [[NSMutableArray alloc] init];
    [self initializeDies];
    [self shuffle];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:nil object:self];
    [selectedDieArray release];
    [dieArray release];
    [super dealloc];
}

- (void)initializeDies
{
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"YGLNUE"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"KTENUO"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"ZVDNEA"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"OENDTS"] autorelease]];
    
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"ESHFEI"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"SHIERN"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"VTIENG"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"UIERLW"] autorelease]];
    
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"MRSIOA"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"EULPTS"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"IAOAET"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"BJQMOA"] autorelease]];
    
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"AECSRL"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"AEDMPC"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"RTBLIA"] autorelease]];
    [dieArray addObject:[[[JBBoggleDie alloc] initWithLetterCString:"FRXAOI"] autorelease]];
}

- (JBBoggleDie *)boggleDieAtRow:(int)newY column:(int)newX
{
    return boggleTable[newX][newY];
}

- (void)turnRight
{
    JBBoggleDie * newBoggle[4][4];
    int x, y;

    newBoggle[3][0] = boggleTable[0][0];
    newBoggle[3][1] = boggleTable[1][0];
    newBoggle[3][2] = boggleTable[2][0];
    newBoggle[3][3] = boggleTable[3][0];
    
    newBoggle[2][0] = boggleTable[0][1];
    newBoggle[2][1] = boggleTable[1][1];
    newBoggle[2][2] = boggleTable[2][1];
    newBoggle[2][3] = boggleTable[3][1];

    newBoggle[1][0] = boggleTable[0][2];
    newBoggle[1][1] = boggleTable[1][2];
    newBoggle[1][2] = boggleTable[2][2];
    newBoggle[1][3] = boggleTable[3][2];

    newBoggle[0][0] = boggleTable[0][3];
    newBoggle[0][1] = boggleTable[1][3];
    newBoggle[0][2] = boggleTable[2][3];
    newBoggle[0][3] = boggleTable[3][3];

    memcpy(boggleTable, newBoggle, sizeof(newBoggle));
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            [boggleTable[x][y] setCoordonateWithX:x y:y];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BoggleTableTurnedNotification object:self];
}

- (void)turnLeft
{
    JBBoggleDie * newBoggle[4][4];
    int x, y;

    newBoggle[0][3] = boggleTable[0][0];
    newBoggle[0][2] = boggleTable[1][0];
    newBoggle[0][1] = boggleTable[2][0];
    newBoggle[0][0] = boggleTable[3][0];

    newBoggle[1][3] = boggleTable[0][1];
    newBoggle[1][2] = boggleTable[1][1];
    newBoggle[1][1] = boggleTable[2][1];
    newBoggle[1][0] = boggleTable[3][1];

    newBoggle[2][3] = boggleTable[0][2];
    newBoggle[2][2] = boggleTable[1][2];
    newBoggle[2][1] = boggleTable[2][2];
    newBoggle[2][0] = boggleTable[3][2];

    newBoggle[3][3] = boggleTable[0][3];
    newBoggle[3][2] = boggleTable[1][3];
    newBoggle[3][1] = boggleTable[2][3];
    newBoggle[3][0] = boggleTable[3][3];

    memcpy(boggleTable, newBoggle, sizeof(newBoggle));
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            [boggleTable[x][y] setCoordonateWithX:x y:y];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:BoggleTableTurnedNotification object:self];
}

- (void)shuffle
{
    NSMutableArray *dieToShuffleArray;
    int x1;
    int y1;
    
    dieToShuffleArray = [dieArray mutableCopy];
    for(x1 = 0; x1 < 4; x1++) {
        for(y1 = 0; y1 < 4; y1++) {
            NSUInteger index;
            JBBoggleDie * boggleDie;
            
            index = random() % [dieToShuffleArray count];
            boggleDie = [dieToShuffleArray objectAtIndex:index];
            boggleTable[x1][y1] = boggleDie;
            [boggleDie setCoordonateWithX:x1 y:y1];
            [boggleDie shuffle];
            [dieToShuffleArray removeObjectAtIndex:index];
        }
    }
    [self configureBoggleDies];
}

- (BOOL)setBoggleDies:(const char *)newBoggleDieValues
{
    BOOL result;
    JBBoggleDie * setDieArrayPtr[16];
    JBBoggleDie * unsetDieArrayPtr[16];
    int i;
    
    for(i = 0; i < 16; i++) {
        unsetDieArrayPtr[i] = [dieArray objectAtIndex:i];
    }
    result = [self _setBoggleDiesWithPosition:newBoggleDieValues setDiesArrayPtr:setDieArrayPtr unsetDiesArrayPtr:unsetDieArrayPtr level:16];
    if(result) {
        JBBoggleDie * * boggleDieCursor;
        int x, y;
        
        boggleDieCursor = setDieArrayPtr;
        for(y = 0; y < 4; y++) {
            for(x = 0; x < 4; x++) {                
                [*boggleDieCursor setValue:*newBoggleDieValues];
                boggleTable[x][y] = *boggleDieCursor;
                [*boggleDieCursor setCoordonateWithX:x y:y];
                newBoggleDieValues++;
                boggleDieCursor++;
            }
        }
        [self configureBoggleDies];
    }
    return result;
}

- (void)configureBoggleDies
{
    int x1, y1;
    
    for(x1 = 0; x1 < 4; x1++) {
        for(y1 = 0; y1 < 4; y1++) {
            JBBoggleDie * boggleDie;
            NSMutableArray * dieNearByArray;
            int x2;
            int y2;
            
            dieNearByArray = [[NSMutableArray alloc] init];
            boggleDie = boggleTable[x1][y1];
            for(x2 = x1 - 1; x2 <= x1 + 1; x2++) {
                for(y2 = y1 - 1; y2 <= y1 + 1; y2++) {
                    if((x2 >= 0) && (x2 <=3) && (y2 >= 0) && (y2 <=3) && ((x2 != x1) || (y2 != y1))) {
                        [dieNearByArray addObject:boggleTable[x2][y2]];
                    }
                }
            }
            [boggleDie setDeNearBy:dieNearByArray];
            [dieNearByArray release];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BoggleTableChangedNotification object:self];
}

- (void)setMarkForAllDies:(BOOL)newMark
{
    int x, y;
    
    for(x = 0; x < 4; x++) {
        for(y = 0; y < 4; y++) {
            [boggleTable[x][y] setMark:newMark];
        }
    }
}

- (NSArray *)selectedDies
{
    return selectedDieArray;
}

- (void)selectWord:(NSString *)newSelectedWord
{
    NSEnumerator * enumerator;
    JBBoggleDie * boggleDie;

    enumerator = [selectedDieArray objectEnumerator];
    while(boggleDie = [enumerator nextObject]) {
        [boggleDie setSelected:NO];
    }
    [selectedDieArray removeAllObjects];
    [self _selectionWord:[newSelectedWord UTF8String] withDies:dieArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:BoggleTableSelectionChangedNotification object:self];
}

@end

@implementation JBBoggleTable(PrivateApi)

- (BOOL)_selectionWord:(const char *)newCWordPtr withDies:(NSArray *)newDieArray
{
    BOOL result;
    
    if(*newCWordPtr) {
        NSEnumerator * enumerator;
        JBBoggleDie * boggleDie;

        result = NO;
        enumerator = [newDieArray objectEnumerator];
        while((boggleDie = [enumerator nextObject]) && !result) {
            char letter;
            
            letter = *newCWordPtr;
            CORRECTLETTER(letter);
            if(([boggleDie value] == letter) && ![boggleDie mark]) {
                [boggleDie setMark:YES];
                if([self _selectionWord:newCWordPtr + 1 withDies:[boggleDie diesNearBy]]) {
                    [selectedDieArray insertObject:boggleDie atIndex:0];
                    [boggleDie setSelected:YES];
                    result = YES;
                }
                [boggleDie setMark:NO];
            }
        }
    } else {
        result = YES;
    }
    return result;
}

- (BOOL)_setBoggleDiesWithPosition:(const char *)newBoggleDieValues setDiesArrayPtr:(JBBoggleDie * *)newSetDiesArrayPtr unsetDiesArrayPtr:(JBBoggleDie * *)newUnsetDiesArrayPtr level:(int)newLevel
{
    int i;
    BOOL result = NO;
    
    i = 16;
    if(newLevel == 0) {
        result = YES;
    } else {
        while(i-- && !result) {
            JBBoggleDie * boggleDie;
            
            boggleDie = newUnsetDiesArrayPtr[i];
            if([boggleDie containsLetter:*newBoggleDieValues]) {
                *newSetDiesArrayPtr = boggleDie;
                newUnsetDiesArrayPtr[i] = nil;
                result = [self _setBoggleDiesWithPosition:newBoggleDieValues + 1 setDiesArrayPtr:newSetDiesArrayPtr + 1 unsetDiesArrayPtr:newUnsetDiesArrayPtr level:newLevel - 1];
                if(!result) {
                    newUnsetDiesArrayPtr[i] = boggleDie;
                }
            }
        }
    }
    return result;
}

@end