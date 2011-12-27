//
//  JBBoggleDie.h
//  Boggle
//
//  Created by jerome on Fri Jun 22 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CORRECTLETTER(letter) {\
    if((letter == '‡') || (letter == 'ˆ') || (letter == '‰') || (letter == 'Š') || (letter == 'Œ') || (letter == 'ç') || (letter == 'Ë') || (letter == 'å') || (letter == '€') || (letter == '')) {\
        letter = 'A';\
    } else if((letter == 'Ž') || (letter == '') || (letter == '') || (letter == '‘') || (letter == 'ƒ') || (letter == 'é') || (letter == 'æ') || (letter == 'è')) {\
        letter = 'E';\
    } else if((letter == '’') || (letter == '“') || (letter == '”') || (letter == '•') || (letter == 'ê') || (letter == 'í') || (letter == 'ë') || (letter == 'ì')) {\
        letter = 'I';\
    } else if((letter == '—') || (letter == '˜') || (letter == '™') || (letter == 'š') || (letter == 'î') || (letter == 'ñ') || (letter == 'ï') || (letter == '…')) {\
        letter = 'O';\
    } else if((letter == 'œ') || (letter == '') || (letter == 'ž') || (letter == 'Ÿ') || (letter == 'ò') || (letter == 'ô') || (letter == 'ó') || (letter == '†')) {\
        letter = 'U';\
    } else if((letter == '') || (letter == '‚')) {\
        letter = 'C';\
    } else if((letter == '–') || (letter == '„')) {\
        letter = 'N';\
    } else if((letter >= 'a') && (letter <= 'z')) {\
        letter = letter - 'a' + 'A';\
    } else if((letter < 'A') || (letter > 'Z')) {\
        printf("%d %c %d %c\n", letter, letter, (unsigned char)letter, (unsigned char)letter);\
        letter = 'A';\
    }\
}

@interface JBBoggleDie : NSObject
{
    NSUInteger selectedLetter;
    char * letterList;
    BOOL mark;
    BOOL selected;
    NSMutableArray * diesNearByArray;
    int x;
    int y;
}
- (id)initWithLetterCString:(const char *)newLetterCString;
- (BOOL)setValue:(char)newValue;
- (char)value;
- (BOOL)mark;
- (int)x;
- (int)y;
- (void)setCoordonateWithX:(int)newX y:(int)newY;
- (void)setSelected:(BOOL)newSelected;
- (BOOL)selected;
- (void)setMark:(BOOL)newMark;
- (void)setDeNearBy:(NSArray *)newDeNearByArray;
- (NSArray *)diesNearBy;
- (void)shuffle;
- (BOOL)containsLetter:(char)newLetter;
@end
