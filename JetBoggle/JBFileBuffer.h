//
//  JBFileBuffer.h
//  Boggle
//
//  Created by jerome on Thu Jun 28 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BufferSize 4096

@interface JBFileBuffer : NSObject {
    FILE * filePtr;
    NSString * fileName;
    
    char buffer[BufferSize + 1];
    NSUInteger characterLeftInBuffer;
    char * bufferCursorPtr;
}
- (id)initWithFileName:(NSString *)newFileName;
- (BOOL)getNextLine:(char *)newBufferPtr bufferLength:(int)newBufferLength;
- (void)skipBlankCharacter;
- (void)loadBuffer;
@end
