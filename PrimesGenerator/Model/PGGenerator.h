#import <Foundation/Foundation.h>

typedef unsigned long long Number;
static Number lastNumber = 1*1000*1000*1000LL;
//static const int sliceSize = 32*1024;

@interface PGGenerator : NSObject

+ (NSArray *)generateSimples:(Number)lim;
+ (NSArray *)generateSimplesOdd:(Number)limit;

+ (void)saveResults:(id)results;
+ (id)loadCachedResults;

@end