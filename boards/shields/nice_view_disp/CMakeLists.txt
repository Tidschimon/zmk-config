if(CONFIG_ZMK_DISPLAY AND CONFIG_NICE_VIEW_DISP_WIDGET_STATUS)
  # Generate commit info header at build time
  # Try to find the zmk-config repository root
  # First try: Use GITHUB_WORKSPACE environment variable (set during GitHub Actions build)
  set(CONFIG_REPO_ROOT "$ENV{GITHUB_WORKSPACE}")
  
  # Second try: If GITHUB_WORKSPACE is empty, use relative path (3 levels up from this CMakeLists.txt)
  if(NOT CONFIG_REPO_ROOT)
    get_filename_component(CONFIG_REPO_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
  endif()
  
  execute_process(
    COMMAND git log -1 --format=%h
    WORKING_DIRECTORY ${CONFIG_REPO_ROOT}
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )
  
  execute_process(
    COMMAND git log -1 --format=%s
    WORKING_DIRECTORY ${CONFIG_REPO_ROOT}
    OUTPUT_VARIABLE GIT_COMMIT_MSG
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )
  
  # Truncate commit message to 14 characters for display (2 lines of 7 chars)
  string(LENGTH "${GIT_COMMIT_MSG}" MSG_LENGTH)
  if(MSG_LENGTH GREATER 14)
    string(SUBSTRING "${GIT_COMMIT_MSG}" 0 14 GIT_COMMIT_MSG_FULL)
  else()
    set(GIT_COMMIT_MSG_FULL "${GIT_COMMIT_MSG}")
  endif()
  
  # Split into two lines
  string(LENGTH "${GIT_COMMIT_MSG_FULL}" MSG_FULL_LENGTH)
  if(MSG_FULL_LENGTH GREATER 7)
    string(SUBSTRING "${GIT_COMMIT_MSG_FULL}" 0 7 GIT_COMMIT_MSG_LINE1)
    math(EXPR REMAINING_LENGTH "${MSG_FULL_LENGTH} - 7")
    if(REMAINING_LENGTH GREATER 7)
      set(REMAINING_LENGTH 7)
    endif()
    string(SUBSTRING "${GIT_COMMIT_MSG_FULL}" 7 ${REMAINING_LENGTH} GIT_COMMIT_MSG_LINE2)
  else()
    set(GIT_COMMIT_MSG_LINE1 "${GIT_COMMIT_MSG_FULL}")
    set(GIT_COMMIT_MSG_LINE2 "")
  endif()
  
  # Fallback values if git is not available
  if(NOT GIT_COMMIT_HASH)
    set(GIT_COMMIT_HASH "unknown")
  endif()
  
  if(NOT GIT_COMMIT_MSG_LINE1)
    set(GIT_COMMIT_MSG_LINE1 "No commit")
  endif()
  
  if(NOT GIT_COMMIT_MSG_LINE2)
    set(GIT_COMMIT_MSG_LINE2 "message")
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
