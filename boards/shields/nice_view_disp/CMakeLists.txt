if(CONFIG_ZMK_DISPLAY AND CONFIG_NICE_VIEW_DISP_WIDGET_STATUS)
  # Generate commit info header at build time
  execute_process(
    COMMAND git log -1 --format=%H --abbrev=7
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )
  
  execute_process(
    COMMAND git log -1 --format=%s
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_MSG
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )
  
  # Truncate commit message to 50 characters for display
  string(LENGTH "${GIT_COMMIT_MSG}" MSG_LENGTH)
  if(MSG_LENGTH GREATER 50)
    string(SUBSTRING "${GIT_COMMIT_MSG}" 0 50 GIT_COMMIT_MSG_SHORT)
  else()
    set(GIT_COMMIT_MSG_SHORT "${GIT_COMMIT_MSG}")
  endif()
  
  # Fallback values if git is not available
  if(NOT GIT_COMMIT_HASH)
    set(GIT_COMMIT_HASH "unknown")
  endif()
  
  if(NOT GIT_COMMIT_MSG_SHORT)
    set(GIT_COMMIT_MSG_SHORT "No commit message")
  endif()
  
  # Generate header file with commit info
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/widgets/commit_info.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/widgets/commit_info.h
    @ONLY
  )
  
  zephyr_library_include_directories(${CMAKE_SOURCE_DIR}/include)
  zephyr_library_include_directories(${CMAKE_CURRENT_BINARY_DIR})
  zephyr_library_sources(custom_status_screen.c)
  zephyr_library_sources(widgets/bolt.c)
  zephyr_library_sources(widgets/util.c)

  if(NOT CONFIG_ZMK_SPLIT OR CONFIG_ZMK_SPLIT_ROLE_CENTRAL)
    zephyr_library_sources(widgets/status.c)
  else()
    zephyr_library_sources(widgets/art.c)
    zephyr_library_sources(widgets/peripheral_status.c)
  endif()
endif()
