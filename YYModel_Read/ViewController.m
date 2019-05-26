//
//  ViewController.m
//  YYModel_Read
//
//  Created by mac on 2019/5/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "GitHubUser.h"
#import "YYWeiboModel.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self benchmarkGithubUser];
//        [self benchmarkWeiboStatus];
//
//        [self testRobustness];
    });
    
    
//    [self pointTest];
}

- (void)pointTest{
    //    [self testNSCharacterSet];
    //    [self testBlock];
    [self testScanner];
}

- (void)testScanner{
    
    // 每次扫描成功scanLocation会移动到匹配的下一个位置,失败则不移动
    int value;
    NSString *string = @"A123B456a789";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = [NSCharacterSet uppercaseLetterCharacterSet];    // 跳过所有大写字母
//    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"ABa"];    // 指定字符集合
    
    while (![scanner isAtEnd]) {
        // 扫描出数字
        NSLog(@"%zd",scanner.scanLocation);
        BOOL result = [scanner scanInt:&value];
        if (!result) break;
        NSLog(@"scanner-result:%d,value:%d",result,value);
        NSLog(@"%zd",scanner.scanLocation);
        /**
         2019-05-25 18:21:49.099061+0800 YYModel_Read[10724:505331] 0
         2019-05-25 18:21:49.099189+0800 YYModel_Read[10724:505331] scanner-result:1,value:123
         2019-05-25 18:21:49.099249+0800 YYModel_Read[10724:505331] 4
         2019-05-25 18:21:49.099309+0800 YYModel_Read[10724:505331] 4
         2019-05-25 18:21:49.099391+0800 YYModel_Read[10724:505331] scanner-result:1,value:456
         2019-05-25 18:21:49.099468+0800 YYModel_Read[10724:505331] 8
         */
    }
    NSScanner *scanner2 = [NSScanner scannerWithString:@"#ff0fa1"];
    NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    NSString *colorString = NULL;
    
    NSLog(@"%zd",scanner2.scanLocation);
    // 扫描指定的字符串: 成功后scanLocation移动位置
    BOOL start = [scanner2 scanString:@"#" intoString:NULL];
    NSLog(@"%zd",scanner2.scanLocation);
    
    if (start && [scanner2 scanCharactersFromSet:hexadecimalCharacterSet intoString:&colorString] && colorString.length == 6) {
        NSLog(@"%@",colorString);
    }
    /**
     2019-05-25 19:29:48.492832+0800 YYModel_Read[11557:549469] 0
     2019-05-25 19:29:48.492915+0800 YYModel_Read[11557:549469] 1
     2019-05-25 19:29:48.493038+0800 YYModel_Read[11557:549469] ff0fa1
     */
}

- (void)testBlock{
    
    typedef NSDate* (^YYNSDateParseBlock)(NSString *string);
    
    YYNSDateParseBlock blocks[35] = {0};
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"yyyy-MM-dd";
    blocks[10] = ^(NSString *string) { return [formatter dateFromString:string]; };
    
    int i;
    for (i = 0 ; i < 35; i++) {
        NSLog(@"%@", blocks[i]);
    }
}

- (void)testNSCharacterSet{
    
    /**
     Summary  字符的集合
     
     An object representing a fixed set of Unicode character values for use in search operations.
     Declaration
     
     @interface NSCharacterSet : NSObject
     Discussion
     
     An NSCharacterSet object represents a set of Unicode-compliant(顺从的；服从的) characters. NSString and NSScanner objects use NSCharacterSet objects to group characters together for searching operations, so that they can find any of a particular set of characters during a search. The cluster’s(n. 群；簇；丛；串) two public classes, NSCharacterSet and NSMutableCharacterSet, declare the programmatic interface for static and dynamic character sets, respectively.
     
     The objects you create using these classes are referred to as character set objects (and when no confusion will result, merely as character sets). Because of the nature of class clusters, character set objects aren’t actual instances of the NSCharacterSet or NSMutableCharacterSet classes but of one of their private subclasses. Although a character set object’s class is private, its interface is public, as declared by these abstract superclasses, NSCharacterSet and NSMutableCharacterSet. The character set classes adopt the NSCopying and NSMutableCopying protocols, making it convenient to convert a character set of one type to the other.
     
     The NSCharacterSet class declares the programmatic interface for an object that manages a set of Unicode characters (see the NSString class cluster specification for information on Unicode). NSCharacterSet’s principal primitive method, characterIsMember:, provides the basis for all other instance methods in its interface. A subclass of NSCharacterSet needs only to implement this method, plus mutableCopyWithZone:, for proper behavior. For optimal performance, a subclass should also override bitmapRepresentation, which otherwise works by invoking characterIsMember: for every possible Unicode value.
     
     NSCharacterSet is “toll-free bridged” with its Core Foundation counterpart, CFCharacterSetRef. See Toll-Free Bridging for more information on toll-free bridging.
     
     Important
     The Swift overlay to the Foundation framework provides the CharacterSet structure, which bridges to the NSCharacterSet class and its mutable subclass, NSMutableCharacterSet. For more information about value types, see Working with Cocoa Frameworks in Using Swift with Cocoa and Objective-C (Swift 4.1).
     
     
     
     Summary
     
     Returns a character set containing characters with Unicode values in a given range.
     Declaration
     
     + (NSCharacterSet *)characterSetWithRange:(NSRange)aRange;
     Discussion
     
     This code excerpt creates a character set object containing the lowercase English alphabetic characters:
     NSRange lcEnglishRange;
     NSCharacterSet *lcEnglishLetters;
     
     lcEnglishRange.location = (unsigned int)'a';
     lcEnglishRange.length = 26;
     lcEnglishLetters = [NSCharacterSet characterSetWithRange:lcEnglishRange];
     
     Parameters
     
     aRange
     A range of Unicode values.
     aRange.location is the value of the first character to return; aRange.location + aRange.length– 1 is the value of the last.
     Returns
     
     A character set containing characters whose Unicode values are given by aRange. If aRange.length is 0, returns an empty character set.

     */
    
    NSRange lcEnglishRange;
    NSCharacterSet *lcEnglishLetters;
    
    lcEnglishRange.location = (unsigned int)'a';
    lcEnglishRange.length = 26;
    // 存放26个小写字母的集合
    lcEnglishLetters = [NSCharacterSet characterSetWithRange:lcEnglishRange];
    NSLog(@"%d",[lcEnglishLetters characterIsMember:'z']);
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *str = @"7sjf78sf990s";
    NSLog(@"originSet:%@, afterSet:%@",set,[str componentsSeparatedByCharactersInSet:set]);
    
    NSCharacterSet *invertedSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSLog(@"invertedSet----%@",[str componentsSeparatedByCharactersInSet:invertedSet]);
    
//【可以看出invertedSet后，刚好判断条件相反】

}



- (void)benchmarkGithubUser {
    
    
    printf("----------------------\n");
    printf("Benchmark (1 times):\n");
    printf("GHUser             from json    to json    archive\n");
    
    /// get json data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    /// Benchmark
    int count = 1;
    NSTimeInterval begin, end;
    
    /// warm up (NSDictionary's hot cache, and JSON to model framework cache)

    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            // Manually
            [[[[GHUser alloc] initWithJSONDictionary:json] description] length];
            
            // YYModel
            [YYGHUser yy_modelWithJSON:json];
        }
    }
    /// warm up holder
    NSMutableArray *holder = [NSMutableArray new];
    for (int i = 0; i < 1800; i++) {
        [holder addObject:[NSDate new]];
    }
    [holder removeAllObjects];
    
    
    
    /*------------------- JSON Serialization -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        printf("JSON(*):            %8.2f   ", (end - begin) * 1000);
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:nil];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f   \n", (end - begin) * 1000);
    }
    
    
    
    /*------------------- Manually -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                GHUser *user = [[GHUser alloc] initWithJSONDictionary:json];
                [holder addObject:user];
            }
        }
        end = CACurrentMediaTime();
        printf("Manually(#):        %8.2f   ", (end - begin) * 1000);
        
        
        GHUser *user = [[GHUser alloc] initWithJSONDictionary:json];
        if (user.userID == 0) NSLog(@"error!");
        if (!user.login) NSLog(@"error!");
        if (!user.htmlURL) NSLog(@"error");
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [user convertToJSONDictionary];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        if ([NSJSONSerialization isValidJSONObject:[user convertToJSONDictionary]]) {
            printf("%8.2f   ", (end - begin) * 1000);
        } else {
            printf("   error   ");
        }
        
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                [holder addObject:data];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f\n", (end - begin) * 1000);
    }
    
    /*------------------- YYModel -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                YYGHUser *user = [YYGHUser yy_modelWithJSON:json];
                [holder addObject:user];
            }
        }
        end = CACurrentMediaTime();
        printf("YYModel(#):         %8.2f   ", (end - begin) * 1000);
        
        
        YYGHUser *user = [YYGHUser yy_modelWithJSON:json];
        if (user.userID == 0) NSLog(@"error!");
        if (!user.login) NSLog(@"error!");
        if (!user.htmlURL) NSLog(@"error");
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [user yy_modelToJSONObject];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        if ([NSJSONSerialization isValidJSONObject:[user yy_modelToJSONObject]]) {
            printf("%8.2f   ", (end - begin) * 1000);
        } else {
            printf("   error   ");
        }
        
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                [holder addObject:data];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f\n", (end - begin) * 1000);
    }
    
    
   
    printf("----------------------\n");
    printf("\n");
}




- (void)benchmarkWeiboStatus {
    printf("----------------------\n");
    printf("Benchmark (1000 times):\n");
    printf("WeiboStatus     from json    to json    archive\n");
    
    /// get json data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    
    
    
    /// Benchmark
    int count = 1000;
    NSTimeInterval begin, end;
    
    /// warm up (NSDictionary's hot cache, and JSON to model framework cache)

    @autoreleasepool {
        for (int i = 0; i < count * 2; i++) {
            // YYModel
            [YYWeiboStatus yy_modelWithJSON:json];
        }
    }
    
    /// warm up holder
    NSMutableArray *holder = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        [holder addObject:[NSData new]];
    }
    [holder removeAllObjects];
    
    
    /*------------------- YYModel -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                YYWeiboStatus *feed = [YYWeiboStatus yy_modelWithJSON:json];
                [holder addObject:feed];
            }
        }
        end = CACurrentMediaTime();
        printf("YYModel:         %8.2f   ", (end - begin) * 1000);
        
        
        YYWeiboStatus *feed = [YYWeiboStatus yy_modelWithJSON:json];
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [feed yy_modelToJSONObject];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        if ([NSJSONSerialization isValidJSONObject:[feed yy_modelToJSONObject]]) {
            printf("%8.2f   ", (end - begin) * 1000);
        } else {
            printf("   error   ");
        }
        
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:feed];
                [holder addObject:data];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f\n", (end - begin) * 1000);
    }
    
    
    printf("----------------------\n");
    printf("\n");
}

- (void)testRobustness {
    
    {
        printf("----------------------\n");
        printf("The property is NSString, but the json value is number:\n");
        NSString *jsonStr = @"{\"type\":1}";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        void (^logError)(NSString *model, id user) = ^(NSString *model, id user){
            printf("%s ",model.UTF8String);
            if (!user) {
                printf("⚠️ model is nil\n");
            } else {
                NSString *type = ((YYGHUser *)user).type;
                if (type == nil || type == (id)[NSNull null]) {
                    printf("⚠️ property is nil\n");
                } else if ([type isKindOfClass:[NSString class]]) {
                    printf("✅ property is %s\n",NSStringFromClass(type.class).UTF8String);
                } else {
                    printf("🚫 property is %s\n",NSStringFromClass(type.class).UTF8String);
                }
            }
        };
        
        // YYModel
        YYGHUser *yyUser = [YYGHUser yy_modelWithJSON:json];
        logError(@"YYModel:        ", yyUser);
        
        
        printf("\n");
    }
    
    {
        printf("----------------------\n");
        printf("The property is int, but the json value is string:\n");
        NSString *jsonStr = @"{\"followers\":\"100\"}";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        void (^logError)(NSString *model, id user) = ^(NSString *model, id user){
            printf("%s ",model.UTF8String);
            if (!user) {
                printf("⚠️ model is nil\n");
            } else {
                UInt32 num = ((YYGHUser *)user).followers;
                if (num != 100) {
                    printf("🚫 property is %u\n",(unsigned int)num);
                } else {
                    printf("✅ property is %u\n",(unsigned int)num);
                }
            }
        };
        
        // YYModel
        YYGHUser *yyUser = [YYGHUser yy_modelWithJSON:json];
        logError(@"YYModel:        ", yyUser);
        
    }
    
    
    {
        printf("----------------------\n");
        printf("The property is NSDate, and the json value is string:\n");
        NSString *jsonStr = @"{\"updated_at\":\"2009-04-02T03:35:22Z\"}";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        void (^logError)(NSString *model, id user) = ^(NSString *model, id user){
            printf("%s ",model.UTF8String);
            if (!user) {
                printf("⚠️ model is nil\n");
            } else {
                NSDate *date = ((YYGHUser *)user).updatedAt;
                if (date == nil || date == (id)[NSNull null]) {
                    printf("⚠️ property is nil\n");
                } else if ([date isKindOfClass:[NSDate class]]) {
                    printf("✅ property is %s\n",NSStringFromClass(date.class).UTF8String);
                } else {
                    printf("🚫 property is %s\n",NSStringFromClass(date.class).UTF8String);
                }
            }
        };
        
        // YYModel
        YYGHUser *yyUser = [YYGHUser yy_modelWithJSON:json];
        logError(@"YYModel:        ", yyUser);
        
        printf("\n");
    }
    
    
    {
        printf("----------------------\n");
        printf("The property is NSValue, and the json value is string:\n");
        NSString *jsonStr = @"{\"test\":\"https://github.com\"}";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        void (^logError)(NSString *model, id user) = ^(NSString *model, id user){
            printf("%s ",model.UTF8String);
            if (!user) {
                printf("⚠️ model is nil\n");
            } else {
                NSValue *valur = ((YYGHUser *)user).test;
                if (valur == nil || valur == (id)[NSNull null]) {
                    printf("✅ property is nil\n");
                } else if ([valur isKindOfClass:[NSURLRequest class]]) {
                    printf("✅ property is %s\n",NSStringFromClass(valur.class).UTF8String);
                } else {
                    printf("🚫 property is %s\n",NSStringFromClass(valur.class).UTF8String);
                }
            }
        };
        // YYModel
        YYGHUser *yyUser = [YYGHUser yy_modelWithJSON:json];
        logError(@"YYModel:        ", yyUser);
        
        printf("\n");
    }
    
}



@end
