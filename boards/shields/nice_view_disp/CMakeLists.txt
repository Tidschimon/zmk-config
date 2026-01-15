if(CONFIG_ZMK_DISPLAY AND CONFIG_NICE_VIEW_DISP_WIDGET_STATUS)
  # Use the committed commit_info.h file instead of generating it at build time
  # The file should be updated before committing using: 
  # HASH=$(git log -1 --format=%h); MSG=$(git log -1 --format=%s | cut -c1-14); 
  # LINE1=$(echo $MSG | cut -c1-7); LINE2=$(echo $MSG | cut -c8-14)
  
  zephyr_library_include_directories(${CMAKE_SOURCE_DIR}/include)
  zephyr_library_include_directories(${CMAKE_CURRENT_SOURCE_DIR})
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
