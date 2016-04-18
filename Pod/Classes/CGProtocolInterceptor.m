//
//  CGProtocolInterceptor.m
//  Pods
//
//  Created by guoshencheng on 4/15/16.
//
//

#import  <objc/runtime.h>
#import "CGProtocolInterceptor.h"

static inline BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol) {
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            return YES;
        }
    }
    return NO;
}

@implementation CGProtocolInterceptor

- (instancetype)initWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol {
    self = [super init];
    if (self) {
        _interceptedProtocols = [NSSet setWithObject:interceptedProtocol];
        _middleMan = middleMan;
    }
    return self;
}

- (instancetype)initWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols {
    self = [super init];
    if (self) {
        _interceptedProtocols = [interceptedProtocols copy];
        _middleMan = middleMan;
    }
    return self;
}

+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol {
    return [[self alloc] initWithMiddleMan:middleMan forProtocol:interceptedProtocol];
}

+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols {
    return [[self alloc] initWithMiddleMan:middleMan forProtocols:interceptedProtocols];
}

- (void) setReceiver:(id)receiver {
    if ([receiver isKindOfClass:[CGProtocolInterceptor class]]) {
        NSLog(@"Caution! Setting a PMProtocolInterceptor as another PMProtocolInterceptor's receiver can be unpredictable.");
    }
    _receiver = receiver;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector]) {
        return self.middleMan;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return self.receiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector]) {
        return YES;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

#pragma mark - Private Methods

- (BOOL)isSelectorContainedInInterceptedProtocols:(SEL)aSelector {
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    [self.interceptedProtocols enumerateObjectsUsingBlock:^(Protocol * protocol, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(aSelector, protocol);
        *stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}


@end
