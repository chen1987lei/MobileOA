//
//  NSDate+CalendarManager.m
//  MTimeProApp
//
//  Created by 任清阳 on 2016/10/9.
//  Copyright © 2016年 MTime. All rights reserved.
//

#import "NSDate+CalendarManager.h"

#import "Macro_NSString.h"
/*
 冬至日期（东八区）的计算公式：（YD+C）-L
 公式解读：Y=年数后2位，D=0.2422，L=闰年数，21世纪C=21.94，20世纪=22.60。
 清明是冬至后的108天
 */

#define kDongZhiCountD (0.2422)
#define kDongZhiCountL (21.94)
#define kDongZhiCount (108)

@implementation NSDate (CalendarManager)

#pragma mark - 计算这个月有多少天
- (NSUInteger)i_getNumberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:self]
        .length;
}

#pragma mark - 获取这个月有多少周
- (NSUInteger)i_getNumberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self i_getFirstDayOfCurrentMonth] i_getWeeklyOrdinality];
    NSUInteger days = [self i_getNumberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;

    if (weekday > 1)
    {
        weeks += 1;
        days -= (7 - weekday + 1);
    }

    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;

    return weeks;
}

#pragma mark - 计算这个月的第一天是星期几
- (NSUInteger)i_getWeeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitWeekOfYear
                                                  forDate:self];
}

#pragma mark - 获取这个月最开始的一天
- (NSDate *)i_getFirstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                    startDate:&startDate
                                     interval:NULL
                                      forDate:self];

    return startDate;
}

#pragma mark - 计算这个月最后一天
- (NSDate *)i_getLastDayOfCurrentMonth;
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];

    dateComponents.day = [self i_getNumberOfDaysInCurrentMonth];

    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

#pragma mark - 上一个月
- (NSDate *)i_getDateInThePreviousMonth;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.month = -1;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

#pragma mark - 下一个月
- (NSDate *)i_getDateInTheFollowingOneMonth;
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.month = 1;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

#pragma mark - 获取当前日期之后的几个月
- (NSDate *)i_getDateInTheFollowingMonth:(int)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.month = month;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

#pragma mark - 获取当前日期之后的几周
- (NSDate *)i_getDateInTheFollowingWeek:(int)week
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.day = week * 7;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}
#pragma mark - 获取当前日期之后的几天
- (NSDate *)i_getDateInTheFollowingDay:(int)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.day = day;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

#pragma mark - 获取年月日对象
- (NSDateComponents *)components
{
    return [[NSCalendar currentCalendar] components:
                                             NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday
                                           fromDate:self];
}

#pragma mark - 获取当前日期星期对应的位置 周日是“1”，周一是“2”...
- (NSInteger)i_getWeekIntValueWithDate
{
    NSInteger weekIntValue;

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = [comps weekday];
}

#pragma mark - 判断当前日期是否在两个日期之间
- (BOOL)dateIsBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate
{
    NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval interval = [timeZone secondsFromGMT];

    /// 做北京时间比较
    if ([[self dateByAddingTimeInterval:-interval] compare:[startDate dateByAddingTimeInterval:-interval]] == NSOrderedAscending)
    {
        return NO;
    }

    if ([self compare:[endDate dateByAddingTimeInterval:-interval]] == NSOrderedDescending)
    {
        return NO;
    }

    return YES;
}

#pragma mark - 获取清明节日期
- (NSDate *)i_getQingMingJieDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];

    NSInteger year = [components year];

    NSInteger dongzhi = (year % 100 * kDongZhiCountD + kDongZhiCountL) - year % 100 / 4;

    /// 取上一年的冬至时间
    NSString *dongZhiDateString = [NSString stringWithFormat:@"%04zd12%02zd", year - 1, dongzhi];

    NSDate *dongZhiDate = [NSDate i_getDateFromString:dongZhiDateString];

    return [dongZhiDate i_getDateInTheFollowingDay:kDongZhiCount];
}

#pragma mark - 将NSDate 转成 NSNumber
+ (NSNumber *)i_getNumberFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyyMMdd"];

    NSString *dateString = [dateFormatter stringFromDate:date];

    NSNumber *number = @([dateString integerValue]);

    return number;
}

#pragma mark - NSString转NSDate  yyyyMMdd
+ (NSDate *)i_getDateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];

    NSDate *destDate = [dateFormatter dateFromString:dateString];

    return destDate;
}

#pragma mark - 计算两个日期之间相差多少天
+ (NSInteger)i_getBetweenCountStartDate:(NSDate *)startDate andDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    unsigned int unitFlags = kCFCalendarUnitDay;

    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];

    NSInteger days = [comps day];

    return days;
}

- (NSInteger)i_getIntervalDayToDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    unsigned int unitFlags = kCFCalendarUnitSecond;

    NSDateComponents *comps = [gregorian components:unitFlags
                                           fromDate:self
                                             toDate:date
                                            options:0];

    NSInteger seconds = [comps second];

    NSInteger days = (NSInteger) ceilf(seconds / (24 * 3600.0));

    return days;
}

#pragma mark - 获取某一年有多少周
+ (NSInteger)i_getNumberOfWeeksInCurrentYear:(NSInteger)year
{
    /// 获取客户端逻辑日历
    NSCalendar *calendar = [NSCalendar currentCalendar];

    /// 获取当年第一天
    NSDate *date = [NSDate i_getDateFromString:[NSString stringWithFormat:@"%04zd0101", year]];

    /// 从date中读取年月日，存储在NSDateComponents对象中
    NSDateComponents *compt = [calendar components:(NSCalendarUnitWeekOfYear)
                                          fromDate:date];

    return [compt weekOfYear];
}
#pragma mark - 获取当前日期的前一天
+ (NSDate *)i_getPreviousDate:(NSDate *)date
{
    NSDate *datePrevious = [date dateByAddingTimeInterval:-kTime_Day];

    return datePrevious;
}

#pragma mark - 获取当前日期的后一天
+ (NSDate *)i_getNextDate:(NSDate *)date
{
    NSDate *dateNext = [date dateByAddingTimeInterval:kTime_Day];

    return dateNext;
}

#pragma mark - 获取一个月份的英文简名
+ (NSString *)i_getMonthNameEn:(NSInteger)index
{
    NSArray *monthNameArray = @[ @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"June", @"July", @"Aug", @"Sept", @"Oct", @"Nov", @"Dec" ];

    return [monthNameArray objectAtIndex:index - 1];
}

/// 获取时间字符串对应的Date数据，需要指定字符串时间对应的时区，格式yyyyMMdd
+ (NSDate *)i_getDateFromString:(NSString *)dateString
                  stringTimeZone:(E_Date_TimeZone_Type)timeZone
{
    if (kString_Not_Valid(dateString))
    {
        return nil;
    }
    else
    {
        NSString *stringZoneName = @"UTC";
        ///  目前仅支持特别判断北京时区，传入其他枚举都认为是UTC
        if (timeZone == E_Date_TimeZone_BeiJing)
        {
            stringZoneName = @"Asia/Beijing";
        }

        NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:stringZoneName];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:sourceTimeZone];

        NSDate *dateFormated = [dateFormatter dateFromString:dateString];

        return dateFormated;
    }
}
//返回时间格式
+ (instancetype)i_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

-(NSString*)getChineseCalendar{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@ %@ %@",y_str,m_str,d_str];
    
    return chineseCal_str;
}

// 获取年龄，不精确到月天 ---传入格式YYYY-MM-dd
+ (int)i_getAgeByBirth:(NSString *)birth
{
    //计算年龄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    NSLog(@"year %d",age);

    return age;
}

@end
