//
//  WebService.h
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 04/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree parameterFour:(NSString*)parameterFour;
-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo;
-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree;
-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne;
-(NSArray*)FilePath:(NSString*)filepath;
-(NSString *)convertingArrayIntoJsonString: (NSMutableArray *) arrayOne;
@end
