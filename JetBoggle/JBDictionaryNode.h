//
//  JBDictionaryNode.h
//  Boggle
//
//  Created by jerome on Sat Jun 23 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBDictionaryNode;
@class JBBoggleDie;
#define NUMBEROFLETTERS 26

@interface JBDictionaryNode : NSObject
{
    JBDictionaryNode * dictionaryNodes[NUMBEROFLETTERS];
    NSMutableArray * wordArray;
    int depth;
}

- (id)initWithDepth:(int)depth;
- (int)depth;
- (JBDictionaryNode *)dictionaryNodeWithLetter:(char)newLetter;
- (NSArray *)words;
- (BOOL)addWord:(const char *)newWordPtr cursor:(const char *)newCursorPtr;
- (BOOL)removeWord:(const char *)newWordPtr cursor:(const char *)newCursorPtr;
- (NSArray *)testWord:(const char *)newWordPtr;
@end
