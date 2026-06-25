#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "album" asset catalog image resource.
static NSString * const ACImageNameAlbum AC_SWIFT_PRIVATE = @"album";

/// The "card" asset catalog image resource.
static NSString * const ACImageNameCard AC_SWIFT_PRIVATE = @"card";

/// The "episodes" asset catalog image resource.
static NSString * const ACImageNameEpisodes AC_SWIFT_PRIVATE = @"episodes";

/// The "greenportal" asset catalog image resource.
static NSString * const ACImageNameGreenportal AC_SWIFT_PRIVATE = @"greenportal";

/// The "locations" asset catalog image resource.
static NSString * const ACImageNameLocations AC_SWIFT_PRIVATE = @"locations";

/// The "logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"logo";

#undef AC_SWIFT_PRIVATE
