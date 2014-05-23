//
//  Dragon_UILabel.m
//  DragonFramework
//
//  Created by NewM on 13-4-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UILabel.h"
#import <CoreText/CoreText.h>
#import "NSObject+DragonProperty.h"
#import "NSObject+DragonTypeConversion.h"
#import "Dragon_UILabelImgView.h"

@interface DragonUILabel ()
{
    NSMutableDictionary *_dict_font;//字体
    NSMutableDictionary *_dict_color;//颜色
    NSMutableDictionary *_dict_selfImg;//自定义图片
    NSMutableDictionary *_dict_autoImg;//自动图片
    NSMutableDictionary *_dict_click;//点击
    
    NSMutableArray      *_arr_imgLoc;//图片的loc
    NSMutableArray *_arr_autoImgkey;//图片的 arr 为了排序
    
    NSMutableDictionary *_dict_click_color;//点击时字体颜色和原始颜色
    NSMutableDictionary *_dict_click_value;//字体所代的值
    
    BOOL isTouchAciton;
    
    //创建AttributeString
    NSMutableAttributedString *string;
    
}
@property (nonatomic, assign)NSInteger realLineNum;//真正的行数
@end

@implementation DragonUILabel
@synthesize linesSpacing = _linesSpacing;
@synthesize chartSpacing = _chartSpacing;
@synthesize needCoretext = _needCoretext;
@synthesize maxLineNum = _maxLineNum, realLineNum = _realLineNum, fontFitToSize = _fontFitToSize;

DEF_SIGNAL(TOUCHESBEGAN)
DEF_SIGNAL(TOUCHESMOVED)
DEF_SIGNAL(TOUCHESENDED)
DEF_SIGNAL(TOUCHESCANCEL)

- (void)initSelf
{
    
    self.needCoretext = NO;
    
    self.chartSpacing = 0;
    self.linesSpacing = 5.f;
    
    _dict_font = [[NSMutableDictionary alloc] initWithCapacity:4];
    _dict_color = [[NSMutableDictionary alloc] initWithCapacity:4];
    _dict_selfImg = [[NSMutableDictionary alloc] initWithCapacity:3];
    _dict_autoImg = [[NSMutableDictionary alloc] initWithCapacity:5];
    _arr_autoImgkey = [[NSMutableArray alloc] initWithCapacity:5];
    
    _dict_click = [[NSMutableDictionary alloc] initWithCapacity:3];
    _arr_imgLoc = [[NSMutableArray alloc] initWithCapacity:1];
    
    _dict_click_color = [[NSMutableDictionary alloc] initWithCapacity:1];
    _dict_click_value = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    isTouchAciton = NO;
}

- (void)dealloc
{
    
    RELEASEDICTARRAYOBJ(_dict_color);
    RELEASEDICTARRAYOBJ(_dict_font);
    RELEASEDICTARRAYOBJ(_dict_selfImg)
    RELEASEDICTARRAYOBJ(_dict_autoImg)
    RELEASEDICTARRAYOBJ(_arr_autoImgkey)
    RELEASEDICTARRAYOBJ(_dict_click);
    RELEASEDICTARRAYOBJ(_arr_imgLoc);
    
    RELEASEDICTARRAYOBJ(_dict_click_color);
    RELEASEDICTARRAYOBJ(_dict_click_value);
    
    RELEASEOBJ(string);
    
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000

#undef UILineBreakModeCharacterWrap
#define UILineBreakModeCharacterWrap NSLineBreakByCharWrapping
#undef UILineBreakModeTailTruncation
#define UILineBreakModeTailTruncation NSLineBreakByTruncatingTail

#else

//    #undef UILineBreakModeCharacterWrap
//    #define UILineBreakModeCharacterWrap UILineBreakModeCharacterWrap
//    #undef UILineBreakModeTailTruncation
//    #define UILineBreakModeTailTruncation UILineBreakModeCharacterWrap

#endif

- (void)setNeedCoretext:(BOOL)needCoretext
{
    _needCoretext = needCoretext;
    if (needCoretext)
    {
        [self setLineBreakMode:UILineBreakModeCharacterWrap];
        [self autoHeight];
    }else
    {
        [self setLineBreakMode:UILineBreakModeTailTruncation];
    }
    [self setNeedsDisplay];
}

- (void)setLinesSpacing:(CGFloat)linesSpacing
{
    _linesSpacing = linesSpacing;
    [self setNeedsDisplay];
}

- (void)setChartSpacing:(long)chartSpacing
{
    _chartSpacing = chartSpacing;
    [self setNeedsDisplay];
}

//删除dict重复定义loc
- (void)deleteRepetitionDict:(NSMutableDictionary *)dict loc:(NSString *)loc length:(NSString *)length
{
    for (int i = 0; i < [[dict allKeys] count]; i++)
    {
        NSString *key = [[dict allKeys] objectAtIndex:i];
        NSArray *keyArr = [key componentsSeparatedByString:@","];
        NSString *fKey = [keyArr objectAtIndex:0];
        NSString *sKey = [keyArr objectAtIndex:1];
        
        if ([fKey isEqualToString:loc])
        {
            if ([sKey integerValue] != [length integerValue])
            {
                [dict removeObjectForKey:key];
                i--;
                //增加容错机制
                if (i < 0)
                {
                    break;
                }
            }
        }
        
    }
    
}

- (DragonUILabelC)COLOR
{
    DragonUILabelC block = ^DragonUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        
        NSString *loc = [first asNSString];
        NSString *length = [va_arg(args, NSString *) asNSString];
        NSString *length2 = [length copy];
        CGColorRef *color = va_arg(args, CGColorRef *);
        
        length = [NSString stringWithFormat:@"%@,%@", loc, length];
        DLogInfo(@"legth2 == %@", length);
        [_dict_color setValue:(id)color forKey:length];
        
        //删除重复的定义loc
        [self deleteRepetitionDict:_dict_color loc:loc length:length2];
        
        RELEASEOBJ(length2);
        
        [self setNeedsDisplay];
        
        return self;
        
    };
    return [[block copy] autorelease];
}

- (DragonUILabelC)FONT
{
    
    DragonUILabelF block = ^DragonUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *loc = [first asNSString];
        NSString *loc2 = [loc copy];
        NSString *length = [va_arg(args, NSString *)asNSString];
        NSString *size = [va_arg(args, NSString *)asNSString];
        loc = [NSString stringWithFormat:@"%@,%@", loc, length];
        
        [_dict_font setValue:size forKey:loc];
        
        //删除重复的定义loc
        [self deleteRepetitionDict:_dict_color loc:loc2 length:length];
        
        RELEASEOBJ(loc2);
        
        [self setNeedsDisplay];
        
        return self;
    };
    return [[block copy] autorelease];
}

- (DragonUILabelAI)IMGA
{
    DragonUILabelAI block = ^DragonUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *imgName = [first asNSString];
        
        NSMutableString *valueString = [[NSMutableString alloc] init];
        
        NSInteger loc = va_arg(args, NSInteger);
        NSString *width = va_arg(args, NSString *);
        NSString *height = va_arg(args, NSString *);
        
        [valueString appendFormat:@"%d,%@,%@",loc,width,height];
        
        [_arr_autoImgkey addObject:valueString];
        [_dict_autoImg setValue:imgName forKey:valueString];
        
        [_arr_imgLoc addObject:[NSString stringWithFormat:@"%d", loc]];
        
        DLogInfo(@"_dict_selfImg === %@", _dict_autoImg);
        va_end(args);
        RELEASEOBJ(valueString);
        
        [self setNeedsDisplay];
        return self;
    };
    return [[block copy] autorelease];
}

- (DragonUILabelI)IMG
{
    DragonUILabelI block = ^DragonUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *imgName = [first asNSString];
        
        NSMutableString *valueString = [[NSMutableString alloc] init];
        int i = 0;
        for (; i < 4;i++)
        {
            
            NSObject *valueObj = [va_arg(args, NSObject *) asNSString];
            if (!valueObj )
            {
                break;
            }
            
            [valueString appendFormat:@"%@,",valueObj];
            
        }
        
        NSString *loString = [valueString substringToIndex:([valueString length]-1)];
        
        
        [_dict_selfImg setValue:imgName forKey:loString];
        
        va_end(args);
        loString = nil;
        RELEASEOBJ(valueString);
        
        [self setNeedsDisplay];
        return self;
    };
    return [[block copy] autorelease];
    
    
}

- (DragonUILabelCl)CLICK
{
    DragonUILabelCl block = ^DragonUILabel * (id first, ...)
    {
        va_list args;
        va_start(args, first);
        self.userInteractionEnabled = YES;
        NSString *loc = [first asNSString];
        NSString *length = [va_arg(args, NSString *) asNSString];
        NSString *length2 = [length copy];
        CGColorRef *color = va_arg(args, CGColorRef *);
        NSString *value = [va_arg(args, NSString *) asNSString];
        length = [NSString stringWithFormat:@"%@,%@", loc, length];
        DLogInfo(@"legth == %@", length);
        [_dict_click setValue:(id)color forKey:length];
        [_dict_click_value setValue:value forKey:length];
        
        //删除重复的定义loc
        [self deleteRepetitionDict:_dict_color loc:loc length:length2];
        
        RELEASEOBJ(length2);
        
        return self;
    };
    
    return [[block copy] autorelease];
    
}

//设置点击的文字的颜色
- (NSString *)highlightLinksWithIndex:(CFIndex)index isEndClick:(BOOL)isEndClick
{
    NSMutableDictionary *doDict = _dict_click;
    if (isEndClick)
    {
        doDict = _dict_click_color;
    }
    for (int i = 0; i < [[doDict allKeys] count]; i++)
    {
        NSString *rangeS = [[doDict allKeys] objectAtIndex:i];
        
        UIColor *value = [doDict objectForKey:[[doDict allKeys] objectAtIndex:i]];
        
        
        NSArray *ranArr = [rangeS componentsSeparatedByString:@","];
        NSUInteger uLoc = 0;
        NSUInteger uLength = 0;
        if ([ranArr count] == 2)
        {
            uLoc = [[ranArr objectAtIndex:0] integerValue];
            uLength = [[ranArr objectAtIndex:1] integerValue];
            
            
            if (self.text.length < (uLoc+uLength))//容错机制
            {
                break;
            }
            
            if (index < (uLength+uLoc-1) && index >= uLoc)
            {
                
                if (!isEndClick)
                {
                    
                    UIColor *originColor = [_dict_color objectForKey:rangeS];
                    
                    [_dict_click_color setValue:(id)originColor forKey:rangeS];
                    
                    
                }
                
                self.COLOR([ranArr objectAtIndex:0], [ranArr objectAtIndex:1], value);
                return rangeS;
                break;
            }
        }else
        {
            break;
            //            return nil;
        }
        
    }
    return nil;
    
}


//获得点击的text的位置
- (CFIndex)characterIndexAtPoint:(CGPoint)point
{
    NSUInteger idx = NSNotFound;
    NSUInteger clickLine = 0;
    NSUInteger numberOfLines = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, self.bounds.size.width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
//    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    numberOfLines = [linesArray count];
    
    if (CGRectContainsPoint(self.bounds, point))
    {
        DLogInfo(@"sss === %f", self.bounds.size.height/numberOfLines);
        
        for (int i = 0; i < numberOfLines; i++)
        {
            if (point.y < (self.bounds.size.height/numberOfLines)*(i+1))
            {
                clickLine = i;
                
                CTFrameRef frame = [self allocFrame];
                
                CGPoint lineOrigins[numberOfLines];
                CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
                DLogInfo(@"lineOrigins[clickLine].x == %f", lineOrigins[clickLine].x);
                DLogInfo(@"lineOrigins[clickLine].y == %f", lineOrigins[clickLine].y);
                CGPoint lineOrigin = lineOrigins[clickLine];
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                CFArrayRef lines = CTFrameGetLines(frame);
                CFIndex linesCount = CFArrayGetCount(lines);
                if (linesCount <= clickLine)
                {
                    break;
                }
                CTLineRef line = CFArrayGetValueAtIndex(lines, clickLine);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                for (int j = 0; j < [_arr_imgLoc count]; j++)
                {
                    NSUInteger loc = [[_arr_imgLoc objectAtIndex:j] integerValue];
                    if (loc > idx)
                    {
                        idx -= j*2;
                        break;
                    }
                    
                    if (j == ([_arr_imgLoc count] - 1))
                    {
                        idx -= [_arr_imgLoc count]*2;
                    }
                }
                
                DLogInfo(@"idx === %d", idx);
                
                break;
            }
        }
        
    }
    
    DLogInfo(@"lineNumber === %d", clickLine);
    
    
    
    return idx;
    
}

void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat imgWidth;
CGFloat imgHeight;
CGFloat RunDelegateGetAscentCallback( void *refCon ){
    return imgHeight;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    return imgWidth;//[UIImage imageNamed:imageName].size.width;
}

- (CTFrameRef)allocFrame
{
    
    //创建AttributeString
    if (string)
    {
        RELEASEOBJ(string);
    }
    string = [[NSMutableAttributedString alloc]
              initWithString:self.text];
    
    /*字体颜色和字体大小一定要放到自动换图片上面因为自动换图片会自动增加两个空格就是2个字节*/
    //创建字体以及字体大小
    CTFontRef normalFont;
    
    
    //添加字体
    normalFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [string addAttribute:(id)kCTFontAttributeName
                   value:(id)normalFont
                   range:NSMakeRange(0, [string length])];
    if ([_dict_font count] > 0) {
        
        for (int i = 0; i < [[_dict_font allKeys] count]; i++)
        {
            int loc = 0;
            int length = 0;
            NSString *key = [[_dict_font allKeys] objectAtIndex:i];
            NSArray *keys = [key componentsSeparatedByString:@","];
            CGFloat size = [[_dict_font objectForKey:key] floatValue];
            
            if ([keys count] > 1)
            {
                loc = [[keys objectAtIndex:0] intValue];
                length = [[keys objectAtIndex:1] intValue];
            }
            
            normalFont = CTFontCreateWithName((CFStringRef)self.font.fontName, size, NULL);
            
            DLogInfo(@"text === %@", self.text);
            DLogInfo(@"textLenght === %d", self.text.length);
            if (self.text.length < (loc+length))//容错机制
            {
                break;
            }
            [string addAttribute:(id)kCTFontAttributeName
                           value:(id)normalFont
                           range:NSMakeRange(loc, length)];
        }
        
    }
    
    //设置字间距
    CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&_chartSpacing);
    
    [string addAttribute:(id)kCTKernAttributeName
                   value:(id)numberRef
                   range:NSMakeRange(0, [string length])];
    
    
    CFRelease(numberRef);
    
    //添加字体颜色
    
    [string addAttribute:(NSString *)kCTForegroundColorAttributeName
                   value:(id)self.textColor.CGColor
                   range:NSMakeRange(0, [string length])];
    if ([_dict_color count] > 0)
    {
        for (int i = 0; i < [_dict_color count]; i++)
        {
            int length = 0;
            int loc = 0;
            NSArray *key = [[[_dict_color allKeys] objectAtIndex:i] componentsSeparatedByString:@","];
            UIColor *value = [_dict_color objectForKey:[[_dict_color allKeys] objectAtIndex:i] ];
            if ([key count] > 1) {
                length = [[key objectAtIndex:1] intValue];
                loc = [[key objectAtIndex:0] intValue];
            }
            DLogInfo(@"text === %@", self.text);
            DLogInfo(@"textLenght === %d", self.text.length);
            if (self.text.length < (loc+length))//容错机制
            {
                break;
            }
            [string addAttribute:(id)kCTForegroundColorAttributeName
                           value:(id)value.CGColor
                           range:NSMakeRange(loc, length)];
        }
    }
    
    //预留空格的方法
    
    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"  "];//空格用于给图片留位置
    for (int i = 0; i < [_arr_autoImgkey count]; i++)
    {

        NSString *value = [_arr_autoImgkey objectAtIndex:i];
        NSArray *valueArray = [value componentsSeparatedByString:@","];
        NSString *imgName = [valueArray objectAtIndex:0];
        CGFloat width = [[valueArray objectAtIndex:1] floatValue];
        CGFloat height = [[valueArray objectAtIndex:2] floatValue];
        
        
        
        imgWidth = width;
        imgHeight = height;
        
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1;
        imageCallbacks.dealloc = RunDelegateDeallocCallback;
        imageCallbacks.getAscent = RunDelegateGetAscentCallback;
        imageCallbacks.getDescent = RunDelegateGetDescentCallback;
        imageCallbacks.getWidth = RunDelegateGetWidthCallback;
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, imgName);
        
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(id)runDelegate range:NSMakeRange(0, 1)];
        
        [string insertAttributedString:imageAttributedString atIndex:[[_arr_autoImgkey objectAtIndex:i] integerValue]];
        
        
        CFRelease(runDelegate);
    }
    RELEASEOBJ(imageAttributedString);
    
    
    //创建文本对齐方式
    CTTextAlignment alignment = CTTextAlignmentFromUINSORUITextAlignment(self.textAlignment);
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize = sizeof(CTTextAlignment);
    alignmentStyle.value = &alignment;
    
    
    //创建文本行间距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value = &_linesSpacing;
    
    
    //    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    //设置换行模式
    CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
    CTParagraphStyleSetting paragrapLinehStyle;//换行模式
    paragrapLinehStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    paragrapLinehStyle.valueSize = sizeof(CTLineBreakMode);
    paragrapLinehStyle.value = &coreTextLBMode;
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle,paragrapLinehStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
    
    //给字符串添加样式attribute
    [string addAttribute:(id)kCTParagraphStyleAttributeName
                   value:(id)paragraphStyle
                   range:NSMakeRange(0, [string length])];
    
    //控制布局
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,
                  NULL,
                  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                NULL);
    
    
    
    //释放
    CFRelease(paragraphStyle);
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(normalFont);
    //    [string release];
    
    return frame;
}

- (void)drawIMG:(CGContextRef)context frame:(CTFrameRef)frame;
{
    if ([[_dict_selfImg allValues] count] > 0)
    {
        for (int i = 0; i < [[_dict_selfImg allKeys] count]; i++)
        {
            CGContextSaveGState(context);//保存图层
            NSString *value = [[_dict_selfImg allKeys] objectAtIndex:i];
            NSString *imgName = [_dict_selfImg objectForKey:value];
            NSArray *valueArray = [value componentsSeparatedByString:@","];
            CGFloat xZhou = [[valueArray objectAtIndex:0] floatValue];
            CGFloat yZhou = [[valueArray objectAtIndex:1] floatValue];
            CGFloat width = [[valueArray objectAtIndex:2] floatValue];
            CGFloat height = [[valueArray objectAtIndex:3] floatValue];
            
            yZhou = self.bounds.size.height - height - yZhou;
            
            DragonUILabelImgView *img = [[DragonUILabelImgView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [img setCtFrame:(id)frame];
            [img setImgName:imgName];
            [img setImgBound:CGRectMake(xZhou, yZhou, width, height)];
            [img setBackgroundColor:[UIColor clearColor]];
            [self addSubview:img];
            [img release];
            CGContextRestoreGState(context);//恢复图层
        }
        
        //        [_dict_selfImg removeAllObjects];
    }
    
    
}

- (void)drawIMGA:(CGContextRef)context frame:(CTFrameRef)frame
{
    int i = 0;
    if ([[_dict_autoImg allKeys] count] > 0)
    {
        
        
        NSString *value = [_arr_autoImgkey objectAtIndex:i];
        NSString *imgName = [_dict_autoImg objectForKey:value];
        NSArray *valueArray = [value componentsSeparatedByString:@","];
        NSInteger loc = [[valueArray objectAtIndex:0] floatValue];
        CGFloat width = [[valueArray objectAtIndex:1] floatValue];
        CGFloat height = [[valueArray objectAtIndex:2] floatValue];
        
        NSUInteger lineNum = 0;
        CGFloat xZhou = 0;
        CGFloat yZhou = 0;
        
        {
            NSArray *lines = (NSArray *)CTFrameGetLines(frame);
            CGPoint origins [[lines count]];
            CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
            
            
            for (id lineObj in lines)
            {
                
                CTLineRef line = (CTLineRef)lineObj;
                
                for (id runObj in (NSArray *)CTLineGetGlyphRuns(line))
                {
                    
                    CTRunRef run = (CTRunRef)runObj;
                    CFRange runRange = CTRunGetStringRange(run);
                    CGRect runBounds;
                    CGFloat ascent;
                    CGFloat descent;
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                    runBounds.origin.x = origins[lineNum].x + xOffset;
                    runBounds.origin.y = origins[lineNum].y;
                    runBounds.origin.y -= descent;
                    if (runRange.location <= loc && runRange.location+runRange.length > loc)
                    {
                        xZhou = runBounds.origin.x+2;
                        yZhou = runBounds.origin.y - _linesSpacing/2 ;
                        
                        
                        CGContextSaveGState(context);//保存图层
                        
                        DragonUILabelImgView *img = [[DragonUILabelImgView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                        [img setCtFrame:(id)frame];
                        [img setImgName:imgName];
                        [img setImgBound:CGRectMake(xZhou, yZhou, width, height)];
                        [img setBackgroundColor:[UIColor clearColor]];
                        [self addSubview:img];
                        [img release];
                        
                        CGContextRestoreGState(context);//恢复图层
                        
                        i++;
                        if (i > [_arr_autoImgkey count]-1)
                        {
                            break;
                        }
                        
                        value = [_arr_autoImgkey objectAtIndex:i];
                        imgName = [_dict_autoImg objectForKey:value];
                        valueArray = [value componentsSeparatedByString:@","];
                        loc = [[valueArray objectAtIndex:0] floatValue];
                        width = [[valueArray objectAtIndex:1] floatValue];
                        height = [[valueArray objectAtIndex:2] floatValue];
                        
                    }
                    
                }
                lineNum++;
                
            }
            
            
            
        }
        
        
        //        [_dict_autoImg removeAllObjects];
        //        [_arr_autoImgkey removeAllObjects];
    }
    
}


- (void)drawTextInRect:(CGRect)rect
{
    //不需要coretext
    if (!_needCoretext)
    {
        [super drawTextInRect:rect];
        return;
    }
    
    CTFrameRef frame = [self allocFrame];
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    //翻转系统坐标（Core Text uses a Y-flipped coordinate system）
    //x，y轴方向移动
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.f, -1.f);
    
    //绘画
    CTFrameDraw(frame, context);
    
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);//保存图层
    
    if (!isTouchAciton)
    {
        [self drawIMG:context frame:frame];
        
        [self drawIMGA:context frame:frame];
    }
    
    
    
    CGContextRestoreGState(context);//恢复图层
    
    
    CFRelease(frame);
    
    //    isFished = YES;
    //    [_dict_color removeAllObjects];
    //    [_dict_font removeAllObjects];
    //    [_dict_click removeAllObjects];
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
}

- (void)autoHeight
{
    CTFrameRef frame = [self allocFrame];
    CGRect newFrame = self.frame;
    if (_fontFitToSize.width != 0)
    {
        newFrame.size.width = _fontFitToSize.width;
    }
    
    CGFloat height = [self getAttributedStringHeightWithString:newFrame.size.width];
    
    newFrame.size.height = height;
    [self setFrame:newFrame];
    
    CFRelease(frame);
    
}

//外部调用要在needcortext之后
- (void)autoFrame
{
    CTFrameRef frame = [self allocFrame];
    CGRect newFrame = self.frame;
    if (_fontFitToSize.width != 0)
    {
        newFrame.size.width = _fontFitToSize.width;
    }
    
    CGFloat height = [self getAttributedStringHeightWithString:newFrame.size.width];
    
    newFrame.size.height = height;
    
    if (_realLineNum == 1 && [_arr_autoImgkey count] > 0)
    {
        NSString *textString = self.text;
        CGFloat width = [textString sizeWithFont:self.font].width;
        
        CGFloat imgWidth = 0;
        for (int i = 0; i < [_arr_autoImgkey count]; i++)
        {
            NSString *value = [_arr_autoImgkey objectAtIndex:i];
            NSArray *valueArray = [value componentsSeparatedByString:@","];
            CGFloat width = [[valueArray objectAtIndex:1] floatValue];
            imgWidth += width;
        }
        
        newFrame.size.width = width + imgWidth + [_arr_autoImgkey count]*4;
    }
    
    [self setFrame:newFrame];
    
    CFRelease(frame);
}

- (CGFloat)getAttributedStringHeightWithString:(CGFloat)width
{
    CGFloat total_height = 0;
    if (!string) {
        return 0;
    }
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    //    self.numberOfLines = linesArray.count;
    if ([linesArray count] == 0)
    {
        return 0;
    }
    
    _realLineNum = [linesArray count];
    NSInteger lineNum = _realLineNum;
    if (_realLineNum > _maxLineNum && _maxLineNum != 0)
    {
        lineNum = _maxLineNum;
    }
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[lineNum -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:lineNum - 1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

/*
 kCTParagraphStyleSpecifierAlignment = 0,                 //对齐属性
 kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //首行缩进
 kCTParagraphStyleSpecifierHeadIndent = 2,                //段头缩进
 kCTParagraphStyleSpecifierTailIndent = 3,                //段尾缩进
 kCTParagraphStyleSpecifierTabStops = 4,                  //制表符模式
 kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //默认tab间隔
 kCTParagraphStyleSpecifierLineBreakMode = 6,             //换行模式
 kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //多行高
 kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //最大行高
 kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //最小行高
 kCTParagraphStyleSpecifierLineSpacing = 10,              //行距
 kCTParagraphStyleSpecifierParagraphSpacing = 11,         //段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
 kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //段落前间距 在一个段落的前面加上间隔。TOP
 kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //基本书写方向
 kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //最大行距
 kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //最小行距
 kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //行距调整
 kCTParagraphStyleSpecifierCount = 17,        //
 */
/*test
 UIImage* img = [UIImage imageNamed:@"icon2.png"];
 float width = 25;
 float height = 25;
 
 
 CGContextConcatCTM(context,
 CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height-height),
 1.f,
 1.f)
 );
 
 CGContextDrawImage(context, CGRectMake(10+14*3, -10-(14+_linesSpacing/2)*1, width, height), img.CGImage);*/
//c的写法
CTTextAlignment CTTextAlignmentFromUINSORUITextAlignment(NSTextAlignment textAlignment)
{
    switch (textAlignment) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
        case NSTextAlignmentCenter :
            return kCTCenterTextAlignment;
            
        case NSTextAlignmentRight :
            return kCTRightTextAlignment;
        case NSTextAlignmentLeft :
            return kCTLeftTextAlignment;
#else
        case NSTextAlignmentCenter | UITextAlignmentCenter:
            return kCTCenterTextAlignment;
            
        case NSTextAlignmentRight | UITextAlignmentRight:
            return kCTRightTextAlignment;
        case NSTextAlignmentLeft | UITextAlignmentLeft:
            return kCTLeftTextAlignment;
#endif
        default:
            return kCTLeftTextAlignment;
            break;
    }
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode)
{
    
	switch (lineBreakMode) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
		case NSLineBreakByWordWrapping:
            return kCTLineBreakByWordWrapping;
		case NSLineBreakByCharWrapping:
            return kCTLineBreakByCharWrapping;
		case NSLineBreakByClipping:
            return kCTLineBreakByClipping;
		case NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
		case NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
		case NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
#else
        case (UILineBreakModeWordWrap | NSLineBreakByWordWrapping):
            return kCTLineBreakByWordWrapping;
		case (UILineBreakModeCharacterWrap | NSLineBreakByCharWrapping):
            return kCTLineBreakByCharWrapping;
		case (UILineBreakModeClip | NSLineBreakByClipping):
            return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation | NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation | NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation | NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
#endif
		default:
            return 0;
	}
}

#pragma mark -
#pragma mark touchDelegate
CFIndex allIndex;
- (NSMutableDictionary *)touchInitSelf:(NSSet *)touches isEndClick:(BOOL)isEndClick
{
    UITouch *touch = [touches anyObject];
    
    if (!isEndClick)
    {
        allIndex = [self characterIndexAtPoint:[touch locationInView:self]];
    }
    
    CFIndex index = allIndex;
    
    NSString *range = [self highlightLinksWithIndex:index isEndClick:isEndClick];
    
    NSString *value = [_dict_click_value objectForKey:range];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:touch, @"touch", range, @"range", value, @"value", nil];
    
    return dict;
}

bool ifEnd;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isTouchAciton = YES;
    
    NSMutableDictionary *dict = [self touchInitSelf:touches isEndClick:NO];
    
    [self sendViewSignal:[DragonUILabel TOUCHESBEGAN] withObject:dict];
    
    [super touchesBegan:touches withEvent:event];
    ifEnd = NO;
    
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!ifEnd)
        {
            [self touchesEnded:touches withEvent:event];
            
        }
    });
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *dict = [self touchInitSelf:touches isEndClick:YES];
    
    [self sendViewSignal:[DragonUILabel TOUCHESMOVED] withObject:dict];
    
    [super touchesMoved:touches withEvent:event];
    ifEnd = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *dict = [self touchInitSelf:touches isEndClick:YES];
    
    [self sendViewSignal:[DragonUILabel TOUCHESENDED] withObject:dict];
    
    [super touchesEnded:touches withEvent:event];
    ifEnd = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *dict = [self touchInitSelf:touches isEndClick:YES];
    
    [self sendViewSignal:[DragonUILabel TOUCHESCANCEL] withObject:dict];
    
    [super touchesCancelled:touches withEvent:event];
    ifEnd = YES;
}

@end
