//
//  bayanSingleton.m
//  Fahmedeen
//
//  Created by Avialdo on 30/05/2016.
//  Copyright © 2016 Zainu Corporation. All rights reserved.
//

#import "bayanSingleton.h"

@implementation bayanSingleton


#pragma mark Singleton Methods

static bayanSingleton *sharedMyManager = nil;

//+ (id)sharedManager {
//    static bayanSingleton *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//    });
//    return sharedMyManager;
//}

+ (id)sharedManager  {
    if (sharedMyManager == nil) {
        sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}


- (id)init {
    if (self = [super init])
    {
        
    }
    return self;
}

-(NSMutableArray*)filterArray:(NSString*)category
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for(int i=0;i<self.bayanArray.count; i++)
    {
        if([[[self.bayanArray objectAtIndex:i]valueForKey:@"category"] isEqualToString:category])
        {
            [filteredArray addObject:[self.bayanArray objectAtIndex:i]];
        }
    }
    return filteredArray;
}

-(void)initWithName:(NSString*)name link:(NSString*)link category:(NSString*)category
{
    NSMutableDictionary *customObject = [[NSMutableDictionary alloc]init];
    customObject[@"name"] = name;
    customObject[@"link"] = link;
    customObject[@"category"] = category;
    
    if(self.bayanArray == nil)
    {
        self.bayanArray = [[NSMutableArray alloc]init];
    }
    
    [self.bayanArray addObject:customObject];
}

enum category {Sunday, Bayanaat, Morning, Mufti, Ramazan, Tafseer, Others};

@end