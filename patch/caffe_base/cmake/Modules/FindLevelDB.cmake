# - Find LevelDB
#
#  LevelDB_INCLUDES  - List of LevelDB includes
#  LevelDB_LIBRARIES - List of libraries when using LevelDB.
#  LevelDB_FOUND     - True if LevelDB found.
# modified by guyadong

# Look for the header file.
find_path(LevelDB_INCLUDE NAMES leveldb/db.h
                          PATHS $ENV{LEVELDB_ROOT}/include 
                          DOC "Path in which the file leveldb/db.h is located." NO_DEFAULT_PATH)
find_path(LevelDB_INCLUDE NAMES leveldb/db.h
                          DOC "Path in which the file leveldb/db.h is located." )

# Look for the library.
find_library(LevelDB_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}leveldb${CMAKE_STATIC_LIBRARY_SUFFIX} leveldb
                             PATHS $ENV{LEVELDB_ROOT}/lib 
                             DOC "Path to leveldb library." NO_DEFAULT_PATH)
find_library(LevelDB_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}leveldb${CMAKE_STATIC_LIBRARY_SUFFIX} leveldb
                             DOC "Path to leveldb library." )
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LevelDB DEFAULT_MSG LevelDB_INCLUDE LevelDB_LIBRARY)

if(LEVELDB_FOUND)
  message(STATUS "Found LevelDB (include: ${LevelDB_INCLUDE}, library: ${LevelDB_LIBRARY})")
  # modified by guyadong,add boost libraries to LevelDB_LIBRARIES
  find_package(Boost COMPONENTS 
    date_time
    filesystem
    system
    REQUIRED)
  set(LevelDB_INCLUDES ${LevelDB_INCLUDE})
  set(LevelDB_LIBRARIES ${LevelDB_LIBRARY} ${Boost_LIBRARIES})
  mark_as_advanced(LevelDB_INCLUDE LevelDB_LIBRARY)

  if(EXISTS "${LevelDB_INCLUDE}/leveldb/db.h")
    file(STRINGS "${LevelDB_INCLUDE}/leveldb/db.h" __version_lines
           REGEX "static const int k[^V]+Version[ \t]+=[ \t]+[0-9]+;")

    foreach(__line ${__version_lines})
      if(__line MATCHES "[^k]+kMajorVersion[ \t]+=[ \t]+([0-9]+);")
        set(LEVELDB_VERSION_MAJOR ${CMAKE_MATCH_1})
      elseif(__line MATCHES "[^k]+kMinorVersion[ \t]+=[ \t]+([0-9]+);")
        set(LEVELDB_VERSION_MINOR ${CMAKE_MATCH_1})
      endif()
    endforeach()

    if(LEVELDB_VERSION_MAJOR AND LEVELDB_VERSION_MINOR)
      set(LEVELDB_VERSION "${LEVELDB_VERSION_MAJOR}.${LEVELDB_VERSION_MINOR}")
    endif()

    caffe_clear_vars(__line __version_lines)
  endif()
endif()
