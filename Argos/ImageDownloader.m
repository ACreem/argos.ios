//
//  ImageDownloader.m
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, strong) NSURL* imageUrl;
@end


@implementation ImageDownloader

- (id)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.imageUrl = url;
    }
    return self;
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageUrl];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler(image);
}


@end
