//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import "STHALLinks.h"

#import "STHALTypeSafety.h"

#import <STURITemplate/STURITemplate.h>


@interface STHALLink : NSObject<STHALLink>
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options;
@end

@interface STHALTemplatedLink : NSObject<STHALLink>
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options;
@end


@implementation STHALLinks {
@private
    NSDictionary *_links;
}

+ (NSArray *)linksForRelationNamed:(NSString *)name inDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSArray * __block links = nil;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * const relationName = STHALEnsureNSString(key);
        if (!relationName) {
            return;
        }
        if (![name isEqualToString:relationName]) {
            return;
        }

        links = [self linksFromLinkJSONObject:obj baseURL:baseURL options:options];
    }];
    return links;
}

+ (NSArray *)linksFromLinkJSONObject:(id)object baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSMutableArray * const linksForName = [[NSMutableArray alloc] initWithCapacity:1];

    NSArray *linkObjects = STHALEnsureNSArray(object);
    if (!linkObjects && object) {
        linkObjects = @[ object ];
    }
    for (id linkObject in linkObjects) {
        NSDictionary * const linkDictionary = STHALEnsureNSDictionary(linkObject);
        if (linkDictionary) {
            if (linkDictionary[@"templated"]) {
                id<STHALLink> const link = [[STHALTemplatedLink alloc] initWithDictionary:linkDictionary baseURL:baseURL options:options];
                if (link) {
                    [linksForName addObject:link];
                }
            } else {
                id<STHALLink> const link = [[STHALLink alloc] initWithDictionary:linkDictionary baseURL:baseURL options:options];
                if (link) {
                    [linksForName addObject:link];
                }
            }
            continue;
        } else if (options & STHALResourceReadingAllowSimplifiedLinks) {
            NSString * const linkString = STHALEnsureNSString(linkObject);
            if (linkString) {
                NSDictionary * const linkDictionary = @{ @"href": linkString, @"templated": @YES };
                id<STHALLink> const link = [[STHALTemplatedLink alloc] initWithDictionary:linkDictionary baseURL:baseURL options:options];
                if (link) {
                    [linksForName addObject:link];
                }
                continue;
            }
        }
    }

    return linksForName.copy;
}

- (id)init {
    return [self initWithDictionary:nil baseURL:nil options:0];
}
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSParameterAssert(dict);
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSParameterAssert(baseURL);
    if (!baseURL) {
        return nil;
    }

    if ((self = [super init])) {
        NSMutableDictionary * const links = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString * const relationName = STHALEnsureNSString(key);
            if (!relationName) {
                return;
            }

            NSArray * const linksForName = [self.class linksFromLinkJSONObject:obj baseURL:baseURL options:options];
            links[relationName] = linksForName ?: @[];
        }];
        _links = links.copy;
    }
    return self;
}


- (NSArray *)relationNames {
    return [_links.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (id<STHALLink>)linkForRelationNamed:(NSString *)name {
    return STHALEnsureNSArray(_links[name]).firstObject;
}
- (NSArray *)linksForRelationNamed:(NSString *)name {
    return STHALEnsureNSArray(_links[name]);
}

- (id)objectForKeyedSubscript:(NSString *)name {
    NSArray * const links = STHALEnsureNSArray(_links[name]);
    if (links.count <= 1) {
        return links.firstObject;
    }
    return links;
}

@end


@implementation STHALLink {
@private
    NSString *_name;
    NSURL *_url;
}

- (id)init {
    return [self initWithDictionary:nil baseURL:nil options:0];
}
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSParameterAssert(dict);
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    if ((self = [super init])) {
        _name = STHALEnsureNSString(dict[@"name"]).copy;
        _type = STHALEnsureNSString(dict[@"type"]).copy;
        NSString * const href = STHALEnsureNSString(dict[@"href"]);
        _url = [NSURL URLWithString:href relativeToURL:baseURL];
    }
    return self;
}

@synthesize name = _name;
@synthesize type = _type;
@synthesize deprecation = _deprecation;

- (NSArray *)templateVariableNames {
    return @[];
}

@synthesize url = _url;
- (NSURL *)urlWithVariables:(NSDictionary *)variables {
    return _url;
}

@end


@implementation STHALTemplatedLink {
@private
    NSString *_name;
    STURITemplate *_template;
    NSURL *_baseURL;
}

- (id)init {
    return [self initWithDictionary:nil baseURL:nil options:0];
}
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSParameterAssert(dict);
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    if ((self = [super init])) {
        _name = STHALEnsureNSString(dict[@"name"]).copy;
        _type = STHALEnsureNSString(dict[@"type"]).copy;
        NSString * const href = STHALEnsureNSString(dict[@"href"]).copy;
        _template = [[STURITemplate alloc] initWithString:href];
        _baseURL = baseURL.copy;
    }
    return self;
}

@synthesize name = _name;
@synthesize type = _type;
@synthesize deprecation = _deprecation;

- (NSArray *)templateVariableNames {
    return _template.variableNames;
}

- (NSURL *)url {
    NSURL * const url = [_template urlByExpandingWithVariables:nil];
    return [NSURL URLWithString:url.absoluteString relativeToURL:_baseURL];
}
- (NSURL *)urlWithVariables:(NSDictionary *)variables {
    NSURL * const url = [_template urlByExpandingWithVariables:variables];
    if (!url) {
        return nil;
    }
    return [NSURL URLWithString:url.absoluteString relativeToURL:_baseURL];
}

@end
