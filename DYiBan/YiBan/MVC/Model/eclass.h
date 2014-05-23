//
//  eclass.h
//  Yiban
//
//  Created by Hyde.Xu on 13-2-18.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
@interface eclass : MagicJSONReflection{
    
}
@property (retain,nonatomic) NSString *userid;
@property (retain,nonatomic) NSString *name;
@property (retain,nonatomic) NSString *active;
@property (retain,nonatomic) NSString *id;//班级ID
@property (retain,nonatomic) NSString *pic;
@property (retain,nonatomic) NSString *year;
@property (retain,nonatomic) NSString *college;

@end
