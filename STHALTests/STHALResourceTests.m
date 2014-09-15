//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <XCTest/XCTest.h>

#import <STHAL/STHAL.h>


@interface STHALResourceTests : XCTestCase
@end

@implementation STHALResourceTests

- (void)test1 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url];
    XCTAssertNotNil(resource);
    XCTAssertNil(resource.links);

    XCTAssertEqualObjects(resource.payload, input);

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

- (void)test2 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"_links": @{
            @"self": @{ @"href": @"/gluh", },
            @"gluh": @[
                @{ @"href": @"/gluh1", },
                @{ @"href": @"/gluh2", },
            ],
        },
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url];
    XCTAssertNotNil(resource);
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"self"]).url.absoluteString), @"http://example.org/gluh");

    NSArray * const gluhLinks = resource.links[@"gluh"];
    XCTAssertEqual(gluhLinks.count, 2U);
    XCTAssertEqualObjects((((id<STHALLink>)gluhLinks[0]).url.absoluteString), @"http://example.org/gluh1");
    XCTAssertEqualObjects((((id<STHALLink>)gluhLinks[1]).url.absoluteString), @"http://example.org/gluh2");
    
    NSDictionary * const payload = @{ @"foo": @"bar" };
    XCTAssertEqualObjects(resource.payload, payload);

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

- (void)test3 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"_links": @{
            @"self": @"/gluh",
            @"gluh": @[ @"/gluh1", @"gluh2" ],
        },
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url options:STHALResourceReadingAllowSimplifiedLinks];
    XCTAssertNotNil(resource);
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"self"]).url.absoluteString), @"http://example.org/gluh");

    NSArray * const gluhLinks = resource.links[@"gluh"];
    XCTAssertEqual(gluhLinks.count, 2U);
    XCTAssertEqualObjects((((id<STHALLink>)gluhLinks[0]).url.absoluteString), @"http://example.org/gluh1");
    XCTAssertEqualObjects((((id<STHALLink>)gluhLinks[1]).url.absoluteString), @"http://example.org/gluh2");

    NSDictionary * const payload = @{ @"foo": @"bar" };
    XCTAssertEqualObjects(resource.payload, payload);

    XCTAssertEqualObjects([resource dictionaryRepresentationWithOptions:STHALResourceWritingWriteSimplifiedLinks], input);
}

- (void)test4 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"_links": @{
            @"self": @"/gluh",
            @"search": @{ @"href": @"/gluh{?q}", @"templated": @YES },
        },
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url options:STHALResourceReadingAllowSimplifiedLinks];
    XCTAssertNotNil(resource);
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"self"]).url.absoluteString), @"http://example.org/gluh");

    NSURL * const searchURL = [[resource.links linkForRelationNamed:@"search"] urlWithVariables:@{ @"q": @"wibble" }];
    XCTAssertEqualObjects(searchURL.absoluteString, @"http://example.org/gluh?q=wibble");

    NSDictionary * const payload = @{ @"foo": @"bar" };
    XCTAssertEqualObjects(resource.payload, payload);

    {
        NSDictionary * const expected = @{
            @"_links": @{
                @"self": @{ @"href": @"/gluh", @"templated": @YES },
                @"search": @{ @"href": @"/gluh{?q}", @"templated": @YES },
            },
            @"foo": @"bar",
        };
        XCTAssertEqualObjects([resource dictionaryRepresentationWithOptions:STHALResourceWritingOptionsNone], expected);
    }
    {
        NSDictionary * const expected = @{
            @"_links": @{
                @"self": @"/gluh",
                @"search": @"/gluh{?q}",
            },
            @"foo": @"bar",
        };
        XCTAssertEqualObjects([resource dictionaryRepresentationWithOptions:STHALResourceWritingWriteSimplifiedLinks], expected);
    }
}

- (void)test5 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"_links": @{ },
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url options:STHALResourceReadingAllowSimplifiedLinks];
    XCTAssertNotNil(resource);
    XCTAssertNotNil(resource.links);

    NSDictionary * const payload = @{ @"foo": @"bar" };
    XCTAssertEqualObjects(resource.payload, payload);

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

- (void)test6 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/"];
    NSDictionary * const input = @{
        @"_links": @[ @"hmm" ],
        @"foo": @"bar",
    };

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url options:STHALResourceReadingAllowSimplifiedLinks];
    XCTAssertNotNil(resource);
    XCTAssertNil(resource.links);

    NSDictionary * const payload = @{ @"foo": @"bar", @"_links": @[ @"hmm" ] };
    XCTAssertEqualObjects(resource.payload, payload);

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

- (void)testSpecExample1 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/orders"];
    NSData * const inputData = [@"{\
        \"_links\": {\
            \"self\": { \"href\": \"/orders\" },\
            \"next\": { \"href\": \"/orders?page=2\" },\
            \"find\": { \"href\": \"/orders{?id}\", \"templated\": true }\
        },\
        \"_embedded\": {\
            \"orders\": [{\
                \"_links\": {\
                    \"self\": { \"href\": \"/orders/123\" },\
                    \"basket\": { \"href\": \"/baskets/98712\" },\
                    \"customer\": { \"href\": \"/customers/7809\" }\
                },\
                \"total\": 30.00,\
                \"currency\": \"USD\",\
                \"status\": \"shipped\",\
            },{\
                \"_links\": {\
                    \"self\": { \"href\": \"/orders/124\" },\
                    \"basket\": { \"href\": \"/baskets/97213\" },\
                    \"customer\": { \"href\": \"/customers/12369\" }\
                },\
                \"total\": 20.00,\
                \"currency\": \"USD\",\
                \"status\": \"processing\"\
            }]\
        },\
        \"currentlyProcessing\": 14,\
        \"shippedToday\": 20\
    }" dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    NSDictionary * const input = [NSJSONSerialization JSONObjectWithData:inputData options:(NSJSONReadingOptions)0 error:NULL];
    XCTAssertNotNil(input, @"error: %@", error);

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url];
    XCTAssertNotNil(resource);
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"self"]).url.absoluteString), @"http://example.org/orders");

    id<STHALLinks> const links = resource.links;
    XCTAssertNotNil(links);
    XCTAssertEqualObjects([NSSet setWithArray:links.relationNames], ([NSSet setWithObjects:@"self", @"next", @"find", nil]));

    XCTAssertEqualObjects(resource.payload, (@{ @"currentlyProcessing": @14, @"shippedToday": @20 }));

    id<STHALEmbeddedResources> const embedded = resource.embeddedResources;
    XCTAssertNotNil(embedded);
    XCTAssertEqualObjects([NSSet setWithArray:embedded.resourceNames], ([NSSet setWithObjects:@"orders", nil]));

    NSArray * const embeddedOrders = [embedded resourcesNamed:@"orders"];
    XCTAssertNotNil(embeddedOrders);
    XCTAssert([embeddedOrders isKindOfClass:[NSArray class]]);
    XCTAssertEqual(embeddedOrders.count, 2U);

    id<STHALResource> const embeddedOrder1 = embeddedOrders[0];
    XCTAssertEqualObjects((((id<STHALLink>)embeddedOrder1.links[@"self"]).url.absoluteString), @"http://example.org/orders/123");
    XCTAssertEqualObjects(embeddedOrder1.payload, (@{ @"total": @30, @"currency": @"USD", @"status": @"shipped" }));

    id<STHALResource> const embeddedOrder2 = embeddedOrders[1];
    XCTAssertEqualObjects(embeddedOrder2.payload, (@{ @"total": @20, @"currency": @"USD", @"status": @"processing" }));
    XCTAssertEqualObjects((((id<STHALLink>)embeddedOrder2.links[@"self"]).url.absoluteString), @"http://example.org/orders/124");

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

- (void)testSpecExample2 {
    NSURL * const url = [NSURL URLWithString:@"http://example.org/orders/"];
    NSData * const inputData = [@"{\
        \"_links\": {\
            \"self\": { \"href\": \"/orders\" },\
            \"next\": { \"href\": \"/orders?page=2\" },\
            \"ea:find\": {\
                \"href\": \"/orders{?id}\",\
                \"templated\": true\
            },\
            \"ea:admin\": [{\
                \"href\": \"/admins/2\",\
                \"title\": \"Fred\"\
            }, {\
                \"href\": \"/admins/5\",\
                \"title\": \"Kate\"\
            }]\
        },\
        \"currentlyProcessing\": 14,\
        \"shippedToday\": 20,\
        \"_embedded\": {\
            \"ea:order\": [{\
                \"_links\": {\
                    \"self\": { \"href\": \"/orders/123\" },\
                    \"ea:basket\": { \"href\": \"/baskets/98712\" },\
                    \"ea:customer\": { \"href\": \"/customers/7809\" }\
                },\
                \"total\": 30.00,\
                \"currency\": \"USD\",\
                \"status\": \"shipped\"\
            }, {\
                \"_links\": {\
                    \"self\": { \"href\": \"/orders/124\" },\
                    \"ea:basket\": { \"href\": \"/baskets/97213\" },\
                    \"ea:customer\": { \"href\": \"/customers/12369\" }\
                },\
                \"total\": 20.00,\
                \"currency\": \"USD\",\
                \"status\": \"processing\"\
            }]\
        }\
    }" dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    NSDictionary * const input = [NSJSONSerialization JSONObjectWithData:inputData options:(NSJSONReadingOptions)0 error:NULL];
    XCTAssertNotNil(input, @"error: %@", error);

    STHALResource * const resource = [[STHALResource alloc] initWithDictionary:input baseURL:url];
    XCTAssertNotNil(resource);
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"self"]).url.absoluteString), @"http://example.org/orders");
    XCTAssertEqualObjects((((id<STHALLink>)resource.links[@"next"]).url.absoluteString), @"http://example.org/orders?page=2");

    XCTAssertEqualObjects(resource.payload, (@{ @"currentlyProcessing": @14, @"shippedToday": @20 }));

    XCTAssertEqualObjects(resource.dictionaryRepresentation, input);
}

@end
