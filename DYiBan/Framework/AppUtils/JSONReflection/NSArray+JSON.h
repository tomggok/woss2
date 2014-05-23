//
//  NSArray+JSON.h
//  Magic
//
//  Created by Zzl on 13-3-18.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

- (NSMutableArray *) arrayToDictonaryArray;
- (NSMutableArray *) dictionaryArrayToArray:(Class) genericType;
@end
