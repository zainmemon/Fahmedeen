//
//  WebService.h
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 04/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

-(NSMutableArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree parameterFour:(NSString*)parameterFour;

-(NSMutableArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne;

-(NSString *)convertingArrayIntoJsonString: (NSMutableArray *) arrayOne;
@end
