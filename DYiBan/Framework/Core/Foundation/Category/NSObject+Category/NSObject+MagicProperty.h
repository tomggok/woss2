//
//  NSObject+MagicProperty.h
//  MagicFramework
//
//  Created by NewM on 13-3-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - as_static_property

#undef  AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY(_name)\
        @property (nonatomic, readonly) NSString *_name;\
        + (NSString *)_name;

#pragma mark - define

#undef  DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY(_name)\
        @dynamic _name;\
        + (NSString *)_name\
        {\
            static NSString *_local = nil;\
            if (!_local)\
            {\
                _local = [[NSString stringWithFormat:@"%s",#_name] retain];\
            }\
            return _local;\
        }

#undef  DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3(_name, _prefix, _prefix2)\
        @dynamic _name;\
        + (NSString *)_name\
        {\
            static NSString *_local = nil;\
            if (!_local)\
            {\
                _local = [[NSString stringWithFormat:@"%@.%@.%s",_prefix,_prefix2,#_name] retain];\
            }\
            return _local;\
        }

#pragma mark - as_static_property_int
#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( _name ) \
        @property (nonatomic, readonly) NSInteger _name; \
        + (NSInteger)_name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( _name, _value ) \
        @dynamic _name; \
        + (NSInteger)_name \
        { \
            return _value; \
        }

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT


#pragma mark - releaseobj
#undef RELEASE
#define RELEASE(_obj)\
        [_obj release];

#undef RELEASEDICTARRAYOBJ
#define RELEASEDICTARRAYOBJ(_obj)\
        [_obj removeAllObjects];\
        RELEASE(_obj)\
        _obj = nil;

#undef RELEASEOBJ
#define RELEASEOBJ(_obj)\
        RELEASE(_obj)\
        _obj = nil;

#undef RELEASEALLSUBVIEW
#define RELEASEALLSUBVIEW(_obj)\
        NSArray *allView = [_obj subviews];\
        for (UIView *view in allView)\
        {\
            [view removeFromSuperview]; \
            view = nil;\
        }

#undef REMOVEFROMSUPERVIEW
#define REMOVEFROMSUPERVIEW(_obj)\
        [_obj removeFromSuperview];\
        _obj = nil;

#undef RELEASEVIEW
#define RELEASEVIEW(_obj)\
        [_obj removeFromSuperview]; \
        RELEASE(_obj)\
        _obj = nil;

#undef AUTORELEASE
#define AUTORELEASE(_obj)\
        [_obj autorelease];


#pragma mark - commentMethod


#undef MAINFRAME
#define MAINFRAME\
        [MagicCommentMethod mainFrame];

#undef MAINSIZE
#define MAINSIZE\
        [MagicCommentMethod mainFrame].size;

#undef CHANGEFRAMESIZE
#define CHANGEFRAMESIZE(_obj, _obj2, _obj3)\
        _obj = CGRectMake(_obj.origin.x, _obj.origin.y, _obj2, _obj3);

#undef CHANGEFRAMEORIGIN
#define CHANGEFRAMEORIGIN(_obj, _obj2, obj3)\
        _obj = CGRectMake(_obj2, obj3, _obj.size.width, _obj.size.height);






