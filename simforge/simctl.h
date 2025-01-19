//
//  simctl.h
//  simforge
//
//  Created by Ethan Arbuckle on 1/18/25.
//


/**
 * Returns an array of all installed simulator devices
 * @param onlyBooted If YES, only booted devices will be returned
 * @return An array of all installed simulator devices
 */
 NSArray *getSimulatorDevices(BOOL onlyBooted);

/**
 * Launches an already-installed app on a specific simulator with the specified dylibs loaded
 * @param simulatorUUID The UUID of a Booted simulator that has appBundleId installed
 * @param appBundleId The bundle ID of the installed app to launch
 * @param dylibPaths An array of paths to the dylibs to load
 * @return YES if the app was launched successfully, NO otherwise
 *
 * note Simulator support will be patched in if the app or dylib lacks it.
 * @note Unsigned binaries will be ad-hoc signed before being injected.
 * @note Dylibs are loaded using DYLD_INSERT_LIBRARIES.
 */
BOOL launchAppOnSimulatorWithDylibs(NSString *simulatorUUID, NSString *appBundleId, NSArray *dylibPaths);

/**
    * Launches an already-installed app on any booted simulator with the specified dylibs loaded
    * @param appBundleId The bundle ID of the installed app to launch
    * @param dylibPaths An array of paths to the dylibs to load
    * @return YES if the app was launched successfully, NO otherwise
    *
    * note Simulator support will be patched in if the app or dylib lacks it.
    * @note Unsigned binaries will be ad-hoc signed before being injected.
    * @note Dylibs are loaded using DYLD_INSERT_LIBRARIES.
    */
BOOL launchAppOnAnyBootedSimulatorWithDylibs(NSString *appBundleId, NSArray *dylibPaths);

/**
 Determines if a binary is an arm64 simulator-compatible binary
    @param binaryPath The path to the binary to check
    @return YES if the binary is arm64 simulator-compatible, NO otherwise
 */
BOOL isArm64SimulatorPlatform(NSString *binaryPath);
