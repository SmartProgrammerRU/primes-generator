#import "PGGenerator.h"

@implementation PGGenerator

+ (NSArray *)generatePrimes:(Number)limit
{
   NSMutableArray *isSimple = [NSMutableArray array];
   if (limit < 2) {
      return isSimple;
   }
   
   char *is_prime = (char *)malloc(sizeof(char *) * (limit+1));
   Number i, j; // unsigned long
   
   for (i = 0; i <= limit; i++) { // i=1
      is_prime[i] = 1;
   }
   
   for (i=2; (i*i)<= limit; i++) {
      if (is_prime[i] == 1) {
         for (j=i*i; j <= limit; j+=i) {
            is_prime[j] = 0;
         }
      }
   }
   
   for (i = 2; i <= limit; i++) {
      if (is_prime[i]) {
         [isSimple addObject:@(i)];
      }
   }
   
   free(is_prime);
   return isSimple;
}

+ (NSArray *)generatePrimesOddMultiThreaded:(Number)limit
{
   if (limit < 2) {
      return @[];
   }
   
   NSMutableArray *totalArray = [NSMutableArray array];
   NSMutableArray *tempArray = [NSMutableArray array];
   
   NSUInteger minValueToStartGeneratePrimesMultiThreaded = 100000;
   NSUInteger ratio = 4; // or 32 or 64 but (ratio <= minValueToStartGeneratePrimesSimultaneously)
   NSUInteger count = 1;
   if (limit >= minValueToStartGeneratePrimesMultiThreaded) {
      count = ratio *[[NSProcessInfo processInfo] processorCount]; //  available processing cores
   }

   Number sliceSize = limit/count;
   for (int i=0; i<count; i++) {
      [tempArray addObject:@[]];
   }
   
   // parallelize
   dispatch_group_t group = dispatch_group_create();
   dispatch_queue_t globalQ = dispatch_get_global_queue(0, 0);
   dispatch_apply(count, globalQ, ^(size_t i) {
      dispatch_group_async(group, globalQ, ^{
         Number from = i * sliceSize;
         Number to = from + sliceSize;
         tempArray[i] = [PGGenerator generatePrimeSingleBlockOdd:from to:to];
      });
   });
   
   // bring together
   dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
   for (int i=0; i<count; i++) {
      [totalArray addObjectsFromArray:tempArray[i]];
   }
   
   return totalArray;
}

// generate odd-only prime numbers of a specified block
+ (NSArray *)generatePrimeSingleBlockOdd:(Number)from to:( Number)to
{
   NSMutableArray *isSimple = [NSMutableArray array];
   
   const Number lastNumberSqrt = (int)sqrt((double)to);
   const Number memorySize = (to - from -1)/2;
   char *isPrime = (char *) malloc(sizeof(char *) * (memorySize+1));
   
   for (Number i = 0; i <= memorySize; i++) {
      isPrime[i] = 1;
   }
   
   for (Number i = 3; i <= lastNumberSqrt; i += 2) {
      // skip multiples of three: 9, 15, 21, 27, ...
      if (i >= 3*3 && i % 3 == 0)
         continue;
      // skip multiples of five
      if (i >= 5*5 && i % 5 == 0)
         continue;
      // skip multiples of seven
      if (i >= 7*7 && i % 7 == 0)
         continue;
      // skip multiples of eleven
      if (i >= 11*11 && i % 11 == 0)
         continue;
      // skip multiples of thirteen
      if (i >= 13*13 && i % 13 == 0)
         continue;
      
      
      // skip numbers before current slice
      Number minJ = ((from+i-1)/i)*i;
      if (minJ < i*i)
         minJ = i*i;
      
      // start value must be odd
      if ((minJ & 1) == 0)
         minJ += i;
      
      // find all odd non-primes
      for (Number j = minJ; j <= to; j += 2*i) {
         Number index = j - from;
         Number index2 = index/2;
         isPrime[index2] = 0;
      }
   }
   
   Number i = 0;
   if (from <= 2) {
      i = 1;
      [isSimple addObject:@2];
   }
   
   for (; i <= memorySize; i++) {
      if (isPrime[i] == 1) {
         if (from % 2 == 0) {
            [isSimple addObject:@(from + 2*i+1)];
         } else {
            [isSimple addObject:@(from + 2*i)];
         }
      }
      
   }
   
   free(isPrime);
   return isSimple;
}


#pragma mark - Persistance

+ (NSString *)pathToSaveCachedResults
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths firstObject];
   NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/cachedResults"];
   
   return filePath;
}

+ (void)saveResults:(NSArray *)generatedNumbers forNumber:(NSString *)limit
{
   PGSearchHistory *cachedResults = [self loadCachedResults];
   if (!cachedResults) {
      cachedResults = [[PGSearchHistory alloc] init];
   }
   BOOL savedSuccessfully = [cachedResults saveToHistory:limit numbers:generatedNumbers];
   if (savedSuccessfully) {
      [NSKeyedArchiver archiveRootObject:cachedResults toFile:[self pathToSaveCachedResults]];
   }
}

+ (id)loadCachedResults
{
   NSString *cachedPath = [self pathToSaveCachedResults];
   if ([[NSFileManager defaultManager] fileExistsAtPath:cachedPath]) {
      id cachedResults = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedPath];
      return cachedResults;
   }
   
   return nil;
}

@end