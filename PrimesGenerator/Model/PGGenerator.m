#import "PGGenerator.h"

@implementation PGGenerator

+ (NSArray *)generateSimples:(Number)limit
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

// generate simples (only odd numbers) ~2x faster
+ (NSArray *)generateSimplesOdd:(Number)limit
{
   NSMutableArray *isSimple = [NSMutableArray array];
   if (limit < 2) {
      return isSimple;
   }
   
   const Number lastNumberSqrt = (int)sqrt((double)limit);
   Number memorySize = (limit-1)/2;
   char *isPrime = (char *) malloc(sizeof(char *) * (memorySize+1));
   
   for (Number i = 0; i <= memorySize; i++) {
      isPrime[i] = 1;
   }
   
   for (Number i = 3; i <= lastNumberSqrt; i += 2) {
      if (isPrime[i/2]) {
         for (Number j = i*i; j <= limit; j += 2*i) {
            isPrime[j/2] = 0;
         }
      }
   }
   
   if (lastNumber >=2) [isSimple addObject:@2];
   for (Number i = 1; i <= memorySize; i++) {
      if (isPrime[i]) {
         [isSimple addObject:@(i*2 + 1)];
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