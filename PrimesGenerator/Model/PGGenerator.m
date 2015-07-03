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

+ (void)saveResults:(id)results
{
   NSString *cachedPath = [self pathToSaveCachedResults];
   
   /* for testing purposes limit fileSize up to 50Mb; if exceeeds, clean old data */
   static const unsigned long long maxFileSize = 50 * 1024 * 1024;
   unsigned long long size =
   [[NSFileManager defaultManager] attributesOfItemAtPath:cachedPath error:nil].fileSize;
   if (size > maxFileSize) {
      [[NSFileManager defaultManager] removeItemAtPath:cachedPath error:nil];
   }
   
   NSMutableArray *cachedResults = [self loadCachedResults];
   if (!cachedResults) {
      cachedResults = [NSMutableArray array];
   }
   [cachedResults addObject:results];
   
   NSLog(@"archived: %d", [NSKeyedArchiver archiveRootObject:cachedResults toFile:cachedPath]);
}

+ (id)loadCachedResults
{
   NSString *cachedPath = [self pathToSaveCachedResults];
   if ([[NSFileManager defaultManager] fileExistsAtPath:cachedPath]) {
      NSMutableArray *cachedResults = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedPath];
      return cachedResults;
   }
   
   return nil;
}

@end