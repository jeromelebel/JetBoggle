//
//  JBBoggleTablePanelDelegate.h
//  Boggle
//
//  Created by jerome on Sun Jul 01 2001.
//  Copyright (c) 2001 __CompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class JBBoggleTable;

@interface JBBoggleTablePanelDelegate : NSObject
{
    NSMutableArray * selectedDies;
    JBBoggleTable * boggleTable;
    IBOutlet NSWindow * boggleTablePanel;
    IBOutlet NSPanel * dieValueEditorPanel;
    IBOutlet NSMatrix * dieValueMatrix;
    IBOutlet NSMatrix * dieValueEditorMatrix;
    IBOutlet NSProgressIndicator * timerProgressIndicator;
    IBOutlet NSButton * startPlayingButton;
}
- (id)initWithBoggleTable:(JBBoggleTable *)newBoggleTable;
- (void)boggleTableChangedNotification:(NSNotification *)newNotification;

- (IBAction)editDieValueAction:(id)sender;
- (IBAction)startGameAction:(id)sender;
- (IBAction)cancelBoggleDieValueAction:(id)sender;
- (IBAction)confirmBoggleDieValueAction:(id)sender;
- (IBAction)shuffleBoggleAction:(id)sender;
- (IBAction)turnBoggleAction:(id)sender;
@end
