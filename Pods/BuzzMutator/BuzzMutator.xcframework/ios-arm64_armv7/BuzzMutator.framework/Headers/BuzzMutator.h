#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BuzzServerDomain) {
  BuzzServerBoosterDomain = 0,
};

typedef NS_ENUM(NSInteger, BuzzServerEnvironment) {
  BuzzServerProductionEnvironment = 0,
  BuzzServerStagingEnvironment,
  BuzzServerDevEnvironment,
};

@interface BuzzMutator : NSObject

- (void)saveServerUrlWithServerDomain:(BuzzServerDomain)serverDomain
                    serverEnvironment:(BuzzServerEnvironment)serverEnvironment;

- (NSString *)fetchServerUrlWithServerDomain:(BuzzServerDomain)serverDomain;

@end
