//
//  CGProtocolInterceptor.h
//  Pods
//
//  Created by guoshencheng on 4/15/16.
//
//

#import <Foundation/Foundation.h>

@interface CGProtocolInterceptor : NSObject

@property (nonatomic, readonly, copy) NSSet * interceptedProtocols;
@property (nonatomic, weak) id receiver;
@property (nonatomic, weak, readonly) id middleMan;

- (instancetype)initWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol;
- (instancetype)initWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols;
+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol;
+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols;


@end
