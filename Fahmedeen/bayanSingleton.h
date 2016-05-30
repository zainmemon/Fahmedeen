//
//  bayanSingleton.h
//  Fahmedeen
//
//  Created by Avialdo on 30/05/2016.
//  Copyright © 2016 Zainu Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bayanSingleton : NSObject
{
    NSString *someProperty;
}

@property (nonatomic, retain) NSString *bayanName;
@property (nonatomic, retain) NSString *bayanLink;
@property (nonatomic, retain) NSString *bayanCategory;
@property NSMutableArray *bayanArray;

-(void)initWithName:(NSString*)name link:(NSString*)link category:(NSString*)category;
+ (id)sharedManager;
-(NSMutableArray*)filterArray:(NSString*)category;
@end
