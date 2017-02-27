//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014-2016 Scott Talbot.

#import <Foundation/Foundation.h>


@protocol STHALLinks;
@protocol STHALEmbeddedResources;
@protocol STHALResource <NSObject>
@property (nonatomic,strong,nullable,readonly) id<STHALLinks> links;
@property (nonatomic,copy,nonnull,readonly) NSDictionary<NSString *, id> *payload;
@property (nonatomic,strong,nullable,readonly) id<STHALEmbeddedResources> embeddedResources;
@end

@protocol STHALLink;
@protocol STHALLinks <NSObject>
@property (nonatomic,copy,nonnull,readonly) NSArray<NSString *> *relationNames;
- (id<STHALLink> __nullable)linkForRelationNamed:(NSString * __nonnull)name;
- (NSArray<id<STHALLink>> * __nullable)linksForRelationNamed:(NSString * __nonnull)name;
- (id __nullable)objectForKeyedSubscript:(NSString * __nonnull)name;
@end

@protocol STHALLink <NSObject>
@property (nonatomic,copy,nonnull,readonly) NSString *name;
@property (nonatomic,copy,nullable,readonly) NSString *title;
@property (nonatomic,copy,nullable,readonly) NSString *type;
@property (nonatomic,copy,nullable,readonly) NSString *hreflang;
@property (nonatomic,copy,nonnull,readonly) NSArray<NSString *> *templateVariableNames;
@property (nonatomic,copy,nullable,readonly) NSURL *url;
- (NSURL * __nullable)urlWithVariables:(NSDictionary<NSString *, id> * __nullable)variables;
@property (nonatomic,copy,nullable,readonly) NSString *deprecation;
@end

@protocol STHALEmbeddedResources <NSObject>
@property (nonatomic,copy,nonnull,readonly) NSArray<NSString *> *resourceNames;
- (id<STHALResource> __nullable)resourceNamed:(NSString * __nullable)name;
- (NSArray * __nullable)resourcesNamed:(NSString * __nullable)name;
- (id __nullable)objectForKeyedSubscript:(NSString * __nullable)name;
@end


typedef NS_OPTIONS(NSUInteger, STHALResourceReadingOptions) {
    STHALResourceReadingOptionsNone = 0,
    STHALResourceReadingAllowSimplifiedLinks = 0x1,
    STHALResourceReadingInferBaseURL = 0x2,
};

typedef NS_OPTIONS(NSUInteger, STHALResourceWritingOptions) {
    STHALResourceWritingOptionsNone = 0,
    STHALResourceWritingWriteSimplifiedLinks = 0x1,
};

@interface STHALResource : NSObject<STHALResource>
- (instancetype __null_unspecified)init NS_UNAVAILABLE;
- (instancetype __nonnull)initWithDictionary:(NSDictionary<NSString *, id> * __nonnull)dict baseURL:(NSURL * __nullable)baseURL;
- (instancetype __nonnull)initWithDictionary:(NSDictionary<NSString *, id> * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options NS_DESIGNATED_INITIALIZER;
@property (nonatomic,strong,nullable,readonly) id<STHALLinks> links;
@property (nonatomic,copy,nonnull,readonly) NSDictionary<NSString *, id> *payload;
@property (nonatomic,strong,nullable,readonly) id<STHALEmbeddedResources> embeddedResources;
- (NSDictionary<NSString *, id> * __nonnull)dictionaryRepresentation;
- (NSDictionary<NSString *, id> * __nonnull)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end
