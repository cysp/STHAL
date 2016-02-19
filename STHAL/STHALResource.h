//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol STHALLinks;
@protocol STHALEmbeddedResources;
@protocol STHALResource <NSObject>
@property (nonatomic,strong,readonly,nullable) id<STHALLinks> links;
@property (nonatomic,copy,readonly) NSDictionary *payload;
@property (nonatomic,strong,readonly,nullable) id<STHALEmbeddedResources> embeddedResources;
@end

@protocol STHALLink;
@protocol STHALLinks <NSObject>
@property (nonatomic,copy,readonly) NSArray<NSString *> *relationNames;
- (id<STHALLink> __nullable)linkForRelationNamed:(NSString *)name;
- (NSArray<id<STHALLink>> * __nullable)linksForRelationNamed:(NSString *)name;
- (id __nullable)objectForKeyedSubscript:(NSString *)name;
@end

@protocol STHALLink <NSObject>
@property (nonatomic,copy,readonly,nullable) NSString *name;
@property (nonatomic,copy,readonly,nullable) NSString *title;
@property (nonatomic,copy,readonly,nullable) NSString *type;
@property (nonatomic,copy,readonly,nullable) NSString *hreflang;
@property (nonatomic,copy,readonly) NSArray<NSString *> *templateVariableNames;
@property (nonatomic,copy,readonly,nullable) NSURL *url;
- (NSURL * __nullable)urlWithVariables:(NSDictionary<NSString *, id> * __nullable)variables;
@property (nonatomic,copy,readonly,nullable) NSURL *deprecation;
@end

@protocol STHALEmbeddedResources <NSObject>
@property (nonatomic,copy,readonly) NSArray<NSString *> *resourceNames;
- (id<STHALResource> __nullable)resourceNamed:(NSString *)name;
- (NSArray<id<STHALResource>> * __nullable)resourcesNamed:(NSString *)name;
- (id __nullable)objectForKeyedSubscript:(NSString *)name;
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
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL * __nullable)baseURL;
- (instancetype)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL * __nullable)baseURL options:(STHALResourceReadingOptions)options NS_DESIGNATED_INITIALIZER;
@property (nonatomic,strong,readonly) id<STHALLinks> links;
@property (nonatomic,copy,readonly) NSDictionary *payload;
@property (nonatomic,strong,readonly) id<STHALEmbeddedResources> embeddedResources;
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)dictionaryRepresentationWithOptions:(STHALResourceWritingOptions)options;
@end

NS_ASSUME_NONNULL_END
