//
//  DYBCheckMultiImageViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBCheckMultiImageViewController : DYBBaseViewController{
    NSArray *_arrIMG;
    NSInteger _nSel;
    NSInteger _curSel;
}

- (id)initWithMultiImage:(NSArray *)arrIMG nCurSel:(NSInteger)nSel;

@end
