//
//  main.m
//  simforge
//
//  Created by Ethan Arbuckle on 1/16/25.
//

#import <Foundation/Foundation.h>
#import "platform_changer.h"
#import "tmpfs_overlay.h"
#import "simctl.h"

void printUsage(void) {
    printf(
           "Usage: simforge <command> [options]\n"
           "\n"
           "Commands:\n"
           "  convert     Add Simulator support to iOS arm64 mach-o binaries\n"
           "  launch      Launch app in Simulator with dylib injection\n"
           "  makerw      Create a read-write overlay of a directory\n"
           "\n"
           "Convert:\n"
           "  simforge convert <path>    Convert iOS app/dylib for simulator (breaks codesig)\n"
           "\n"
           "Launch:\n"
           "  simforge launch --bundleid <id> --dylib <path>\n"
           "\n"
           "Make Read-Write:\n"
           "  simforge makerw <path>     Create RW overlay of directory while retaining contents\n"
           "\n"
           "Examples:\n"
           "  simforge convert /path/to/MyApp.app\n"
           "  simforge convert /path/to/tweak.dylib\n"
           "  simforge launch --bundleid com.example.app --dylib /path/to/tweak.dylib\n"
           "  simforge makerw /path/in/simruntime\n"
           );
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            printUsage();
            return 1;
        }
        
        NSString *command = [NSString stringWithUTF8String:argv[1]];
        if ([command isEqualToString:@"launch"]) {
            NSString *launchBundleId = nil;
            NSString *launchDylibPath = nil;
            
            for (int i = 2; i < argc - 1; i++) {
                NSString *arg = [NSString stringWithUTF8String:argv[i]];
                
                if ([arg isEqualToString:@"--bundleid"]) {
                    launchBundleId = [NSString stringWithUTF8String:argv[i + 1]];
                }
                else if ([arg isEqualToString:@"--dylib"]) {
                    launchDylibPath = [NSString stringWithUTF8String:argv[i + 1]];
                }
            }
            
            if (!launchBundleId || !launchDylibPath) {
                NSLog(@"Error: Missing --bundleid or --dylib");
                printUsage();
                return 1;
            }
            
            BOOL success = launchAppOnAnyBootedSimulatorWithDylibs(launchBundleId, @[launchDylibPath]);
            return success ? 0 : 1;
        }
        else if ([command isEqualToString:@"convert"]) {
            if (argc < 3) {
                NSLog(@"Error: Missing path argument for convert command");
                printUsage();
                return 1;
            }
            
            NSLog(@"Converting: %s", argv[2]);
            convertPlatformToSimulator(argv[2]);
        }
        else if ([command isEqualToString:@"makerw"]) {
            if (argc < 3) {
                NSLog(@"Error: Missing path argument for makerw command");
                printUsage();
                return 1;
            }
            
            NSString *path = [NSString stringWithUTF8String:argv[2]];
            makeDirInSimRuntimeReadWrite(path);
        }
        else {
            NSLog(@"Error: Unknown command '%@'", command);
            printUsage();
            return 1;
        }
    }
    return 0;
}
