//
//  JBBoggleDie.m
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBBoggleDie.h"

@implementation JBBoggleDie

- (id)initWithLetterCString:(const char *)newLetterCString
{
    if (self = [super init]) {
        selectedLetter = 0;
        letterList = malloc(strlen(newLetterCString) + 1);
        strcpy(letterList, newLetterCString);
        mark = NO;
        selected = NO;
        diesNearByArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [diesNearByArray release];
    free(letterList);
    [super dealloc];
}

- (void)setCoordonateWithX:(int)newX y:(int)newY
{
    x = newX;
    y = newY;
}

- (int)x
{
    return x;
}

- (int)y
{
    return y;
}

- (char)value
{
    return letterList[selectedLetter];
}

- (BOOL)setValue:(char)newLetter
{
    const char * newSelectedLetterPtr;
    BOOL result;
    
    CORRECTLETTER(newLetter);
    newSelectedLetterPtr = index(letterList, newLetter);
    if(newSelectedLetterPtr != NULL) {
        selectedLetter = newSelectedLetterPtr - letterList;
        result = YES;
    } else {
        result = NO;
    }
    return result;
}

- (BOOL)mark
{
    return mark;
}

- (void)setMark:(BOOL)newMark
{
    mark = newMark;
}

- (void)setDeNearBy:(NSArray *)newDeNearByArray
{
    [diesNearByArray removeAllObjects];
    [diesNearByArray addObjectsFromArray:newDeNearByArray];
}

- (void)setSelected:(BOOL)newSelected
{
    selected = newSelected;
}

- (BOOL)selected
{
    return selected;
}

- (NSArray *)diesNearBy
{
    return diesNearByArray;
}

- (void)shuffle
{
    selectedLetter = random() % strlen(letterList);
}

- (NSString *)description
{
    char buffer[2];
    
    buffer[0] = letterList[selectedLetter];
    buffer[1] = 0;
    return [NSString stringWithUTF8String:buffer];
}

- (BOOL)containsLetter:(char)newLetter
{
    CORRECTLETTER(newLetter);
    return index(letterList, newLetter) != NULL;
}

@end
