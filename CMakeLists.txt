
cmake_minimum_required(VERSION 2.8.9)

cmake_policy(SET CMP0048 NEW)


#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" 
                       ${CMAKE_CURRENT_SOURCE_DIR}/CMake/CTK-CMake
					   ${CMAKE_MODULE_PATH})


#-----------------------------------------------------------------------------
if(NOT DEFINED SRPlan_VERSION_MAJOR)
  set(SRPlan_VERSION_MAJOR "1")
endif()
if(NOT DEFINED SRPlan_VERSION_MINOR)
  set(SRPlan_VERSION_MINOR "0")
endif()
if(NOT DEFINED SRPlan_VERSION_PATCH)
  set(SRPlan_VERSION_PATCH "0")
endif()
if(POLICY CMP0048)
  set(_project_version VERSION "${SRPlan_VERSION_MAJOR}.${SRPlan_VERSION_MINOR}.${SRPlan_VERSION_PATCH}")
endif()
project(SRPlan ${_project_version})

set(SRPlan_BINARY_INNER_SUBDIR SRPlan-build)
#-----------------------------------------------------------------------------
# Sanity checks
#------------------------------------------------------------------------------
if(WIN32)
  set(${PROJECT_NAME}_ROOT_DIR_MAX_LENGTH 40)
  if(NOT ${PROJECT_NAME}_SUPERBUILD)
    string(LENGTH ${SRPlan_BINARY_INNER_SUBDIR} _inner_subdir_length)
    math(EXPR ${PROJECT_NAME}_ROOT_DIR_MAX_LENGTH "${${PROJECT_NAME}_ROOT_DIR_MAX_LENGTH} + ${_inner_subdir_length}")
  endif()
  include(PreventDirWithTooManyChars)
endif()
include(PreventInSourceBuilds)
include(PreventInBuildInstalls)
include(PreventDirWithSpaces)



#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#-----------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Debug' as none was specified.")
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
  mark_as_advanced(CMAKE_BUILD_TYPE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

#-----------------------------------------------------------------------------
# Set the header template which defines custom export/import macros
# for shared libraries
#-----------------------------------------------------------------------------
set(SRPlan_EXPORT_HEADER_TEMPLATE "${SRPlan_SOURCE_DIR}/CMake/qSRPlanExport.h.in")
set(SRPlan_LOGOS_RESOURCE "${SRPlan_SOURCE_DIR}/Resources/qSRPlan.qrc")

#-----------------------------------------------------------------------------
# Platform checks
#-----------------------------------------------------------------------------
include(SRPlanBlockPlatformCheck)

#-----------------------------------------------------------------------------
# Determine endian type
#-----------------------------------------------------------------------------
include(TestBigEndian)
test_big_endian(CMAKE_WORDS_BIGENDIAN)





#-----------------------------------------------------------------------------
# General SRPlan Options
#-----------------------------------------------------------------------------
include(CMakeDependentOption)



option(SRPlan_BUILD_DICOM_SUPPORT "Build SRPlan with DICOM support" ON)



#-----------------------------------------------------------------------------
# Dependence Libs
#-----------------------------------------------------------------------------

include(SRPlanQtSetup)

include(SRPlanVTKSetup)


include(SRPlanCTKSetup)
#-----------------------------------------------------------------------------
# Subdirectories
#-----------------------------------------------------------------------------

add_subdirectory(Libs)
#add_subdirectory(Base)
#add_subdirectory(Resources)

