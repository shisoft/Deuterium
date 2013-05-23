//
//  CGICommon.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#ifndef CGIJSONKit_CGICommon_h
#define CGIJSONKit_CGICommon_h

// C++-safe code.

#ifndef CGIExtern
#ifdef     __cplusplus

#define CGIBeginDecls   extern "C" {
#define CGIEndDecls     }
#define CGIExtern       extern "C"

#else   // __cplusplus

#define CGIBeginDecls
#define CGIEndDecls
#define CGIExtern       extern

#endif  // __cplusplus
#endif

CGIBeginDecls

// C-safe Objective-C code.

#ifdef     __OBJC__

#import <Foundation/Foundation.h>

#ifndef CGIClass
#define CGIClass        @class
#endif

// Providing retain/release functions without triggering ARC errors.

#ifdef     GNUSTEP

#import <objc/objc_arc.h>

static inline id CGIRetain(id obj)
{
    return objc_retain(obj);
}

static inline void CGIRelease(id obj)
{
    objc_release(obj);
}

#else   // GNUSTEP

#import <CoreFoundation/CoreFoundation.h>

static inline id CGIRetain(id obj)
{
    return (obj) ? (__bridge id)CFRetain((__bridge CFTypeRef)obj) : nil;
}

static inline void CGIRelease(id obj)
{
    if (obj) CFRelease((__bridge CFTypeRef)obj);
}

#endif  // GNUSTEP

#else   // __OBJC__

#include <objc/runtime.h>

#ifndef CGIClass
#define CGIClass        typedef struct objc_object
#endif

#endif  // __OBJC__

// Handy functions

#ifndef eprintf
#define eprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
#endif

#ifndef dbgprintf
#if DEBUG
#define dbgprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
#else
#define dbgprintf(format, ...)
#endif
#endif

#ifndef CGIAssignPointer
#define CGIAssignPointer(ptr, val) \
do { typeof(ptr) __ptr = (ptr); \
if (__ptr) *__ptr = (val); \
} while (0)
#endif

#ifdef     __OBJC__

#ifndef CGISTR
#define CGISTR(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]
#endif

#ifndef CGIType
#define CGIType(type) (@(@encode(type)))
#endif

static inline const char *CGICSTR(NSString *string)
{
    return [string cStringUsingEncoding:NSUTF8StringEncoding];
}

CGIExtern NSString *CGIStringFromBufferedAction(NSUInteger size, NSStringEncoding encoding, void (^action)(char *buffer, NSUInteger size));

#endif  // __OBJC__

CGIEndDecls

#endif
