//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <STHAL/STHAL.h>


@interface STHALLink : NSObject<STHALLink>
- (instancetype __nullable)initWithDictionary:(NSDictionary<NSString *, NSString *> * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
- (id __nonnull)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end


@interface STHALLinks : NSObject<STHALLinks>
+ (NSArray<STHALLink *> * __nullable)linksForRelationNamed:(NSString * __nonnull)name inDictionary:(NSDictionary<NSString *, NSString *> * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
- (instancetype __null_unspecified)init NS_UNAVAILABLE;
- (instancetype __nullable)initWithDictionary:(NSDictionary<NSString *, NSString *> * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options NS_DESIGNATED_INITIALIZER;
- (NSDictionary<NSString *, id> * __nonnull)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end
