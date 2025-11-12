#import "NSObject+Util.h"

@implementation NSObject(Util)

+ (dispatch_queue_t) currentDispatchQueue {
    // deprecated API used for unit testing only
    return dispatch_get_current_queue();
}

@end
