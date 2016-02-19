//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <STHAL/STHAL.h>

NS_ASSUME_NONNULL_BEGIN


@interface STHALEmbeddedResources : NSObject<STHALEmbeddedResources>
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
- (NSDictionary *)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end

NS_ASSUME_NONNULL_END
