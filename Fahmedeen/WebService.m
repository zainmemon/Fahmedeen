//
//  WebService.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 04/05/2014.
//  Copyright (c) 2014 Zohair Hemani - All rights reserved.
//

#import "WebService.h"

@implementation WebService

-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree parameterFour:(NSString*)parameterFour
{
    NSURL *jsonFileUrl = [NSURL URLWithString:filepath];
    
    // Create the NSURLConnection
    
    //NSString * storedsession = [[NSUserDefaults standardUserDefaults] stringForKey:@"college"];
    
    NSString *myRequestString = [NSString stringWithFormat:@"type=%@&parameterTwo=%@",parameterOne,parameterTwo];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: jsonFileUrl];
    // set Request Type
    NSError *err = nil;
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: returnData options: NSJSONReadingMutableContainers error: &err];
    
    NSLog(@"Response String: %@",response);
    NSLog(@"JsonArray %@", jsonArray);
    
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
    // return response;
    return jsonArray;
}

-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne
{
    
    NSArray *responseArray = [self FilePath:filepath parameterOne:parameterOne parameterTwo:nil parameterThree:nil parameterFour:nil];
    return responseArray;
}

-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo
{
    NSArray * responseArray = [self FilePath:filepath parameterOne:parameterOne parameterTwo:parameterTwo parameterThree:nil parameterFour:nil];
    return responseArray;
}

-(NSArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree
{
    NSArray * responseArray = [self FilePath:filepath parameterOne:parameterOne parameterTwo:parameterTwo parameterThree:parameterThree parameterFour:nil];
    return responseArray;
}
-(NSArray*)FilePath:(NSString*)filepath
{
    NSArray *responseArray = [self FilePath:filepath parameterOne:nil parameterTwo:nil parameterThree:nil];
    return responseArray;
}

-(NSString *)convertingArrayIntoJsonString: (NSMutableArray *) arrayOne{
    NSError *error = nil;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:arrayOne
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if ([jsonData length] > 0 &&
        error == nil)
    {
        //NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
        jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
    }
    return jsonString;
}

@end
