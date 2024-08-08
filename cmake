# docs
https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#target-properties

# cmake info
https://cliutils.gitlab.io/modern-cmake/chapters/features/cpp11.html

# cmake static binaries
#As global CMake settings, add these lines before add_executable:
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
SET(BUILD_SHARED_LIBS OFF)
SET(CMAKE_EXE_LINKER_FLAGS "-static")
#On Modern CMake (3.x+ - target_link_libraries doc), you can apply the flag to specific targets, in this way:
target_link_libraries(your_target_name -static)

# cmake -
mkd build
cd build
cmake ..
make

# fixing stupid flags
cd /usr/local/Cellar/cmake/3.29.2/share/cmake/Modules/
rg  fno-fat-lto-objects
vim Compiler/GNU.cmake
if(CMAKE_C_COMPILE_OPTIONS_IPO MATCHES "-fno-fat-lto-objects") then regex remove -fno-fat-lto-objects

# cmake - module load cmake/2.8.2

# cmake - change install dir
CC=gcc-4.6.1 CXX=g++-4.6.2 cmake -G "Your Generator" path/to/your/source
rm -r CMakeCache.txt CMakeFiles/;  mkdir Release ; BOOST_ROOT=/jgi/tools/misc_libraries/boost/1.42.0 cmake -DCMAKE_INSTALL_PREFIX=/home/copeland/local/x86_64/seqan -DCMAKE_BUILD_TYPE=Release
mkdir build; cd build; cmake ..; make

# compile targets in CMakeLists.txt
cmake -DCMAKE_INSTALL_PREFIX -DCMAKE_BUILD_TYPE (debug,release,..) -DCMAKE_BUILD_SHARED_LIBS=OFF

# gui
ccmake

# cmake find scripts e.g.
/house/groupdirs/QAQC/Packages/QCTools/ShortReads/Aligners/seqan/seqan-trunk/util/cmake/cuda/FindCUDA.cmake

# find package
find_package(<pkg> [PATHS ...] [REQUIRED])  # and when this of course fails then f*k around with
<pkg>_DIR
- where/how to add this?
- set(EIGEN_DIR "C:\\Eigendir\\Eigen")
CMAKE_PREFIX_PATH
- note this is outside of cmake files
- export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:/opt/eigen/3.3"
CMAKE_MODULE_PATH
- cmake . -DCMAKE_MODULE_PATH=<Eigen root dir>/cmake/
OR maybe include(simde)
- ???

# C/C++ standard
set_target_properties(<proj> PROPERTIES
    CXX_STANDARD 14
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE 1
)

# platform
* variables
CMAKE_SYSTEM_PROCESSOR
CMAKE_SYSTEM_VERSION
CMAKE_HOST_SYSTEM
CMAKE_HOST_SYSTEM_PROCESSOR
* detection in <proj>.cmake
if(APPLE)
  set(RUNTIME_IDENTIFIER osx-x64)
elseif(UNIX)
  set(RUNTIME_IDENTIFIER linux-x64)
...
* in CMakeLists.txt
if(GNULINUX_PLATFORM)
  AND (
    NOT (
      (CMAKE_SYSTEM_PROCESSOR MATCHES "^arm") OR (CMAKE_SYSTEM_PROCESSOR MATCHES "^aarch64")
    )
  )
)
* more CMakeListst.txt
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  message(STATUS "Configuring on/for Linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  message(STATUS "Configuring on/for macOS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  message(STATUS "Configuring on/for Windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "AIX")
  message(STATUS "Configuring on/for IBM AIX")
else()
  message(STATUS "Configuring on/for ${CMAKE_SYSTEM_NAME}")
endif()
* CMakeLists.txt
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  target_compile_definitions(hello-world PUBLIC "IS_LINUX")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  target_compile_definitions(hello-world PUBLIC "IS_MACOS")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  target_compile_definitions(hello-world PUBLIC "IS_WINDOWS")
endif()

# info
cmake --system-information

# compiler flags
Checking for compiler / platform features and adding appropriate CFLAGS
see https://learning.oreilly.com/library/view/cmake-cookbook/9781788470711/8bd8f9b8-263b-469f-ad4f-89b5d7090de8.xhtml
## works
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-march=native" USE_ARCH_NATIVE)
check_cxx_compiler_flag("-mbmi2" USE_BMI2)
check_cxx_compiler_flag("-mpopcnt" USE_POPCNT)
set(_CXX_FLAGS)
if(USE_ARCH_NATIVE)
  message(STATUS "Using vector instructions (-march=native compiler flag set)")
  set(_CXX_FLAGS "-march=native")
elseif(USE_BMI2)
  message(STATUS "Using vector instructions (-mbmi2 compiler flag set)")
  set(_CXX_FLAGS "-mbmi2 -DUSE_BMI2")
elseif(USE_POPCNT)
  message(STATUS "Using vector instructions (-mpopcnt compiler flag set)")
  set(_CXX_FLAGS "-mpopcnt")
else()
  message(STATUS "No vectorization flags added ")
endif()
set_target_properties(megahit_core PROPERTIES COMPILE_FLAGS ${_CXX_FLAGS})
set_target_properties(megahit_core_popcnt PROPERTIES COMPILE_FLAGS ${_CXX_FLAGS})

# compiler information
CMAKE_COMPILER_IS_GNUCXX
CMAKE_C_COMPILE_FEATURES
CMAKE_CXX_COMPILE_FEATURES
target_compile_features()


# processor information
cmake_host_system_information(RESULT _processor_name QUERY PROCESSOR_NAME)
cmake_host_system_information(RESULT _processor_description QUERY PROCESSOR_DESCRIPTION)

# os information
cmake_host_system_information(RESULT _os_name QUERY OS_NAME)
cmake_host_system_information(RESULT _os_release QUERY OS_RELEASE)
cmake_host_system_information(RESULT _os_version QUERY OS_VERSION)
cmake_host_system_information(RESULT _os_platform QUERY OS_PLATFORM)

# host system information
cmake_host_system_information(RESULT PRETTY_NAME QUERY DISTRIB_PRETTY_NAME)
message(STATUS "${PRETTY_NAME}")
cmake_host_system_information(RESULT DISTRO QUERY DISTRIB_INFO HAS_MMX HAS_SSE HAS_SSE2 PROCESSOR_NAME)
foreach(VAR IN LISTS DISTRO)
  message(STATUS "${VAR}=`${${VAR}}`")
endforeach()

# generators
cmake -G Ninja ..
cmake ..  # UNIX Makefile

# (moveme) cpu features
https://github.com/google/cpu_features.git
https://github.com/google/cpu_features/blob/main/cmake/README.md

# external project integration
# https://learning.oreilly.com/library/view/cmake-cookbook/9781788470711/c46675f3-f1ea-4b96-849c-4de7590b5838.xhtml
include(FetchContent) # cmake-3.11
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.8.0
)
FetchContent_GetProperties(googletest)
FetchContent_MakeAvailable(googletest) # cmake-3.14
if(NOT googletest_POPULATED)
  FetchContent_Populate(googletest)
  # ...
  # adds the targets: gtest, gtest_main, gmock, gmock_main
  add_subdirectory(
    ${googletest_SOURCE_DIR}
    ${googletest_BINARY_DIR}
    )
  # ...
endif()
add_executable(example example.cpp)
target_link_libraries(example gtest_main)
add_test(NAME example_test COMMAND example)

# env vars
CMAKE_C_COMPILER
CMAKE_CXX_COMPILER
