//
//  JBDictionary.h
//  Boggle
//
//  Created by jerome on Thu Jun 28 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AddedDictionaryWordPreference @"AddedDictionaryWord"
#define RemovedDictionaryWordPreference @"RemovedDictionaryWord"

@class JBDictionaryNode;

@interface JBDictionary : NSObject
{
    NSMutableArray * addedWordArray;
    NSMutableArray * removedWordArray;
    JBDictionaryNode * dictionaryNode;
    NSString * fileName;
    int numberOfWord;
}

- (id)initWithFileName:(NSString *)newFileName;
- (void)loadDictionary;
- (JBDictionaryNode *)dictionaryNode;
- (NSArray *)testWord:(NSString *)newWord;
@end
