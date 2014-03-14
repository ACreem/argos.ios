//
//  ImageDownloader.h
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

@interface ImageDownloader : NSObject

@property (nonatomic, copy) void (^completionHandler)(UIImage* image);

- (id)initWithURL:(NSURL*)url;
- (void)startDownload;
- (void)cancelDownload;

@end
