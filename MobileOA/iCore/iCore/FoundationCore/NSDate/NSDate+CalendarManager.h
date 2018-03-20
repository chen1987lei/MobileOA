//
//  NSDate+CalendarManager.h
//  MTimeProApp
//
//  Created by 任清阳 on 2016/10/9.
//  Copyright © 2016年 MTime. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 时间相关的定义，秒、分、时、天、年

#define kTime_Second (1)                   /// 秒
#define kTime_Minute (60 * kTime_Second) /// 分
#define kTime_Hour (60 * kTime_Minute)   /// 时
#define kTime_Day (24 * kTime_Hour)      /// 天
#define kTime_Year (365 * kTime_Day)     /// 年

/*!
 *  @author renqingyang, 16-10-09 18:30:29
 *
 *  @brief  日期管理扩展
 *
 *  @since  1.0.3
 */

typedef NS_ENUM(NSUInteger, E_Date_TimeZone_Type) {
    // 0时区，UTC标准时间
    E_Date_TimeZone_UTC = 0,
    // 东8区，北京、上海、香港时间
    E_Date_TimeZone_BeiJing = 8
};


@interface NSDate (CalendarManager)

// 计算这个月有多少天
- (NSUInteger)i_getNumberOfDaysInCurrentMonth;

// 获取这个月有多少周
- (NSUInteger)i_getNumberOfWeeksInCurrentMonth;

// 计算这个月的第一天是星期几
- (NSUInteger)i_getWeeklyOrdinality;

// 获取这个月最开始的一天
- (NSDate *)i_getFirstDayOfCurrentMonth;

// 计算这个月最后一天
- (NSDate *)i_getLastDayOfCurrentMonth;

// 上一个月
- (NSDate *)i_getDateInThePreviousMonth;

// 下一个月
- (NSDate *)i_getDateInTheFollowingOneMonth;

// 获取当前日期之后的几个月
- (NSDate *)i_getDateInTheFollowingMonth:(int)month;

// 获取当前日期之后的几周
- (NSDate *)i_getDateInTheFollowingWeek:(int)week;

// 获取当前日期之后的几天
- (NSDate *)i_getDateInTheFollowingDay:(int)day;

// 获取年月日对象
- (NSDateComponents *)components;

// 获取当前日期星期对应的位置
- (NSInteger)i_getWeekIntValueWithDate;

// 判断当前日期是否在两个日期之间
- (BOOL)dateIsBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate;

// 获取清明节日期
- (NSDate *)i_getQingMingJieDate;

// 将NSDate 转成 NSNumber
+ (NSNumber *)i_getNumberFromDate:(NSDate *)date;

// NSString转NSDate
+ (NSDate *)i_getDateFromString:(NSString *)dateString;

// 计算两个日期之间相差多少天，不足1天舍去，例如 差距为1天零1小时，返回值为1
+ (NSInteger)i_getBetweenCountStartDate:(NSDate *)startDate andDate:(NSDate *)endDate;

// 计算两个日期之间相差多少天，不足1天进一位，例如 差距为1天零1秒，返回值为2
- (NSInteger)i_getIntervalDayToDate:(NSDate *)date;

// 获取某一年有多少周
+ (NSInteger)i_getNumberOfWeeksInCurrentYear:(NSInteger)year;

// 获取当前日期的前一天
+ (NSDate *)i_getPreviousDate:(NSDate *)date;

// 获取当前日期的后一天
+ (NSDate *)i_getNextDate:(NSDate *)date;

// 获取一个月份的英文简名
+ (NSString *)i_getMonthNameEn:(NSInteger)index;

// 获取时间字符串对应的Date数据，需要指定字符串时间对应的时区，字符串格式yyyy-MM-dd
//  目前仅支持特别判断北京时区，传入其他枚举都认为是UTC
+ (NSDate *)i_getDateFromString:(NSString *)dateString
                  stringTimeZone:(E_Date_TimeZone_Type)timeZone;
//返回时间格式
+ (instancetype)i_dateFromString:(NSString *)string format:(NSString *)format;
//获取农历
-(NSString*)getChineseCalendar;

// 获取年龄，不精确到月天 ---传入格式YYYY-MM-ddYYYY-MM-dd
+ (int)i_getAgeByBirth:(NSString *)birth;
@end
