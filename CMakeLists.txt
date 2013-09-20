project (hpccsystems-ganglia-monitoring)
cmake_minimum_required (VERSION 2.8.2)

set (HPCC_GM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set (CMAKE_MODULE_PATH "${HPCC_GM_SOURCE_DIR}/cmake_modules/")

###
## Build Level
###
if( NOT BUILD_LEVEL )
    set ( BUILD_LEVEL "COMMUNITY" )
endif()
###

option(EXEC_PREFIX "Set the execution prefix")

if (NOT LICENSE_FILE)
    set (LICENSE_FILE "LICENSE.txt")
endif()

include (${HPCC_GM_SOURCE_DIR}/cmake_modules/gmCommonSetup.cmake)

set (CPACK_PACKAGE_CONTACT "HPCCSystems <ossdevelopment@lexisnexis.com>")
set (CPACK_SOURCE_GENERATOR TGZ )
set (CPACK_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}-${CPACK_RPM_PACKAGE_ARCHITECTURE}")

IF ( CMAKE_SYSTEM_NAME MATCHES Linux )
    EXECUTE_PROCESS (
                COMMAND ${CMAKE_MODULE_PATH}/distrocheck.sh
                    OUTPUT_VARIABLE packageManagement
                        ERROR_VARIABLE  packageManagement
                )
    EXECUTE_PROCESS (
                COMMAND ${CMAKE_MODULE_PATH}/getpackagerevisionarch.sh
                    OUTPUT_VARIABLE packageRevisionArch
                        ERROR_VARIABLE  packageRevisionArch
                )
    EXECUTE_PROCESS (
                COMMAND ${CMAKE_MODULE_PATH}/getpackagerevisionarch.sh --noarch
                    OUTPUT_VARIABLE packageRevision
                        ERROR_VARIABLE  packageRevision
                )

    MESSAGE ( "-- Auto Detecting Packaging type")
    MESSAGE ( "-- distro uses ${packageManagement}, revision is ${packageRevisionArch}" )

    IF ( ${packageManagement} STREQUAL "DEB" )
        SET(CPACK_PACKAGE_FILE_NAME     "${CMAKE_PROJECT_NAME}-${version}-${stagever}${packageRevisionArch}")
        SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} /usr/lib)
    ELSEIF ( ${packageManagement} STREQUAL "RPM" )
        SET(CPACK_PACKAGE_FILE_NAME     "${CMAKE_PROJECT_NAME}-${version}-${stagever}.${packageRevisionArch}")
        SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} usr/lib64)
    ELSE()
        SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${version}-${stagever}${CPACK_SYSTEM_NAME}")
    ENDIF ()

ENDIF ( CMAKE_SYSTEM_NAME MATCHES Linux )

#MESSAGE ("-- Current release version is ${CPACK_PACKAGE_FILE_NAME}")
#MESSAGE( STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )
#MESSAGE( STATUS "CMAKE_SOURCE_DIR: " ${CMAKE_SOURCE_DIR} )
#MESSAGE( STATUS "CMAKE_LIBRARY_PATH: "${CMAKE_LIBRARY_PATH} )

# ------------------------- Begin Generic CMake Variable Logging ------------------

# /*	C++ comment style not allowed	*/


# if you are building in-source, this is the same as CMAKE_SOURCE_DIR, otherwise 
# this is the top level directory of your build tree 
MESSAGE( STATUS "CMAKE_BINARY_DIR:         " ${CMAKE_BINARY_DIR} )

# if you are building in-source, this is the same as CMAKE_CURRENT_SOURCE_DIR, otherwise this 
# is the directory where the compiled or generated files from the current CMakeLists.txt will go to 
MESSAGE( STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )

# this is the directory, from which cmake was started, i.e. the top level source directory 
MESSAGE( STATUS "CMAKE_SOURCE_DIR:         " ${CMAKE_SOURCE_DIR} )

# this is the directory where the currently processed CMakeLists.txt is located in 
MESSAGE( STATUS "CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR} )

# contains the full path to the top level directory of your build tree 
MESSAGE( STATUS "PROJECT_BINARY_DIR: " ${PROJECT_BINARY_DIR} )

# contains the full path to the root of your project source directory,
# i.e. to the nearest directory where CMakeLists.txt contains the PROJECT() command 
MESSAGE( STATUS "PROJECT_SOURCE_DIR: " ${PROJECT_SOURCE_DIR} )

# set this variable to specify a common place where CMake should put all executable files
# (instead of CMAKE_CURRENT_BINARY_DIR)
MESSAGE( STATUS "EXECUTABLE_OUTPUT_PATH: " ${EXECUTABLE_OUTPUT_PATH} )

# set this variable to specify a common place where CMake should put all libraries 
# (instead of CMAKE_CURRENT_BINARY_DIR)
MESSAGE( STATUS "LIBRARY_OUTPUT_PATH:     " ${LIBRARY_OUTPUT_PATH} )

# tell CMake to search first in directories listed in CMAKE_MODULE_PATH
# when you use FIND_PACKAGE() or INCLUDE()
MESSAGE( STATUS "CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH} )

# this is the complete path of the cmake which runs currently (e.g. /usr/local/bin/cmake) 
MESSAGE( STATUS "CMAKE_COMMAND: " ${CMAKE_COMMAND} )

# this is the CMake installation directory 
MESSAGE( STATUS "CMAKE_ROOT: " ${CMAKE_ROOT} )

# this is the filename including the complete path of the file where this variable is used. 
MESSAGE( STATUS "CMAKE_CURRENT_LIST_FILE: " ${CMAKE_CURRENT_LIST_FILE} )

# this is linenumber where the variable is used
MESSAGE( STATUS "CMAKE_CURRENT_LIST_LINE: " ${CMAKE_CURRENT_LIST_LINE} )

# this is used when searching for include files e.g. using the FIND_PATH() command.
MESSAGE( STATUS "CMAKE_INCLUDE_PATH: " ${CMAKE_INCLUDE_PATH} )

# this is used when searching for libraries e.g. using the FIND_LIBRARY() command.
MESSAGE( STATUS "CMAKE_LIBRARY_PATH: " ${CMAKE_LIBRARY_PATH} )

# the complete system name, e.g. "Linux-2.4.22", "FreeBSD-5.4-RELEASE" or "Windows 5.1" 
MESSAGE( STATUS "CMAKE_SYSTEM: " ${CMAKE_SYSTEM} )

# the short system name, e.g. "Linux", "FreeBSD" or "Windows"
MESSAGE( STATUS "CMAKE_SYSTEM_NAME: " ${CMAKE_SYSTEM_NAME} )

# only the version part of CMAKE_SYSTEM 
MESSAGE( STATUS "CMAKE_SYSTEM_VERSION: " ${CMAKE_SYSTEM_VERSION} )

# the processor name (e.g. "Intel(R) Pentium(R) M processor 2.00GHz") 
MESSAGE( STATUS "CMAKE_SYSTEM_PROCESSOR: " ${CMAKE_SYSTEM_PROCESSOR} )

# is TRUE on all UNIX-like OS's, including Apple OS X and CygWin
MESSAGE( STATUS "UNIX: " ${UNIX} )

# is TRUE on Windows, including CygWin 
MESSAGE( STATUS "WIN32: " ${WIN32} )

# is TRUE on Apple OS X
MESSAGE( STATUS "APPLE: " ${APPLE} )

# is TRUE when using the MinGW compiler in Windows
MESSAGE( STATUS "MINGW: " ${MINGW} )

# is TRUE on Windows when using the CygWin version of cmake
MESSAGE( STATUS "CYGWIN: " ${CYGWIN} )

# is TRUE on Windows when using a Borland compiler 
MESSAGE( STATUS "BORLAND: " ${BORLAND} )

# Microsoft compiler 
MESSAGE( STATUS "MSVC: " ${MSVC} )
MESSAGE( STATUS "MSVC_IDE: " ${MSVC_IDE} )
MESSAGE( STATUS "MSVC60: " ${MSVC60} )
MESSAGE( STATUS "MSVC70: " ${MSVC70} )
MESSAGE( STATUS "MSVC71: " ${MSVC71} )
MESSAGE( STATUS "MSVC80: " ${MSVC80} )
MESSAGE( STATUS "CMAKE_COMPILER_2005: " ${CMAKE_COMPILER_2005} )


# set this to true if you don't want to rebuild the object files if the rules have changed, 
# but not the actual source files or headers (e.g. if you changed the some compiler switches) 
MESSAGE( STATUS "CMAKE_SKIP_RULE_DEPENDENCY: " ${CMAKE_SKIP_RULE_DEPENDENCY} )

# since CMake 2.1 the install rule depends on all, i.e. everything will be built before installing. 
# If you don't like this, set this one to true.
MESSAGE( STATUS "CMAKE_SKIP_INSTALL_ALL_DEPENDENCY: " ${CMAKE_SKIP_INSTALL_ALL_DEPENDENCY} )

# If set, runtime paths are not added when using shared libraries. Default it is set to OFF
MESSAGE( STATUS "CMAKE_SKIP_RPATH: " ${CMAKE_SKIP_RPATH} )

# set this to true if you are using makefiles and want to see the full compile and link 
# commands instead of only the shortened ones 
MESSAGE( STATUS "CMAKE_VERBOSE_MAKEFILE: " ${CMAKE_VERBOSE_MAKEFILE} )

# this will cause CMake to not put in the rules that re-run CMake. This might be useful if 
# you want to use the generated build files on another machine. 
MESSAGE( STATUS "CMAKE_SUPPRESS_REGENERATION: " ${CMAKE_SUPPRESS_REGENERATION} )


# A simple way to get switches to the compiler is to use ADD_DEFINITIONS(). 
# But there are also two variables exactly for this purpose: 

# the compiler flags for compiling C sources 
MESSAGE( STATUS "CMAKE_C_FLAGS: " ${CMAKE_C_FLAGS} )

# the compiler flags for compiling C++ sources 
MESSAGE( STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS} )


# Choose the type of build.  Example: SET(CMAKE_BUILD_TYPE Debug) 
MESSAGE( STATUS "CMAKE_BUILD_TYPE: " ${CMAKE_BUILD_TYPE} )

# if this is set to ON, then all libraries are built as shared libraries by default.
MESSAGE( STATUS "BUILD_SHARED_LIBS: " ${BUILD_SHARED_LIBS} )

# the compiler used for C files 
MESSAGE( STATUS "CMAKE_C_COMPILER: " ${CMAKE_C_COMPILER} )

# the compiler used for C++ files 
MESSAGE( STATUS "CMAKE_CXX_COMPILER: " ${CMAKE_CXX_COMPILER} )

# if the compiler is a variant of gcc, this should be set to 1 
MESSAGE( STATUS "CMAKE_COMPILER_IS_GNUCC: " ${CMAKE_COMPILER_IS_GNUCC} )

# if the compiler is a variant of g++, this should be set to 1 
MESSAGE( STATUS "CMAKE_COMPILER_IS_GNUCXX : " ${CMAKE_COMPILER_IS_GNUCXX} )

# the tools for creating libraries 
MESSAGE( STATUS "CMAKE_AR: " ${CMAKE_AR} )
MESSAGE( STATUS "CMAKE_RANLIB: " ${CMAKE_RANLIB} )

#
#MESSAGE( STATUS ": " ${} )

# ------------------------- End of Generic CMake Variable Logging ------------------

get_directory_property(OUT_VAR LINK_DIRECTORIES)
message(STATUS "DIR: ${OUT_VAR}")

get_property(LIB64 GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS) 

if ("${LIB64}" STREQUAL "TRUE") 
    set(LIBSUFFIX 64) 
else() 
    set(LIBSUFFIX "") 
endif() 

set(INSTALL_LIB_DIR  lib${LIBSUFFIX} CACHE PATH "Installation directory for libraries") 
mark_as_advanced(INSTALL_LIB_DIR) 
message( STATUS "INSTALL_LIB_DIR: ${INSTALL_LIB_DIR}" )

get_property(LIB64 GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS) 
message( STATUS "lib64: ${LIB64}" )

SET ( CPACK_SOURCE_GENERATOR TGZ )

IF (NOT "${CMAKE_VERSION}" VERSION_LESS "2.8.28.28.28.28.28.28.28.2")
    IF ( CMAKE_SYSTEM MATCHES Linux )
        IF ( ${packageManagement} STREQUAL "DEB" )
            IF ("${CMAKE_VERSION}" VERSION_EQUAL "2.8.2")
                MESSAGE("WARNING: CMAKE 2.8.2  would not build DEB package")
            ELSE ()
                SET ( CPACK_GENERATOR "${packageManagement}" )
                MESSAGE("-- Will build DEB package")
                ###
                ## CPack instruction required for Debian
                ###
                MESSAGE ("-- Packing BASH installation files")
#                SET ( CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_BINARY_DIR}/postinst;${CMAKE_CURRENT_BINARY_DIR}/prerm;${CMAKE_CURRENT_BINARY_DIR}/postrm" )
                SET ( CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_SOURCE_DIR}/postinst;${CMAKE_SOURCE_DIR}/prerm;${CMAKE_SOURCE_DIR}/postrm" )
            ENDIF ()

        ELSEIF ( ${packageManagement} STREQUAL "RPM" )
            SET ( CPACK_GENERATOR "${packageManagement}" )
            ###
            ## CPack instruction required for RPM
            ###
            MESSAGE("-- Will build RPM package")
            MESSAGE ("-- Packing BASH installation files")
            SET ( CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/postinst" )
            SET ( CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE "${CMAKE_SOURECE_DIR}/prerm" )
            SET ( CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/postrm" )
        ELSE()
            MESSAGE("WARNING: Unsupported package ${packageManagement}.")
        ENDIF ()

    ENDIF ( CMAKE_SYSTEM MATCHES Linux )
    IF ( EXISTS ${CMAKE_MODULE_PATH}/dependencies/${packageRevision}.cmake )
        INCLUDE( ${CMAKE_MODULE_PATH}/dependencies/${packageRevision}.cmake )
    ELSE()
         MESSAGE("-- WARNING: DEPENDENCY FILE FOR ${packageRevision} NOT FOUND")
#        MESSAGE("-- WARNING: DEPENDENCY FILE FOR ${packageRevision} NOT FOUND, Using deps template.")
#        INCLUDE( ${CMAKE_MODULE_PATH}/dependencies/template.cmake )
    ENDIF()

    IF ( UNIX )
     SET ( CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" )
    ENDIF()

 
    SET ( CPACK_MONOLITHIC_INSTALL TRUE )
		SET ( CPACK_PACKAGE_VENDOR "HPCC Systems" )
   
		#INSTALL ( FILES  

#		INSTALL( FILES "${CMAKE_CURRENT_SOURCE_DIR}/test.inc" DESTINATION include COMPONENT headers)

		INSTALL( FILES "${CMAKE_CURRENT_SOURCE_DIR}/modroxie.py" DESTINATION ${CMAKE_LIBRARY_PATH}/ganglia/python_modules  )
		INSTALL( FILES "${CMAKE_CURRENT_SOURCE_DIR}/modroxie.pyconf" DESTINATION etc/ganglia  )
		INCLUDE ( CPack )
	
ELSE()
    MESSAGE("WARNING: CMAKE 2.8.1 or later required to create RPMs from this project")
ENDIF()

