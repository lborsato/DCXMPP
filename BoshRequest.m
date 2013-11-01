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

@end

@implementation BoshRequest

////////////////////////////////////////////////////////////////////////////////////////////////////
-(instancetype)initWithRequest:(NSURLRequest*)request
{
    if(self = [super init])
    {
        self.receivedData = [[NSMutableData alloc] init];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)start
{
    [self.connection start];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectionDidFinishLoading:(NSURLConnection *)currentConnection
{
    if([self.delegate respondsToSelector:@selector(requestFinished:)])
        [self.delegate requestFinished:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)currentConnection didFailWithError:(NSError *)error
{
    //connectionError = error;
    if([self.delegate respondsToSelector:@selector(requestFailed:)])
        [self.delegate requestFailed:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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

@end
