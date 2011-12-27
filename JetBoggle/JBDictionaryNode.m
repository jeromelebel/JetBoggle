//
//  JBDictionaryNode.m
//  Boggle
//
//  Created by jerome on Sat Jun 23 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBDictionaryNode.h"
#import "JBBoggleDie.h"

#define INDEXWITHLETTER(letter) (letter - 'a')
#define USELESSCHARACTER(letter) ((letter == '-') || (letter == '\''))
#define CORRECTLETTERFORDICTIONARY(letter) {\
    if((letter == '‡') || (letter == 'ˆ') || (letter == '‰') || (letter == 'Š')) {\
        letter = 'a';\
    } else if((letter == 'Ž') || (letter == '') || (letter == '') || (letter == '‘')) {\
        letter = 'e';\
    } else if((letter == '’') || (letter == '“') || (letter == '”') || (letter == '•')) {\
        letter = 'i';\
    } else if((letter == '—') || (letter == '˜') || (letter == '™') || (letter == 'š')) {\
        letter = 'o';\
    } else if((letter == 'œ') || (letter == '') || (letter == 'ž') || (letter == 'Ÿ')) {\
        letter = 'u';\
    } else if(letter == '') {\
        letter = 'c';\
    } else if((letter >= 'A') && (letter <= 'Z')) {\
        letter = letter - 'A' + 'a';\
    } else if(((letter < 'a') || (letter > 'z')) && !USELESSCHARACTER(letter)) {\
        printf("%d %c %d %c\n", letter, letter, (unsigned char)letter, (unsigned char)letter);\
        letter = 'a';\
    }\
}
//        NSLog(@"problem with character %d %c %s:%d", (unsigned char)letter, letter, __FILE__, __LINE__);

@implementation JBDictionaryNode

- (id)initWithDepth:(int)newDepth
{
    if (self = [super init]) {
        int i;
        
        depth = newDepth;
        for(i = 0; i < NUMBEROFLETTERS; i++) {
            dictionaryNodes[i] = nil;
        }
        wordArray = nil;
    }
    return self;
}

- (void)dealloc
{
    int i;
    
    for(i = 0; i < NUMBEROFLETTERS; i++) {
        [dictionaryNodes[i] release];
    }
    [wordArray release];
    [super dealloc];
}

- (int)depth
{
    return depth;
}

- (NSArray *)words
{
    return wordArray;
}

- (BOOL)addWord:(const char *)newWordPtr cursor:(const char *)newCursorPtr
{
    int index;
    BOOL result = NO;
    
    index = newCursorPtr[0];
    while(USELESSCHARACTER(index)) {
        newCursorPtr++;
        index = newCursorPtr[0];
    }
    if(!index) {
        NSString * word;
        
        word = [[NSString alloc] initWithUTF8String:newWordPtr];
        if(!wordArray) {
            wordArray = [[NSMutableArray alloc] init];
        }
        [wordArray addObject:word];
        [word release];
    } else {
        JBDictionaryNode * nextNode;

        CORRECTLETTERFORDICTIONARY(index);
        index = INDEXWITHLETTER(index);
        nextNode = dictionaryNodes[index];
        if(!nextNode) {
            nextNode = dictionaryNodes[index] = [[JBDictionaryNode alloc] initWithDepth:depth + 1];
        }
        [nextNode addWord:newWordPtr cursor:newCursorPtr + 1];
    }
    return result;
}

- (BOOL)removeWord:(const char *)newWordPtr cursor:(const char *)newCursorPtr
{
    int index;
    BOOL result = NO;
    
    index = newCursorPtr[0];
    while(USELESSCHARACTER(index)) {
        newCursorPtr++;
        index = newCursorPtr[0];
    }
    if(!index) {
        if(wordArray) {
            NSString * word;
            int i;
        
            word = [[NSString alloc] initWithUTF8String:newWordPtr];
            [wordArray removeObject:word];
            [word release];
            if([wordArray count] == 0) {
                [wordArray release];
                wordArray = NULL;
            }
            result = YES;
            i = NUMBEROFLETTERS;
            while(i-- && result) {
                result = dictionaryNodes[i] == NULL;
            }
        }
    } else {
        JBDictionaryNode * nextNode;

        CORRECTLETTERFORDICTIONARY(index);
        index = INDEXWITHLETTER(index);
        nextNode = dictionaryNodes[index];
        if(!nextNode) {
            nextNode = dictionaryNodes[index] = [[JBDictionaryNode alloc] initWithDepth:depth + 1];
        }
        if([nextNode removeWord:newWordPtr cursor:newCursorPtr + 1]) {
            int i;
            
            [nextNode release];
            dictionaryNodes[index] = NULL;
            result = YES;
            i = NUMBEROFLETTERS;
            while(i-- && result) {
                result = dictionaryNodes[i] == NULL;
            }
        }
    }
    return result;
}

- (NSArray *)testWord:(const char *)newWordPtr
{
    int index;
    NSArray * result = NULL;
    
    index = newWordPtr[0];
    if(USELESSCHARACTER(index)) {
        newWordPtr++;
        index = newWordPtr[0];
    }
    if(!index) {
        result = wordArray;
    } else {
        JBDictionaryNode * nextNode;
        
        CORRECTLETTERFORDICTIONARY(index);
        index = INDEXWITHLETTER(index);
        nextNode = dictionaryNodes[index];
        if(nextNode) {
            result = [nextNode testWord:newWordPtr + 1];
        }
    }
    return result;
}

- (JBDictionaryNode *)dictionaryNodeWithLetter:(char)newLetter
{
    CORRECTLETTERFORDICTIONARY(newLetter);
    return dictionaryNodes[INDEXWITHLETTER(newLetter)];
}

@end
