//
//  JBFileBuffer.m
//  Boggle
//
//  Created by jerome on Thu Jun 28 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import "JBFileBuffer.h"

#define BLANKCHARACTER(x) ((x == ' ') || (x == '\r') || (x == '\n'))
#define NEXTCHARACTER {\
    bufferCursorPtr++;\
    characterLeftInBuffer--;\
    if(!characterLeftInBuffer) {\
        [self loadBuffer];\
    }\
}

@implementation JBFileBuffer

- (id)initWithFileName:(NSString *)newFileName
{
    [super init];
    fileName = [newFileName retain];
    filePtr = fopen([fileName fileSystemRepresentation], "r");
    characterLeftInBuffer = 0;
    bufferCursorPtr = buffer;
    return self;
}

- (void)dealloc
{
    [fileName release];
    [super dealloc];
}

- (BOOL)getNextLine:(char *)newBufferPtr bufferLength:(int)newBufferLength
{
    BOOL result;
    
    if(!characterLeftInBuffer) {
        [self loadBuffer];
    }
    [self skipBlankCharacter];
    if(characterLeftInBuffer) {
        result = YES;
        if(newBufferLength > 0) {
            newBufferLength--;
        } else {
            newBufferPtr = NULL;
        }
        while(characterLeftInBuffer && !BLANKCHARACTER(*bufferCursorPtr)) {
            if(newBufferLength && newBufferPtr) {
                *newBufferPtr = *bufferCursorPtr;
                newBufferLength--;
                newBufferPtr++;
            }
            NEXTCHARACTER;
        }
        if(newBufferPtr) {
            *newBufferPtr = 0;
        }
    } else {
        result = NO;
    }
    return result;
}

- (void)skipBlankCharacter
{
    if(!characterLeftInBuffer) {
        [self loadBuffer];
    }
    while(characterLeftInBuffer && BLANKCHARACTER(*bufferCursorPtr)) {
        NEXTCHARACTER;
    }
}

- (void)loadBuffer
{
    if(filePtr) {
        memcpy(buffer, bufferCursorPtr, BufferSize - characterLeftInBuffer);
        characterLeftInBuffer = fread(buffer + characterLeftInBuffer, 1, BufferSize - characterLeftInBuffer, filePtr) + characterLeftInBuffer;
        bufferCursorPtr = buffer;
    }
}

@end
