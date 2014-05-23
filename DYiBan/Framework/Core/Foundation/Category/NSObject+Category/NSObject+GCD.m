//
//  NSObject+GCD.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+GCD.h"
#import "objc/runtime.h"

@implementation NSObject (GCD)

@dynamic stringProperty;

static char _c_stringProperty;
-(void)set_constrainedFont:(NSString *)stringProperty
{
    objc_setAssociatedObject(self, &_c_stringProperty, stringProperty, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIView *)stringProperty
{
    return objc_getAssociatedObject(self, &_c_stringProperty);
}

#pragma mark- 多线程/并发/闭包(Block Objects)/在主线程中异步执行类似于在其他线程执行任务,首选前者

#pragma mark-独立Block Objects

    //oc函数得到2个int值的差
-(NSInteger)subtract:(NSInteger)paramValue from:(NSInteger)paramFrom
{
    return paramFrom-paramValue;
}

    //c函数得到2个int值的差,注释掉是因为和下边的Block Object代码方式得到2个int值的差重名
    //NSInteger subtract(NSInteger paramValue,NSInteger paramFrom)
    //{
    //    return paramFrom-paramValue;
    //}

    //Block Object代码方式得到2个int值的差
NSInteger(^subtract)(NSInteger,NSInteger)=^(NSInteger paramValue,NSInteger paramFrom)
{
    return paramFrom-paramValue;
};

    //C函数把int值转换成str,注释掉是因为和下边的Block Object代码方式把int值转换成str的方法重名
    //NSString * intToString (NSInteger paramInteger)
    //{
    //    return [NSString stringWithFormat:@"%lu",(unsigned long)paramInteger];
    //}

    //Block Object代码方式把int值转换成str
NSString * (^intToString)/*名称*/ (NSUInteger)=^(NSUInteger paramInteger)/*参数*/
{
    NSString *result=[NSString stringWithFormat:@"%lu",(unsigned long)paramInteger];
    return result;
};


    //oc方法里调用Block Object
+(void)callIntToString
{
    NSString *str=intToString(10);
    DLogInfo(@"str==%@",str);
}

    //一个独立的最简单的返回值是void的闭包(Block object)
void (^simpleBlock)(void)=^
{
        //代码内容省略...
};

    //定义一个 intToString类型的 Block Object 签名,告诉编译器这个Block Object接受整数参数,返回一个被IntToStringConverter命名的(类型)标示符来展现的字符串;
typedef NSString * (^IntToStringConverter)/*名称*/ (NSUInteger paramInteger);

    //在OC方法里接受一个IntToStringConverter类型的闭包Block Object作为参数
-(NSString *)convertIntToString:(NSUInteger)paramInt usingBlockObject:(IntToStringConverter)paramBlockObject
{
    return paramBlockObject(paramInt);
}

    //-(void)doTheConversion
    //{
    //    NSString *result=[self convertIntToString:123 usingBlockObject:intToString];
    //    DLogInfo(@"result==%@",result);
    //}

#pragma mark-内联Block Objects

-(void)doTheConversion
{
        //    IntToStringConverter/*内联转换器*/ inlineConverter=^(NSUInteger paramInteger)提前声明的临时变量内联
        //    {
        //    NSString *result=[NSString stringWithFormat:@"%lu",(unsigned long)paramInteger];
        //    return result;
        //    };
        //    NSString *result=[self convertIntToString:123 usingBlockObject:inlineConverter];
        //    DLogInfo(@"result==%@",result);

    NSString *result=[self convertIntToString:123 usingBlockObject:
                      ^NSString * (NSUInteger paramInteger){
                          NSString *result=[NSString stringWithFormat:@"%lu",(unsigned long)paramInteger];
                          return result;
                      }/*内联Block Objects代码块*/
                      ];
    DLogInfo(@"result==%@",result);
}

#pragma mark-第五章-5.2-在Block Objects中获取变量
    //独立闭包中使用的变量
void (^independentBlockObject)(void)=^(void)
{
    NSInteger localInteger=10;
    DLogInfo(@"localInteger==%ld",(long)localInteger);
};

    //内联闭包和其局部变量
-(void)simpleMethod
{
    __block NSUInteger outsideVariable=10;

    NSMutableArray *array=[[NSMutableArray alloc]initWithObjects:@"obj1",@"obj2", nil];
    [array sortUsingComparator:
     ^NSComparisonResult(id obj1,id obj2){
         NSUInteger insideVariable=20;//NSComparisonResult是内联闭包,可以读写其局部变量insideVariable,但outsideVariable是其外部变量,只能读,要写的话,要在outsideVariable前边加__block
         outsideVariable=30;

         DLogInfo(@"outsideVariable==%lu",(unsigned long)outsideVariable);//
         DLogInfo(@"insideVariable==%lu",(unsigned long)insideVariable);

         DLogInfo(@"self==%@",self);//simpleMethod方法是OC类的实例,所以此方法里的内联闭包也可以获取self

         self.stringProperty=@"Block Objects";//内联闭包可读写类的全局变量
         return NSOrderedSame;
     }
     ];
}

    //独立闭包获取self时只能把self当参数传进去
void (^correctBlockObject) (id)=^(id param_self){
    DLogInfo(@"self==%@",param_self);

    {//独立闭包中主动调getter和setter方法读写类的全局已声明变量的属性
        [param_self setStringProperty:@"Block Objects"];
        DLogInfo(@"self.stringProperty==%@",[param_self stringProperty]);
    }

};

    //此OC方法里调上边的独立闭包并把self传进去
+(void)callCorrectBlockObject
{
    correctBlockObject(self);
}

    //内联闭包在其词法区域会为这些(局部或全局)变量复制值,前提是这些变量的声明时前边没加__block
typedef void (^BlockWithNoParams) (void);//声明一个名为BlockWithNoParams的闭包类型

+(void)scopeTest
{
    __block NSUInteger integerValue=10;
        //定义一个BlockWithNoParams类型的内联闭包
    BlockWithNoParams myBlock=^{
        DLogInfo(@"integerValue inside the block=%lu",(unsigned long)integerValue); //如果变量的声明时前边没加__block,则在此内联闭包执行时复制了一个integerValue 的只读值,所以下边调myBlock()方法时,打印结果还是10,否则打印20;
    };

    integerValue=20;
    myBlock();
    DLogInfo(@"integerValue outside the block =%lu",(unsigned long) integerValue);
}

#pragma mark-第五章-5.3-调用Block Objects方法

NSString * (^trimString) (NSString *)=^(NSString *inputString){
    NSString *result=[inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
};

    //在一个独立闭包内调另一个独立闭包
NSString * (^trimWithOtherBlock) (NSString *)=^(NSString *inputString){
    return trimString(inputString);
};

+(void)callTrimBack
{
    NSString *trimmedString=trimWithOtherBlock(@"   O'Reilly   ");
    DLogInfo(@"trimmedString==%@",trimmedString);
}

#pragma mark-第五章-5.5-在主线程上分配异步UI相关的任务

    //在主线程上分配异步(并发)任务
+(void)dispatch_asyncOnMainQueue
{
    dispatch_queue_t mainQueue=dispatch_get_main_queue();//得到主线程任务队列的句柄

        //异步任务
    dispatch_async(mainQueue, /*内联闭包*/^(void){
        [[[UIAlertView alloc]initWithTitle:@"GCD" message:@"GCD is amazing!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil] show];

        {//分配到主队列的闭包实际在主线程上运行
            DLogInfo(@"Current thread=%@",[NSThread currentThread]);//当前线程
            DLogInfo(@"Main thread=%@",[NSThread mainThread]);//主线程
        }

    } );
}

#pragma mark-第五章-5.6-用GCD在并行队列分派同步执行Non-UI-Related任务

    //独立闭包
void (^printFrom1To10) (void)=^{
    NSUInteger counter=0;
    for(counter=1;counter<=10;counter++){
        DLogInfo(@"Counter=%lu - Thread=%@",(unsigned long)counter,[NSThread currentThread]);
    }
};

    //主线程上分配同步任务
+(void)dispatch_sync_Non_UI_Related
{
        //得到全局并发队列
    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT/*并发队列的优先级,越高,将耗费更多的CPU时间获取该队列执行的代码,也就是给你这个同步队列分配更多的时间处理你的任务*/, 0/*默认值*/);
    dispatch_sync(concurrentQueue, printFrom1To10);//此函数使用当前线程(你分配任务的线程)执行任务
    dispatch_sync(concurrentQueue, printFrom1To10);
}

#pragma mark-第五章-5.7-在GCD上异步执行Non-UI相关任务
#pragma mark-在全局并发队列上异步执行返回值为void的非UI层面操作,从而不在主线程执行,也不影响主线程UI
+(void)dispatchAsyncOnGlobal:(dispatch_block_t)block
{
    dispatch_queue_t dispatchQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(dispatchQueue,block);
}

    //异步下载并展示图片
+(void)dispatch_asyn_downImg:(UIView *)view/*待展示图片的父视图*/
{
    /*同步队列*/
    dispatch_queue_t concurrent=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(concurrent, ^{
        __block UIImage *img=Nil;//__block修饰后此变量可以被下边的 内联闭包 读写

            //在此线程同步下img
        dispatch_sync(concurrent, ^{
            NSString *urlAsString=@"http://images.apple.com/mobileme/features/images/ipad_findyouripad_20100518.jpg";

            NSURL *url=[NSURL URLWithString:urlAsString];

            NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url];
            NSError *downloadError=Nil;
            NSData *imageData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:Nil error:&downloadError];//同步下载请求

            if (downloadError==Nil&&imageData!=Nil) {
                img=[UIImage imageWithData:imageData];
            }else if (downloadError!=Nil) {
                DLogInfo(@"Error happend=%@",downloadError);
            }else {
                DLogInfo(@"没有下载到数据,也没出错!!!");
            }
        });

            //此线程下好img后在主线程展示出来
        dispatch_sync(dispatch_get_main_queue()/*得到主线程句柄*/, ^{
            if (img) {
                UIImageView *imgV=[[UIImageView alloc]initWithFrame:view.bounds];
                [imgV setImage:img];
                [imgV setContentMode:UIViewContentModeScaleAspectFit];//不被拉伸
                [view addSubview:imgV];
                [imgV release];
            }
        });

    });

}

+(NSString *)fileLocation
{
        ///*文件夹*/
    NSArray *folders=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([folders count]==0) {
        return Nil;
    }

        //得到首个文件夹路径
    NSString *documentsFolder=[folders objectAtIndex:0];
        //在文件夹路径后边添加文件名
    return [documentsFolder stringByAppendingPathComponent:@"list.txt"];

}

+(BOOL)hasFileAlreadyBeenCreated
{
    NSFileManager *fileManager=[[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:[self fileLocation]]) {
        return YES;
    }
    return NO;
}

    //异步读取磁盘的数据
+(void)dispatch_asyn_loadDisksData
{
        //同步队列
    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        //异步
    dispatch_async(concurrentQueue, ^{
        NSUInteger numberOfValuesRequired=10000;

        if([self hasFileAlreadyBeenCreated]==NO){//磁盘上的文件不存在
                                                 //同步
            dispatch_sync(concurrentQueue, ^{
                NSMutableArray *arrayOfRandomNumbers=[[NSMutableArray alloc]initWithCapacity:numberOfValuesRequired];

                NSUInteger counter=0;
                for(counter=0;counter<numberOfValuesRequired;counter++){
                    unsigned int randomNumber=arc4random()%((unsigned int)RAND_MAX+1);

                    [arrayOfRandomNumbers addObject:[NSNumber numberWithUnsignedInt:randomNumber]];
                }

                    //把数组写出到磁盘
                [arrayOfRandomNumbers writeToFile:[self fileLocation] atomically:YES];
            });
        }

        __block NSMutableArray *randomNumbers=nil;
            //读取磁盘文件并按升序排序
        dispatch_sync(concurrentQueue, ^{
            if([self hasFileAlreadyBeenCreated]){
                randomNumbers=[[NSMutableArray alloc]initWithContentsOfFile:[self fileLocation]];
                [randomNumbers sortUsingComparator:
                 ^NSComparisonResult(id obj1,id obj2){
                     NSNumber *number1=(NSNumber *)obj1;
                     NSNumber *number2=(NSNumber *)obj2;
                     return [number1 compare:number2];
                 }];
            }
        });
    });

}


#pragma mark-第五章-5.8-利用GCD延时执行任务

    //利用GCD延时执行任务
+(void)dispatch_after
{
    double daleyInSeconds=2.0;
    /*纳秒级延迟函数,是绝对时间的抽象表示形式*/
    dispatch_time_t delayInNanoSeconds=dispatch_time(DISPATCH_TIME_NOW/*把现在作为基时间*/, daleyInSeconds * NSEC_PER_SEC/*从第一个参数时间开始的daleyInSeconds秒后的时间,即要增加到计算时间参数来获取函数结果的纳秒*/);

    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        //    double delayInSeconds = 2.0;
        //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

        //    DLogInfo(@"concurrentQueue==%p",concurrentQueue);
        //    DLogInfo(@"dispatch_get_main_queue()==%p",dispatch_get_main_queue());
        //
        //    DLogInfo(@"Current thread=%@",[NSThread currentThread]);//当前线程
        //    DLogInfo(@"Main thread=%@",[NSThread mainThread]);//主线程

    dispatch_after(delayInNanoSeconds, /*dispatch_get_main_queue()*/concurrentQueue , ^(void){

    });
}

#pragma mark-第五章-5.9-如何在GCD上让一个任务在被多次调用的情况下只被执行一次

    //static dispatch_once_t onceToken;

void (^executedOnlyOnce) (void)=^{
    static NSUInteger numberOfEntries=0;
    numberOfEntries++;
    DLogInfo(@"Executed %lu time(s)",(unsigned long)numberOfEntries);
};

    //在GCD上让一个任务在被多次调用的情况下只被执行一次
+(void)dispatch_once_
{
    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(concurrentQueue, executedOnlyOnce);//在当前线程异步执行闭包
    });
    dispatch_once(&onceToken, ^{
        dispatch_async(concurrentQueue, executedOnlyOnce);//在当前线程异步执行闭包
    });
}

#pragma mark-第五章-5.10-用GCD将任务分组

+(void)reloadTBV
{
    for(int i=0;i<5;i++){
        DLogInfo(@"reloadTBV");
    }
}

+(void)reloadScrollV
{
    for(int i=0;i<5;i++){
        DLogInfo(@"reloadScrollV");
    }
}

    //将几个任务放在一个组里,这个组里的任务全部执行完后,可以收到通知
+(void)dispatch_group
{
        //创建一个可以包含一组异步的在队列上执行的闭包这几个任务顺序执行
    dispatch_group_t taskGroup=dispatch_group_create();
    dispatch_queue_t mainQueue=dispatch_get_main_queue();

    dispatch_group_async(taskGroup, mainQueue, ^{
        [self reloadTBV];
    });

    dispatch_group_async(taskGroup, mainQueue, ^{
        [self reloadScrollV];
    });

    for(int i=0;i<5;i++){
        DLogInfo(@"主线程");
    }

        //此组任务全部执行完毕后回调此方法的闭包
    dispatch_group_notify(taskGroup, mainQueue, ^{
        DLogInfo(@"此组任务全部执行完毕!!!");
    });

        //释放分派小组
    dispatch_release(taskGroup);
}

#pragma mark-第五章-5.11-用GCD构建自己的串行(先入先出)分派队列

    //分派自定义的串行队列
+(void)dispatch_Custom_queue
{
    dispatch_queue_t firstSerialQueue=dispatch_queue_create("com.pixolity.GCD.serialQueue1"/*唯一标示系统中的这个串行队列,反向DNS格式标示符*/, 0);

        //串行队列上的异步任务不在主线程执行,同步任务在当前线程执行
    dispatch_async(firstSerialQueue, ^{

        for (NSUInteger counter=0; counter<5; counter++) {
            DLogInfo(@"First iteration,counter==%lu",(unsigned long)counter);
        }
    });

    dispatch_async(firstSerialQueue, ^{

        for (NSUInteger counter=0; counter<5; counter++) {
            DLogInfo(@"Second iteration,counter==%lu",(unsigned long)counter);
        }
    });

    dispatch_release(firstSerialQueue);
}

#pragma mark-第五章-5.12-使用Operation执行一系列(可传参的)同步任务

+(void)simpleOperationEntry:(id)paramObject
{
    DLogInfo(@"paramObject==%@",paramObject);
}

    //执行可传参的同步任务
    //+(void)InvocationOperation
    //{
    ////    NSInvocationOperation *simpleOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(simpleOperationEntry) object:@"InvocationOperation"];
    ////    [simpleOperation start];
    ////
    ////        //使用闭包执行同步任务(在main线程运行,所以不高效)
    ////    NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
    ////        DLogInfo(@"正在执行闭包同步任务...");
    ////    }];
    ////    [blockOperation start];
    //
    //    DLogInfo(@"Main Thread=%@",[NSThread mainThread]);
    //    CountingOperation *simpleOperation1=[[CountingOperation alloc]initWithStartCount:0 endingCount:1];
    //    [simpleOperation1 start];
    //    DLogInfo(@"Main thread is here");
    //}

#pragma mark-第五章-5.13-使用Operation执行异步(并发)任务

+(void)firstOperationEntry:(id)paramObject
{
    DLogInfo(@"Parameter Object=%@",paramObject);
    DLogInfo(@"Main Thread=%@",[NSThread mainThread]);
    DLogInfo(@"Current Thread=%@",[NSThread currentThread]);
}

+(void)secondOperationEntry:(id)paramObject
{
    DLogInfo(@"%s",__FUNCTION__);
    DLogInfo(@"Parameter Object=%@",paramObject);
    DLogInfo(@"Main Thread=%@",[NSThread mainThread]);
    DLogInfo(@"Current Thread=%@",[NSThread currentThread]);
}

    //使用NSInvocationOperation执行异步(并发)任务
+(void)asynNSInvocationOperation
{
        //    DLogInfo(@"%s",__FUNCTION__);

    NSNumber *firstNumber=[NSNumber numberWithInt:111];
    NSNumber *secondNumber=[NSNumber numberWithInt:222];
    NSInvocationOperation *firstOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(firstOperationEntry:) object:firstNumber];
    NSInvocationOperation *secondOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(secondOperationEntry:) object:secondNumber];

        //当把2个非并发的Operation添加到Operation队列里,此队列里的2个NSInvocationOperation和主线程就并行运行了
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    [operationQueue addOperation:firstOperation];
    [operationQueue addOperation:secondOperation];

    [firstOperation release];
    [secondOperation release];
    [operationQueue release];
    DLogInfo(@"Mian Thread is here");
}

    //使用自定义NSOperation执行异步(并发)任务
    //+(void)asynCustomOperation
    //{
    //        //    DLogInfo(@"%s",__FUNCTION__);
    //
    //    NSNumber *firstNumber=[NSNumber numberWithInt:111];
    //    NSNumber *secondNumber=[NSNumber numberWithInt:333];
    //    SimpleOperation *firstOperation=[[SimpleOperation alloc] initWithObject:firstNumber];
    //    SimpleOperation *secondOperation=[[SimpleOperation alloc] initWithObject:secondNumber];
    //
    //        //当把2个非并发的Operation添加到Operation队列里,此队列里的2个NSInvocationOperation和主线程就并行运行了
    //    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    //    [operationQueue addOperation:firstOperation];
    //    [operationQueue addOperation:secondOperation];
    //
    //    [firstOperation release];
    //    [secondOperation release];
    //    [operationQueue release];
    //    DLogInfo(@"Mian Thread is here");
    //}

#pragma mark-第五章-5.16-创建并发(独立)线程

+(void)firstCounter
{
    for (NSUInteger counter=0;counter<10; counter++) {
        DLogInfo(@"firstCounter=%lu",(unsigned long)counter);
    }
}

    //在单独线程被调的方法里,需要自动给释放池,因为主线程就有一个
+(void)secondCounter
{
    @autoreleasepool {//
        for (NSUInteger counter=0;counter<10; counter++) {
            DLogInfo(@"secondCounter=%lu",(unsigned long)counter);
        }
    }

}

    //创建一个新线程(如果在viewDidLoad或loadView中创建了独立线程,在viewDidUnLoad里要对应销毁,避免系统内存吃紧后回调viewDidUnLoad时,未清理在viewDidLoad或loadView中创建的新独立线程)
+(void)detachNewThread
{
    [NSThread detachNewThreadSelector:@selector(secondCounter) toTarget:self withObject:nil];
    [self firstCounter];
}

#pragma mark-第五章-5.17-调用后台方法,在后台创建一个不需要直接处理的线程

-(void)detachNewThreadInBackGround
{
    [self performSelectorInBackground:@selector(secondCounter) withObject:nil];
}

#pragma mark-第五章-5.18-退出线程

    //线程切入点
-(void)threadEntryPoint
{
    @autoreleasepool {
        DLogInfo(@"threadEntryPoint");

        while (![[NSThread currentThread] isCancelled]) {
            [NSThread sleepForTimeInterval:0.2];
            if (![[NSThread currentThread] isCancelled]) {
                DLogInfo(@"Thread loop");
            }
        }
        DLogInfo(@"Thread finished");
    }
}


#pragma mark-某个方法在某一段时间后在某线程上执行

void dispatch_afterByAnyQueue(double delayInSeconds,dispatch_queue_t queue/*全局队列:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)*/,dispatch_block_t block /*^(void){NSLog(@"Output GCD !");}*/)
{
    
    // 创建延期的时间，因为dispatch_time使用的时间是纳秒
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

    // 延期执行
    dispatch_after(delayInNanoSeconds, queue, block);
}

@end
