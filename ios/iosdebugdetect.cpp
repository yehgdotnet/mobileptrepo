// source url: https://gist.github.com/joswr1ght/fb8c9f4f3f9a2feebf7f
// by Joshua Wright
// Sample code to use ptrace() through dlsym on iOS to terminate when a debugger is attached. NOT FOOLPROOF, but it bypasses Rasticrac decryption.
// Build on OS X with:
// clang debugdetect.cpp -o debugdetect -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ -miphoneos-version-min=7
#import <dlfcn.h>
#import <sys/types.h>
#import <stdio.h>
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
void disable_dbg() {
  ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(RTLD_SELF, "ptrace");
  ptrace_ptr(31, 0, 0, 0); // PTRACE_DENY_ATTACH = 31
}
int main() {
#ifndef DEVEL
  disable_dbg();
#endif
  printf("Hello, World\n");
}
