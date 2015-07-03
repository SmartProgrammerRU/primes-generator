#import "PGSeachResult.h"

@implementation PGSeachResult

- (instancetype)initWithLimit:(NSString *)limit numbers:(NSArray *)numbers
{
   if (self = [super init]) {
      _limit = limit;
      _generatedNumbers = numbers;
   }
   
   return self;
}

#pragma mark - NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder
{
   [aCoder encodeObject:_limit forKey:@"limit"];
   [aCoder encodeObject:_generatedNumbers forKey:@"generatedNumbers"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   if (self = [super init]) {
      _limit = [aDecoder decodeObjectForKey:@"limit"];
      _generatedNumbers = [aDecoder decodeObjectForKey:@"generatedNumbers"];
   }
   
   return self;
}

@end