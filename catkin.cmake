# http://ros.org/doc/hydro/api/catkin/html/user_guide/supposed.html
cmake_minimum_required(VERSION 2.8.3)
project(choroenoid)

find_package(catkin REQUIRED)

# catkin_package(DEPENDS eigen)

execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR} # go to build/rtm-ros-robotics/choreonoid
    make -f ${PROJECT_SOURCE_DIR}/Makefile.choreonoid # PROJECT_SOURCE_DIR=src/rtm-ros-robotics/choreonoid
    INSTALL_DIR=${CATKIN_DEVEL_PREFIX} # CATKIN_DEVEL_PREFIX=devel/bin (for making choreonoid in devel/bin)
    MK_DIR=${mk_PREFIX}/share/mk
    PATCH_DIR=${PROJECT_SOURCE_DIR}
    installed.choreonoid
    RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Failed to build choreonoid: ${_make_failed}")
endif(_make_failed)

# move binary
# bin -> {source}/bin
if(NOT EXISTS ${PROJECT_SOURCE_DIR}/bin/)
  execute_process(
    COMMAND cmake -E make_directory ${PROJECT_SOURCE_DIR}/bin/
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "make_directory ${PROJECT_SOURCE_DIR}/bin/ failed: ${_make_failed}")
  endif(_make_failed)
endif()

if(EXISTS ${CATKIN_DEVEL_PREFIX}/bin/choreonoid)
  execute_process(
    COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/bin/choreonoid ${PROJECT_SOURCE_DIR}/bin/choreonoid
    RESULT_VARIABLE _rename_failed)
  message("move library files ${PROJECT_SOURCE_DIR}/bin/choreonoid")
endif()
if (_rename_failed)
  message(FATAL_ERROR "Move hrpsys/bin failed: ${_rename_failed}")
endif(_rename_failed)



  