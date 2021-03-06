////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  BoshRequest.m
//
//  Created by Dalton Cherry on 10/31/13.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "BoshRequest.h"

@interface BoshRequest ()

@property(nonatomic,strong)NSMutableData* receivedData;
@property(nonatomic,strong)NSURLConnection* connection;
@property(nonatomic,strong)BOSHRequestSuccess success;
@property(nonatomic,strong)BOSHRequestFailure failure;

@end

@implementation BoshRequest

////////////////////////////////////////////////////////////////////////////////////////////////////
-(instancetype)initWithRequest:(NSURLRequest*)request
{
    if(self = [super init])
    {
        self.isEmpty = NO;
        self.receivedData = [[NSMutableData alloc] init];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)start:(BOSHRequestSuccess)success failure:(BOSHRequestFailure)failure
{
    self.success = success;
    self.failure = failure;
    [self.connection start];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)start
{
    [self.connection start];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)cancel
{
    [self.connection cancel];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectionDidFinishLoading:(NSURLConnection *)currentConnection
{
    if(self.success)
        self.success(self);
    if([self.delegate respondsToSelector:@selector(requestFinished:)])
        [self.delegate requestFinished:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)currentConnection didFailWithError:(NSError *)error
{
    //connectionError = error;
    if(self.failure)
        self.failure(error);
    if([self.delegate respondsToSelector:@selector(requestFailed:)])
        [self.delegate requestFailed:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //NSLog(@"DEBUG header: %@", [httpResponse allHeaderFields]);
    [self.receivedData setLength:0];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(XMLElement*)responseElement
{
    NSString* string = [[NSString alloc] initWithBytes:[self.receivedData bytes]
                                                length:[self.receivedData length] encoding:NSUTF8StringEncoding];
    return [string XMLObjectFromString];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)description
{
    return [NSString stringWithFormat:@"empty: %@ request: %@",self.isEmpty ? @"YES" : @"NO",self.connection.originalRequest];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    self.success = nil;
    self.failure = nil;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
