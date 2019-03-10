---
title: A YANG Data Model for a Transport Services API at Endpoints
abbrev: TAPS API Yang Model
docname: draft-jholland-taps-api-yang-01
date: 2019-03-09
category: std

ipr: trust200902
area: Tsv
workgroup: Taps
keyword: Internet-Draft

stand_alone: yes
pi: [toc, sortrefs, symrefs]

author:
 -
    ins: J. Holland
    name: Jake Holland
    org: Akamai Technologies, Inc.
    street: 150 Broadway
    city: Cambridge, MA 02144
    country: United States of America
    email: jakeholland.net@gmail.com

normative:
  I-D.ietf-taps-arch:
  I-D.ietf-taps-interface:
  RFC2119:
  RFC6991:
  RFC7950:
  RFC8174:
  RFC8340:
  RFC8343:
  RFC8407:

--- abstract

This document defines a YANG data model that provides a data structure
that can be used to configure an implementation of the Transport
Services Interface to establish connections suitable for sending
and receiving data over the internet or local networks.  This document
is intended to supplement or merge with draft-ietf-taps-interface.

--- middle

# Introduction {#intro}

This document is an attempt to concretize the properties and objects of
the TAPS interface described in {{I-D.ietf-taps-interface}}, under the
architecture described in {{I-D.ietf-taps-arch}}.

A TAPS-compliant implementation SHOULD provide a language-appropriate way to
configure a PreConnection using YANG instance data for this model, and
SHOULD provide an API that outputs the YANG instance data for an
established Connection.

An implementation MAY also provide appropriate APIs for directly editing
the objects without using YANG.  It's RECOMMENDED where possible to use
names that mechanically translate to the names in the YANG data model,
using capitalization and punctuation conventions as expected for the
language of the implementation.

Non-TAPS extensions to API objects that directly edit TAPS properties
are RECOMMENDED to include "ext", "EXT", or "Ext" as a prefix to any
extension properties or methods, to avoid colliding with future TAPS
extensions.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY",
and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{RFC2119}} {{RFC8174}} when, and only when, they
appear in all capitals, as shown here.

## A Note On The Use Of YANG

Although YANG was originally designed to model data for NETCONF, YANG
can be used in other ways as well, as described by Section 4.1 of
{{RFC7950}}.

This usage is not primarily targeted at NETCONF, but rather at
Application Programming Interfaces for libraries that set up connections
for sending and receiving data over the internet.  However, use of YANG
in this context provides a semantically clear, well defined, extensible,
cross-platform method for configuring connection objects suitable for
replacing BSD sockets in a wide variety of applications.

# Tree Diagram

Tree diagrams used in this document follow the notation defined in
{{RFC8340}}.

~~~
YANG-TREE ietf-taps-api.yang
~~~
{: title="Tree Diagram" }

# Examples

## Basic Client Connection

The API is designed to allow defaults to fill out almost everything.
This example shows the minimal preconnection configuration input data
to open a reliable transfer to example.com, via any supported reliable
transport protocol on the default port or ports.

~~~
YANG-DATA ietf-taps-api.yang example-basic-client.json
~~~
{: title="Basic Client Connection" }

Due to the defaults recommended in (TBD: fix reference) Section 5 of
draft-ietf-taps-interface-02, implementations SHOULD treat this basic
example equivalently to the same example with the defaults explicitly
provided:

~~~
YANG-DATA ietf-taps-api.yang example-default-basic-client.json
~~~
{: title="Basic Client Connection Explicitly Declaring Defaults" }

## Customized Connections

In some cases, applications may have explicit preferences, either
dynamically inferred from past statistics or configured via system
or app preferences of some kind.

These examples demonstrates adding constraints on the endpoints when
opening a connection.

### Prohibit Specific Interface

In this example, an app needs to avoid using a local proxy for a
specific set of connections, so it might configure those connections
to prohibit connecting through a specific loopback interface:

~~~
YANG-DATA ietf-taps-api.yang example-customize-noloopback.json
~~~
{: #yang-data-customize-noloopback title="Customized to avoid lo0"}

### Require Wi-Fi

This example demonstrates an app that requires the use of a wireless
interface:

~~~
YANG-DATA ietf-taps-api.yang example-customize-wireless.json
~~~
{: #yang-data-customize-wifi title="Customized to require wireless."}

## Send and Receive Multicast

Sending to a multicast group is the same as any non-reliable,
non-ordered connection:

~~~
YANG-DATA ietf-taps-api.yang example-send-multicast.json
~~~
{: #yang-data-send-multicast title="PreConnection for Sending Multicast"}

Receiving multicast is similar.  It may use remote-endpoint to specify a
source-specific multicast subscription, or exclude it to specify
any-source multicast.

~~~
YANG-DATA ietf-taps-api.yang example-receive-multicast.json
~~~
{: #yang-data-rx-multicast title="PreConnection for Source-specific Multicast Receive"}

# YANG Module {#yang-module}

~~~~~~~~~~
YANG-MODULE ietf-taps-api.yang
~~~~~~~~~~
{: #yang-model title="TAPS Interface YANG model"}

# Security Considerations

This document describes a configuration system for an API that may
replace sockets.  All security considerations applicable to socket
programming should be carefully considered by implementors.

(TBD: surely there is a sane reference, but also fill this out with
something less laughable.  In particular, enumerate which options should
be privileged operations or not to preserve the security of BSD sockets,
such as it is.  And maybe another layer of restriction recommendations for
sandboxed or browser systems.)

# IANA Considerations

IANA is requested to add the YANG model in {{yang-module}} to the
yang-parameters registry.

~~~
       +-----------+-------------------------------------------+
       | Field     | Value                                     |
       +-----------+-------------------------------------------+
       | Name      | ietf-taps-api                             |
       | Namespace | urn:ietf:params:xml:ns:yang:ietf-taps-api |
       | Prefix    | taps                                      |
       | Reference | [TBD: this document]                      |
       +-----------+-------------------------------------------+
~~~
{: title="Template from Section 5 of [RFC8407]}

--- back

# Future Work

TBD if adopted:

 * Review {{RFC8407}} guidelines for YANG authors and reviewers, make sure
   they are followed.
 * Start a reference implementation. No doubt it will highlight many
   model problems.
 * many more config examples with use cases
 * Look into providing explicit layers that support some kind of
   pass-thru, instead of having all properties in big groups of
   properties.

