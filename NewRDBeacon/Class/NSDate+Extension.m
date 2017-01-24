//
//  NSDate+Extension.m
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 huangziliang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


- (NSString *)needDateStatus:(DateStatus)type
{
    if (type == HaveHMSType) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [fmt stringFromDate:self];
    } else if (type == NotHaveType) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:self];
    } else if(type == JapanHMSType){
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        return [fmt stringFromDate:self];
    }else if(type == JapanMDType){
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日";
        return [fmt stringFromDate:self];
    }else {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"HH:mm:ss";
        return [fmt stringFromDate:self];
    }
}


+ (NSString *)SharedToday
{
    //当前时间
    NSDate *nowDate = [NSDate new];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt stringFromDate:nowDate];
}


/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}


/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}


/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}


//-----------------------------------------------------------------------------
/**
 *  单位时间格式化
 *
 *  @param timeType 单位时间名字
 *  @param thisTime 传入时间
 *
 *  @return 时间格式化数字
 */
+(NSInteger)nowTimeType:(timeType)timeType time:(NSDate*)thisTime
{
    NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:thisTime];
    
    NSInteger second = [comps second];
    NSInteger minute = [comps minute];
    NSInteger hour24 = [comps hour];
    NSInteger day = [comps day];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"K"];
    NSInteger hour12 = [[format stringFromDate:thisTime]intValue]-1;
    NSDateFormatter *formatTwo = [[NSDateFormatter alloc] init];
    [formatTwo setDateFormat:@"aa"];
    NSInteger ampm = [[format stringFromDate:thisTime] isEqualToString:@"AM"]?0:1;
    
    switch (timeType) {
        case 1:
            return second;
            break;
            
        case 2:
            return minute;
            break;
            
        case 3:
            return hour12;
            break;
            
        case 4:
            return hour24;
            break;
            
        case 5:
            return day;
            break;
            
        case 6:
            return week;
            break;
            
        case 7:
            return month;
            break;
            
        case 8:
            return year;
            break;
            
        case 9:
            return ampm;
            break;
            
        default:
            return second;
            break;
    }
}
/**
 *  取得?天日期   字符串
 *
 *  @param thisTime 传入日期
 *  @param qian     天数
 *
 *  @return ?天日期
 */
+ (NSString *)SotherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    
    NSDate *LGFdate;
    
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
        
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString =  [fmt stringFromDate:LGFdate];
    
    
    return dateString;
    
}
/**
 *  取得?天日期
 *
 *  @param thisTime 传入日期
 *  @param qian     天数
 *
 *  @return ?天日期
 */
+(NSDate*)otherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    
    NSDate *LGFdate;
    
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
        
    }
    
    return LGFdate;
    
}
/**
 *  取得?周日期
 *
 *  @param thisTime 传入当前日期
 *  @param qian     周数
 *
 *  @return ?周日期
 */
+(NSDate*)otherWeek:(NSDate*)thisTime
{
    
    NSDate *LGFWeekDate;

    NSInteger week =  [self nowTimeType:LGFweek time:thisTime];

    if (week == 1) {
        week = 8;
    }
    
    LGFWeekDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - (week-1)*24*3600)];
    
    return LGFWeekDate;
    
}
/**
 *  取得?月日期
 *
 *  @param thisTime 传入当前日期
 *  @param qian     月数
 *
 *  @return ?月日期
 */
+(NSDate*)otherMonth:(NSDate*)thisTime
{
    
    NSDate *LGFMonthDate;
    
    NSInteger monthDay =  [self nowTimeType:LGFday time:thisTime];

    LGFMonthDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - monthDay*24*3600)];
    
    return LGFMonthDate;
    
}
@end
