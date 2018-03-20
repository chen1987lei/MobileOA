//
//  GifImageSerialization.h
//  ren
//
//  Created by 任清阳 on 15/11/5.
//  Copyright © 2015年 ren. All rights reserved.
//

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
/**
 
 */
extern __attribute__((overloadable)) UIImage *UIImageWithAnimatedGIFData(NSData *data);

/**
 
 */
extern __attribute__((overloadable)) UIImage *UIImageWithAnimatedGIFData(NSData *data, CGFloat scale, NSTimeInterval duration, NSError *__autoreleasing *error);

/*!
 *  @author 任清阳, 2018-01-09  15:30:29
 *
 *  @brief  GIF图片支持
 *
 *  @since  1.0
 */
@interface GifImageSerialization : NSObject

/// @name Creating an Animated GIF

+ (UIImage *)imageWithData:(NSData *)data
                     error:(NSError *__autoreleasing *)error;

+ (UIImage *)imageWithData:(NSData *)data
                     scale:(CGFloat)scale
                  duration:(NSTimeInterval)duration
                     error:(NSError *__autoreleasing *)error;

@end

extern NSString *const AnimatedGIFImageErrorDomain;
#endif
