# http://ros.org/doc/hydro/api/catkin/html/user_guide/supposed.html
cmake_minimum_required(VERSION 2.8.3)
project(choreonoid)

find_package(catkin REQUIRED COMPONENTS mk)

# include(FindPkgConfig)
find_package(PkgConfig)

# catkin_package(DEPENDS eigen)
pkg_check_modules(eigen3 eigen3 REQUIRED)

# define choreonoid version to be installed 
if(NOT CNOID_MAJOR_VER)
	# set(CNOID_VER "1.4.0" CACHE STRING "choreonoid version to be installed" FORCE)
	set(CNOID_MAJOR_VER 1) 
	set(CNOID_MINOR_VER 5)
	set(CNOID_PATCH_VER 0)
endif()

execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR} # go to build/rtm-ros-robotics/choreonoid
    make -f ${PROJECT_SOURCE_DIR}/Makefile.choreonoid # PROJECT_SOURCE_DIR=src/rtm-ros-robotics/choreonoid
    INSTALL_DIR=${CMAKE_INSTALL_PREFIX} # CMAKE_INSTALL_PREFIX=devel (for making choreonoid(binary) in devel/bin)
    MK_DIR=${mk_PREFIX}/share/mk # /opt/ros/hydro/share/mk
    PATCH_DIR=${PROJECT_SOURCE_DIR}
		CNOID_VER=${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}.${CNOID_PATCH_VER}
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
if(EXISTS ${CMAKE_INSTALL_PREFIX}/bin/choreonoid)
  execute_process(
    COMMAND cmake -E copy ${CMAKE_INSTALL_PREFIX}/bin/choreonoid ${PROJECT_SOURCE_DIR}/bin/choreonoid
    RESULT_VARIABLE _copy_failed)
  message("copy binary files ${PROJECT_SOURCE_DIR}/bin/choreonoid")
endif()
if (_rename_failed)
  message(FATAL_ERROR "Copy hrpsys/bin failed: ${_rename_failed}")
endif(_rename_failed)

# move libraries
# lib -> {source}/lib
if(NOT EXISTS ${PROJECT_SOURCE_DIR}/lib/)
  execute_process(
    COMMAND cmake -E make_directory ${PROJECT_SOURCE_DIR}/lib/
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "make_directory ${PROJECT_SOURCE_DIR}/lib/ failed: ${_make_failed}")
  endif(_make_failed)
endif()

execute_process(
  COMMAND grep ${CMAKE_INSTALL_PREFIX}/lib/ ${CMAKE_CURRENT_BINARY_DIR}/build/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}.${CNOID_PATCH_VER}/install_manifest.txt
  OUTPUT_VARIABLE _lib_files
  RESULT_VARIABLE _grep_failed) # get path of installed lib files in choreonoid-* and preserve in _lib_files 
if (_grep_failed)
  message(FATAL_ERROR "grep : ${CMAKE_CURRENT_BINARY_DIR}/build/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}.${CNOID_PATCH_VER}/install_manifest.txt ${_grep_failed}")
endif(_grep_failed)
string(REGEX REPLACE "\n" ";" _lib_files ${_lib_files})
foreach(_lib_file ${_lib_files})
  get_filename_component(_lib_file_name ${_lib_file} NAME) # get filename (without path)
  if ("${_lib_file}" MATCHES "lib/choreonoid*") # install libraries in lib/choreonoid-* 
    string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/lib/" "" _choreonoid_lib_file ${_lib_file}) # trim devel/rtm-ros-robotics/choreonoid/choreonoid-*/*.so -> choreonoid-*/*.so
    get_filename_component(_choreonoid_file_dir  ${_choreonoid_lib_file} PATH) # trim choreonid-*/*.so -> choreonoid-*
		execute_process(
      COMMAND cmake -E copy_directory ${CMAKE_INSTALL_PREFIX}/lib/${_choreonoid_file_dir} ${PROJECT_SOURCE_DIR}/lib/${_choreonoid_file_dir}
      RESULT_VARIABLE _copy_failed) # copy devel/rtm-ros-robotics/choreonoid/lib/choreonoid-* to src/rtm-ros-robotics/choreonoid
  elseif ("${_lib_file_name}" MATCHES "libCnoid.*so") # install lib/libCnoid*.so
    execute_process(
      COMMAND cmake -E copy ${CMAKE_INSTALL_PREFIX}/lib/${_lib_file_name} ${PROJECT_SOURCE_DIR}/lib/${_lib_file_name}
      RESULT_VARIABLE _copy_failed) # copy devel/rtm-ros-robotics/choreonoid/lib/libCnoid* to src/rtm-ros-robotics/choreonoid
  endif()
endforeach()

# # for balancer plugin library
# if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # check ARCHITECTURE
# 	set( ARCH_VAL x64 )
# elseif( CMAKE_SIZEOF_VOID_P EQUAL 4 )
# 	set( ARCH_VAL x86 )
# else()
# 	message(FATAL_ERROR "We can build on only Linux(32bit or 64bit)")
# endif()
# execute_process(
# 	COMMAND cmake -E copy ${CMAKE_CURRENT_BINARY_DIR}/build/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}.${CNOID_PATCH_VER}/proprietary/BalancerPlugin/libCnoidBalancerPlugin.${ARCH_VAL}.so ${PROJECT_SOURCE_DIR}/lib/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}/libCnoidBalancerPlugin.so
# 	RESULT_VARIABLE _balancer_library_copy_failed)
# execute_process(
# 	COMMAND cmake -E copy ${CMAKE_CURRENT_BINARY_DIR}/build/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}.${CNOID_PATCH_VER}/proprietary/BalancerPlugin/libCnoidBalancerPlugin.${ARCH_VAL}.so ${CMAKE_INSTALL_PREFIX}/lib/choreonoid-${CNOID_MAJOR_VER}.${CNOID_MINOR_VER}/libCnoidBalancerPlugin.so
# 	RESULT_VARIABLE _balancer_library_copy_failed)
# if(_balancer_library_copy_failed)
# 	message(FATAL_ERROR "Copy libCnoidBlancer.so failed: ${_balancer_library_copy_failed}")
# endif(_balancer_library_copy_failed)