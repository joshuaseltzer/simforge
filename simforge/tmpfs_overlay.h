//
//  tmpfs_overlay.h
//  simforge
//
//  Created by Ethan Arbuckle on 1/31/25.
//

#include <Foundation/Foundation.h>


/**
 * @brief Gets the path to the booted simulator's runtime
 * @return The path to the booted simulator's runtime
 */
NSString *getBootedSimRuntimeRootPath(void);

/**
 * @brief Mounts a tmpfs overlay over the given path
 * @param pathInSimRuntime The path to mount the overlay over
 * @return 0 on success, -1 on failure
 */
kern_return_t makeDirInSimRuntimeReadWrite(NSString *pathInSimRuntime);
