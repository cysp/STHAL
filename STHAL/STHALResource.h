//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <Foundation/Foundation.h>


@protocol STHALLinks;
@protocol STHALEmbeddedResources;
@protocol STHALResource <NSObject>
@property (nonatomic,strong,readonly) id<STHALLinks> __nullable links;
@property (nonatomic,copy,readonly) NSDictionary * __nonnull payload;
@property (nonatomic,strong,readonly) id<STHALEmbeddedResources> __nullable embeddedResources;
@end

@protocol STHALLink;
@protocol STHALLinks <NSObject>
@property (nonatomic,copy,readonly) NSArray * __nonnull relationNames;
- (id<STHALLink> __nullable)linkForRelationNamed:(NSString * __nonnull)name;
- (NSArray * __nullable)linksForRelationNamed:(NSString * __nonnull)name;
- (id __nullable)objectForKeyedSubscript:(NSString * __nonnull)name;
@end

@protocol STHALLink <NSObject>
@property (nonatomic,copy,readonly) NSString * __nullable name;
@property (nonatomic,copy,readonly) NSString * __nullable title;
@property (nonatomic,copy,readonly) NSString * __nullable type;
@property (nonatomic,copy,readonly) NSString * __nullable hreflang;
@property (nonatomic,copy,readonly) NSArray * __nonnull templateVariableNames;
@property (nonatomic,copy,readonly) NSURL * __nullable url;
- (NSURL * __nullable)urlWithVariables:(NSDictionary * __nullable)variables;
@property (nonatomic,copy,readonly) NSURL * __nullable deprecation;
@end

@protocol STHALEmbeddedResources <NSObject>
@property (nonatomic,copy,readonly) NSArray * __nonnull resourceNames;
- (id<STHALResource> __nullable)resourceNamed:(NSString * __nonnull)name;
- (NSArray * __nullable)resourcesNamed:(NSString * __nonnull)name;
- (id __nullable)objectForKeyedSubscript:(NSString * __nonnull)name;
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
- (id __nullable)initWithDictionary:(NSDictionary * __nonnull)dict baseURL:(NSURL * __nullable)baseURL;
- (id __nullable)initWithDictionary:(NSDictionary * __nonnull)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options;
@property (nonatomic,strong,readonly) id<STHALLinks> __nullable links;
@property (nonatomic,copy,readonly) NSDictionary * __nonnull payload;
@property (nonatomic,strong,readonly) id<STHALEmbeddedResources> __nullable embeddedResources;
- (NSDictionary * __nonnull)dictionaryRepresentation;
- (NSDictionary * __nonnull)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end
