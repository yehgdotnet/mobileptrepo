// https://gist.github.com/joswr1ght/4480de9862284fc74f6e
// Demonstration code to detect runtime method swizzling with Cydia Substrate/Cycript.

// Compile with:
// clang catchredir.m -o catchredir -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ -miphoneos-version-min=7 -framework Foundation
#import <Foundation/Foundation.h>
#import <stdio.h>
#import <objc/runtime.h>

@interface UrlConnection : NSObject
@property (strong) NSString *url;
- (void)connect;
@end

@implementation UrlConnection
- (void)connect {
	// Connect to a server, or other behavior the attacker wants to change
}
@end

int main() {
	Class ucclass = objc_getClass("UrlConnection");
	SEL sel = sel_getUid("connect");
	IMP runtimeimp, ucconnectimp = class_getMethodImplementation(ucclass, sel);

	while(1) {
		[NSThread sleepForTimeInterval:10.0f];
		ucclass = objc_getClass("UrlConnection");
		sel = sel_getUid("connect");
		runtimeimp = class_getMethodImplementation(ucclass, sel);
		printf("pointer %p and %p\n", ucconnectimp, runtimeimp);
		if (runtimeimp != ucconnectimp) printf("Modification Detected\n");
	}
	return 0;
}
