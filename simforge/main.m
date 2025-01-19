//
//  main.m
//  simforge
//
//  Created by Ethan Arbuckle on 1/16/25.
//

#import <Foundation/Foundation.h>
#import "platform_changer.h"
#import "simctl.h"

void printUsage(void) {
    printf(
           "Usage: simforge <command> [options]\n"
           "\n"
           "Commands:\n"
           "  convert   Add Simulator support to iOS arm64 mach-o binaries\n"
           "  launch    Launch app in Simulator with dylib injection\n"
           "\n"
           "Convert:\n"
           "  simforge convert <path>    Convert iOS app/dylib for simulator (breaks codesig)\n"
           "\n"
           "Launch:\n"
           "  simforge launch --bundleid <id> --dylib <path>\n"
           "\n"
           "Examples:\n"
           "  simforge convert /path/to/MyApp.app\n"
           "  simforge convert /path/to/tweak.dylib\n"
           "  simforge launch --bundleid com.example.app --dylib /path/to/tweak.dylib\n"
           );
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            printUsage();
            return 1;
        }
        
        if (strcmp(argv[1], "launch") == 0) {
            NSString *launchBundleId = nil;
            NSString *launchDylibPath = nil;
            for (int i = 2; i < argc; i++) {
                if (strcmp(argv[i], "--bundleid") == 0) {
                    launchBundleId = [NSString stringWithFormat:@"%s", argv[i + 1]];
                }
                else if (strcmp(argv[i], "--dylib") == 0) {
                    launchDylibPath = [NSString stringWithFormat:@"%s", argv[i + 1]];
                }
            }
            
            if (!launchBundleId || !launchDylibPath) {
                NSLog(@"Missing --bundleid or --dylib");
                return 1;
            }
            
            BOOL success = launchAppOnAnyBootedSimulatorWithDylibs(launchBundleId, @[launchDylibPath]);
            return success ? 0 : 1;
        }
        else if (strcmp(argv[1], "convert") == 0) {
            // If not launching, do a conversion
            NSLog(@"Converting: %s", argv[2]);
            convertPlatformToSimulator(argv[2]);
        }
        else {
            printUsage();
            return 1;
        }
    }
    return 0;
}
