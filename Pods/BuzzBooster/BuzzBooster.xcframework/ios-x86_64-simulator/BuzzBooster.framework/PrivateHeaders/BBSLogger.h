#import "BBSLoggerDefaultEventProcessor.h"
#import "BBSLoggerEvent.h"
#import "BBSLoggerEventProcessorProtocol.h"
#import "BBSLoggerOptions.h"

@import Foundation;

@interface BBSLogger : NSObject

+ (instancetype)initializeWithOptions:(BBSLoggerOptions *)options;

+ (void)logMessage:(NSString *)format, ...;

@end
