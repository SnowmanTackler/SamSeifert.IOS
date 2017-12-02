//
//  StaticMethods.m
//  R by S
//
//  Created by Sam Seifert on 11/19/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "SamsMethods.h"

@implementation SamsMethods

+ (NSInteger) daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}

+ (unsigned long long int)folderSize:(NSString *) fp
{
    NSArray * fa = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fp error:nil];
    NSEnumerator * fe = [fa objectEnumerator];
    NSString * fn;
    unsigned long long int fileSize = 0;
    
    while (fn = [fe nextObject]) {
        NSDictionary * fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[fp stringByAppendingPathComponent:fn] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

@end
