//
//  GifImageSerialization.h
//  ren
//
//  Created by 任清阳 on 15/11/5.
//  Copyright © 2015年 ren. All rights reserved.
//

#import "GifImageSerialization.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const kAnimatedGIFImageErrorDomain = @"com.ren.gif.image.error";

__attribute__((overloadable)) UIImage *UIImageWithAnimatedGIFData(NSData *data)
{
    return UIImageWithAnimatedGIFData(data, [[UIScreen mainScreen] scale], 0.0f, nil);
}

__attribute__((overloadable)) UIImage *UIImageWithAnimatedGIFData(NSData *data, CGFloat scale, NSTimeInterval duration, NSError *__autoreleasing *error)
{
    if (!data)
    {
        return nil;
    }

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);

    size_t count = CGImageSourceGetCount(source);

    UIImage *animatedImage;

    if (count <= 1)
    {
        NSMutableArray *images = [NSMutableArray array];

        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);

        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));
        duration += [[[frameProperties objectForKey:(NSString *) kCGImagePropertyGIFDictionary] objectForKey:(NSString *) kCGImagePropertyGIFDelayTime] doubleValue];

        [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];

        CGImageRelease(image);

        animatedImage = [UIImage animatedImageWithImages:images duration:0.0];
    }
    else
    {
        NSMutableArray *images = [NSMutableArray array];

        NSTimeInterval duration = 0.0f;

        for (size_t i = 0; i < count; i++)
        {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);

            NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
            duration += [[[frameProperties objectForKey:(NSString *) kCGImagePropertyGIFDictionary] objectForKey:(NSString *) kCGImagePropertyGIFDelayTime] doubleValue];

            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];

            CGImageRelease(image);
        }

        duration = (1.0f / 30.0f) * count;

        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    CFRelease(source);

    return animatedImage;
}

static BOOL AnimatedGifDataIsValid(NSData *data)
{
    if (data.length > 4)
    {
        const unsigned char *bytes = [data bytes];

        return bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
    }

    return NO;
}


@implementation GifImageSerialization

+ (UIImage *)imageWithData:(NSData *)data
                     error:(NSError *__autoreleasing *)error
{
    return [self imageWithData:data scale:1.0f duration:0.0f error:error];
}

+ (UIImage *)imageWithData:(NSData *)data
                     scale:(CGFloat)scale
                  duration:(NSTimeInterval)duration
                     error:(NSError *__autoreleasing *)error
{
    return UIImageWithAnimatedGIFData(data, scale, duration, error);
}

@end

#pragma mark -

#ifndef ANIMATED_GIF_NO_UIIMAGE_INITIALIZER_SWIZZLING
#import <objc/runtime.h>

static inline void animated_gif_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)))
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@interface UIImage (_AnimatedGifImageSerialization)
@end


@implementation UIImage (_AnimatedGifImageSerialization)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            animated_gif_swizzleSelector(self, @selector(initWithData:scale:), @selector(animated_gif_initWithData:scale:));
            animated_gif_swizzleSelector(self, @selector(initWithData:), @selector(animated_gif_initWithData:));
            animated_gif_swizzleSelector(self, @selector(initWithContentsOfFile:), @selector(animated_gif_initWithContentsOfFile:));
            animated_gif_swizzleSelector(object_getClass((id) self), @selector(imageNamed:), @selector(animated_gif_imageNamed:));
        }
    });
}

+ (UIImage *)animated_gif_imageNamed:(NSString *)name __attribute__((objc_method_family(new)))
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
    if (path)
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (AnimatedGifDataIsValid(data))
        {
            if ([[name stringByDeletingPathExtension] hasSuffix:@"@2x"])
            {
                return [GifImageSerialization imageWithData:data scale:2.0f duration:0.0f error:nil];
            }
            else
            {
                return [GifImageSerialization imageWithData:data error:nil];
            }
        }
    }

    return [self animated_gif_imageNamed:name];
}

- (id)animated_gif_initWithData:(NSData *)data __attribute__((objc_method_family(init)))
{
    if (AnimatedGifDataIsValid(data))
    {
        return UIImageWithAnimatedGIFData(data);
    }

    return [self animated_gif_initWithData:data];
}

- (id)animated_gif_initWithData:(NSData *)data
                          scale:(CGFloat)scale __attribute__((objc_method_family(init)))
{
    if (AnimatedGifDataIsValid(data))
    {
        return UIImageWithAnimatedGIFData(data, scale, 0.0f, nil);
    }

    return [self animated_gif_initWithData:data scale:scale];
}

- (id)animated_gif_initWithContentsOfFile:(NSString *)path __attribute__((objc_method_family(init)))
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (AnimatedGifDataIsValid(data))
    {
        return UIImageWithAnimatedGIFData(data, 1.0, 0.0f, nil);
    }

    return [self animated_gif_initWithContentsOfFile:path];
}

@end
#endif
