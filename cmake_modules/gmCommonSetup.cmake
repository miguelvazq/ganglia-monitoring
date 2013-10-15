##############################################################################
#
#    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
##############################################################################

IF ("${COMMONSETUP_DONE}" STREQUAL "")
  SET (COMMONSETUP_DONE 1)

  MACRO (MACRO_ENSURE_OUT_OF_SOURCE_BUILD _errorMessage)
    STRING(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" insource)
    IF (insource)
      MESSAGE(FATAL_ERROR "${_errorMessage}")
    ENDIF(insource)
  ENDMACRO (MACRO_ENSURE_OUT_OF_SOURCE_BUILD)

  macro_ensure_out_of_source_build("ganglia monitoring for HPCC  requires an out of source build.
    Please remove the directory ${CMAKE_BINARY_DIR}/CMakeFiles 
    and the file ${CMAKE_BINARY_DIR}/CMakeCache.txt,
    then create a separate build directory and run 'cmake path_to_source [options]' there.")

  cmake_policy ( SET CMP0011 NEW )

  option(USE_NATIVE_LIBRARIES "Search standard OS locations for thirdparty libraries" ON)
  option(USE_GIT_DESCRIBE "Use git describe to generate build tag" ON)

  if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set ( CMAKE_BUILD_TYPE "Release" )
  elseif (NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug|Release")
    message (FATAL_ERROR "Unknown build type $ENV{CMAKE_BUILD_TYPE}")
  endif ()
  message ("-- Making ${CMAKE_BUILD_TYPE} system")

  # Build tag generation

  set(majorver ${HPCC_MAJOR})
  set(minorver ${HPCC_MINOR})
  set(point ${HPCC_POINT})
  if ( "${HPCC_MATURITY}" STREQUAL "release" )
    set(stagever "${HPCC_SEQUENCE}")
  else()
    set(stagever "${HPCC_MATURITY}${HPCC_SEQUENCE}")
  endif()
  set(version ${majorver}.${minorver}.${point})

  IF ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set( stagever "${stagever}Debug" )
  ENDIF ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")

  ###########################################################################



endif()
