################################################################################
#
#  Program: 3D SRPlan
#
#  Copyright (c) Kitware Inc.
#
#  See COPYRIGHT.txt
#  or http://www.SRPlan.org/copyright/copyright.txt for details.
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#  This file was originally developed by Jean-Christophe Fillion-Robin, Kitware Inc.
#  and was partially funded by NIH grant 3P41RR013218-12S1
#
################################################################################

#
# The CMake code used to find Qt4 has been factored out into this CMake script so that
# it can be used in both SRPlan/CMakelists.txt and SRPlan/UseSRPlan.cmake
#

macro(__SRPlanBlockFindQtAndCheckVersion_find_qt)
  find_package(Qt4)
  if(NOT QT4_FOUND)
    message(FATAL_ERROR "error: Qt ${SRPlan_REQUIRED_QT_VERSION} was not found on your system."
                        "You probably need to set the QT_QMAKE_EXECUTABLE variable.")
  endif()

  # Check version
  if("${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" VERSION_LESS "${SRPlan_REQUIRED_QT_VERSION}")
    message(FATAL_ERROR "error: SRPlan requires at least Qt ${SRPlan_REQUIRED_QT_VERSION} "
                        "-- you cannot use Qt ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}. ${extra_error_message}")
  endif()

  set(command_separated_module_list)
  # Check if all expected Qt modules have been discovered
  foreach(module ${SRPlan_REQUIRED_QT_MODULES})
    if(NOT "${QT_${module}_FOUND}")
      message(FATAL_ERROR "error: Missing Qt module ${module}")
    endif()
    if(NOT ${module} STREQUAL "QTCORE" AND NOT ${module} STREQUAL "QTGUI")
      set(QT_USE_${module} ON)
    endif()
    set(command_separated_module_list "${command_separated_module_list}${module}, ")
  endforeach()
endmacro()

# Sanity checks - Check if variable are defined
set(expected_defined_vars
  SRPlan_REQUIRED_QT_VERSION
  SRPlan_REQUIRED_QT_MODULES
  )
foreach(v ${expected_defined_vars})
  if(NOT DEFINED ${v})
    message(FATAL_ERROR "error: ${v} CMake variable is not defined.")
  endif()
endforeach()

# Check QT_QMAKE_EXECUTABLE provided by VTK
set(extra_error_message)
if(DEFINED VTK_QT_QMAKE_EXECUTABLE)
  #message(STATUS "Checking VTK_QT_QMAKE_EXECUTABLE ...")
  if(NOT EXISTS "${VTK_QT_QMAKE_EXECUTABLE}")
    message(FATAL_ERROR "error: You should probably re-configure VTK. VTK_QT_QMAKE_EXECUTABLE points to a nonexistent executable: ${VTK_QT_QMAKE_EXECUTABLE}")
  endif()
  set(QT_QMAKE_EXECUTABLE ${VTK_QT_QMAKE_EXECUTABLE})
  set(extra_error_message "You should probably reconfigure VTK.")
  __SRPlanBlockFindQtAndCheckVersion_find_qt()
  set(qt_version_discovered_using_vtk "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
endif()

# Check QT_QMAKE_EXECUTABLE provided by CTK
if(DEFINED CTK_QT_QMAKE_EXECUTABLE)
  #message(STATUS "Checking CTK_QT_QMAKE_EXECUTABLE ...")
  if(NOT EXISTS "${CTK_QT_QMAKE_EXECUTABLE}")
    message(FATAL_ERROR "error: You should probably re-configure CTK. CTK_QT_QMAKE_EXECUTABLE points to a nonexistent executable: ${CTK_QT_QMAKE_EXECUTABLE}")
  endif()
  set(QT_QMAKE_EXECUTABLE ${CTK_QT_QMAKE_EXECUTABLE})
  set(extra_error_message "You should probably reconfigure VTK.")
  __SRPlanBlockFindQtAndCheckVersion_find_qt()
  set(qt_version_discovered_using_ctk "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
endif()

__SRPlanBlockFindQtAndCheckVersion_find_qt()

include(${QT_USE_FILE})

set(_project_name ${SRPlan_MAIN_PROJECT_APPLICATION_NAME})
if(NOT SRPlan_SOURCE_DIR)
  set(_project_name ${PROJECT_NAME})
endif()
message(STATUS "Configuring ${_project_name} with Qt ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH} (using modules: ${command_separated_module_list})")
