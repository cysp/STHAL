//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <STHAL/STHAL.h>


@interface STHALLinks : NSObject<STHALLinks>
+ (NSArray * __nullable)linksForRelationNamed:(NSString * __nonnull)name inDictionary:(NSDictionary * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
- (id __nullable)initWithDictionary:(NSDictionary * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
- (NSDictionary * __nonnull)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end
