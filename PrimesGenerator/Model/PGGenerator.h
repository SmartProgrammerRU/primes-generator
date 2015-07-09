#import <Foundation/Foundation.h>
#import "PGSearchHistory.h"

@interface PGGenerator : NSObject

+ (NSArray *)generatePrimes:(Number)lim;
+ (NSArray *)generatePrimesOddMultiThreaded:(Number)limit;

+ (void)saveResults:(NSArray *)numbers forNumber:(NSString *)limit;
+ (id)loadCachedResults;

@end