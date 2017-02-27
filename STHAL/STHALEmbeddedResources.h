//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <STHAL/STHAL.h>


@interface STHALEmbeddedResources : NSObject<STHALEmbeddedResources>
- (instancetype)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options NS_DESIGNATED_INITIALIZER;
- (NSDictionary *)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end
