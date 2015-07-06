#import <Foundation/Foundation.h>
#import "PGSearchHistory.h"

//static const int sliceSize = 32*1024;

@interface PGGenerator : NSObject

+ (NSArray *)generateSimples:(Number)lim;
+ (NSArray *)generateSimplesOdd:(Number)limit;

+ (void)saveResults:(NSArray *)numbers forNumber:(NSString *)limit;
+ (id)loadCachedResults;

@end