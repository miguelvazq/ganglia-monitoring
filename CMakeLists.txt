project (hpccsystems-ganglia-monitoring)
cmake_minimum_required (VERSION 2.8.3)

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
    ELSEIF ( ${packageManagement} STREQUAL "RPM" )
        SET(CPACK_PACKAGE_FILE_NAME     "${CMAKE_PROJECT_NAME}-${version}-${stagever}.${packageRevisionArch}")
    ELSE()
        SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${version}-${stagever}${CPACK_SYSTEM_NAME}")
    ENDIF ()

ENDIF ( CMAKE_SYSTEM_NAME MATCHES Linux )

MESSAGE ("-- Current release version is ${CPACK_PACKAGE_FILE_NAME}")

SET ( CPACK_SOURCE_GENERATOR TGZ )

IF (NOT "${CMAKE_VERSION}" VERSION_LESS "2.8.1")
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
            SET ( CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_CURRENT_BINARY_DIR}/postinst" )
            SET ( CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE "${CMAKE_CURRENT_BINARY_DIR}/prerm" )
            SET ( CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "${CMAKE_CURRENT_BINARY_DIR}/postrm" )
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
		INSTALL( FILES "${CMAKE_CURRENT_SOURCE_DIR}/test.inc" DESTINATION /myspecial/yourspecialfiles )
		INCLUDE ( CPack )
	
ELSE()
    MESSAGE("WARNING: CMAKE 2.8.1 or later required to create RPMs from this project")
ENDIF()

