//  Copyright (c) 2014 Scott Talbot. All rights reserved.

import STURITemplate
import STHAL

let d = [
    "_links": [
        "foo": [ "href": "http://example.org/foo/{?bar}", "templated": true ],
        "bar": "http://example.org/bar{/a,b,c}",
        "barr": "http://example.org/bar{/abc}",
        "baz": "baz{/id}",
    ]
]
let u = NSURL(string: "http://example.org/wibble/")
let r = STHALResource(dictionary: d, baseURL: u, options: STHALResourceReadingOptions.AllowSimplifiedLinks)
r.links.linkForRelationNamed("foo")
r.links.linkForRelationNamed("bar")
r.links.linkForRelationNamed("baz")
r.links.linkForRelationNamed("foo")?.url?.absoluteString
r.links.linkForRelationNamed("bar")?.url?.absoluteString
r.links.linkForRelationNamed("baz")?.url?.absoluteString
r.links.linkForRelationNamed("foo")?.urlWithVariables([:])?.absoluteString
r.links.linkForRelationNamed("bar")?.urlWithVariables([:])?.absoluteString
r.links.linkForRelationNamed("baz")?.urlWithVariables([:])?.absoluteString
r.links.linkForRelationNamed("foo")?.urlWithVariables(["bar": "baz"])?.absoluteString
r.links.linkForRelationNamed("bar")?.urlWithVariables(["a": "0", "b": "1", "c": 2])?.absoluteString
r.links.linkForRelationNamed("bar")?.urlWithVariables(["a": [ "0", "1", 2 ]])?.absoluteString
r.links.linkForRelationNamed("baz")?.urlWithVariables(["id": "foobarbaz"])?.absoluteString
