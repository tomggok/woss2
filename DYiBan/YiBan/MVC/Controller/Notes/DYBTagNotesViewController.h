//
//  DYBTagNotesViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-11-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "tag_list_info.h"
#import "notes_list.h"

@interface DYBTagNotesViewController : DYBBaseViewController{
    tag_list_info *_tag_info;
    MagicUITableView *_tabTagNotes;
    MagicUISearchBar *_TagNoteSearch;
    notes_list *_notes_list;
    
    
    int nPage;
    int nPageSize;
    
    NSMutableArray *_arrayTagNotes;
    NSMutableArray *_arrayTagNotesCell;
    NSString *_strNoteID;
    NSIndexPath *_Noteindex;
    UIView *_viewWarning;
    NSString *_strSearchText;
}

-(id)initwithTaginfo:(tag_list_info *)tag_info;

AS_SIGNAL(REFRESHTB)

@end
