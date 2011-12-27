//
//  Dictionary.m
//  Boggle
//
//  Created by jerome on Thu Jun 28 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBDictionary.h"
#import "JBDictionaryNode.h"
#import "JBFileBuffer.h"

@implementation JBDictionary

- (id)initWithFileName:(NSString *)newFileName
{
    if (self = [super init]) {
        fileName = [newFileName retain];
        dictionaryNode = [[JBDictionaryNode alloc] initWithDepth:0];
        addedWordArray = [[NSMutableArray alloc] init];
        removedWordArray = [[NSMutableArray alloc] init];
        numberOfWord = 0;
        [self loadDictionary];
    }
    return self;
}

- (void)dealloc
{
    [fileName release];
    [addedWordArray release];
    [removedWordArray release];
    [dictionaryNode release];
    [fileName release];
    [super dealloc];
}

- (void)loadDictionary
{
    JBFileBuffer * fileBuffer;
    char buffer[256];
    NSEnumerator * enumerator;
    NSString * word;
    NSUserDefaults * standardUserDefaults;
    
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [addedWordArray release];
    addedWordArray = [standardUserDefaults objectForKey:AddedDictionaryWordPreference];
    if(addedWordArray) {
        addedWordArray = [[NSMutableArray alloc] init];
    }
    [removedWordArray release];
    removedWordArray = [standardUserDefaults objectForKey:RemovedDictionaryWordPreference];
    if(removedWordArray) {
        removedWordArray = [[NSMutableArray alloc] init];
    }
    fileBuffer = [[JBFileBuffer alloc] initWithFileName:fileName];
    while([fileBuffer getNextLine:buffer bufferLength:256]) {
        [dictionaryNode addWord:buffer cursor:buffer];
    }
    enumerator = [removedWordArray objectEnumerator];
    while(word = [enumerator nextObject]) {
        [dictionaryNode removeWord:[word UTF8String] cursor:[word UTF8String]];
    }
    enumerator = [addedWordArray objectEnumerator];
    while(word = [enumerator nextObject]) {
        [dictionaryNode addWord:[word UTF8String] cursor:[word UTF8String]];
    }
    [fileBuffer release];
}

- (JBDictionaryNode *)dictionaryNode
{
    return dictionaryNode;
}

- (void)addWord:(NSString *)newWord
{
    if([dictionaryNode addWord:[newWord UTF8String] cursor:[newWord UTF8String]]) {
        numberOfWord++;
    }
}

- (NSArray *)testWord:(NSString *)newWord
{
    return [dictionaryNode testWord:[newWord UTF8String]];
}

@end
