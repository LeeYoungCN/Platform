
set(PLATFORM_PATH           ${CMAKE_SOURCE_DIR}/Platform)
include_directories(${PLATFORM_PATH}/inc/public_func)
file(GLOB PUBLIC_LIBS ${PLATFORM_PATH}/lib/*.a)
target_link_libraries(${TARGET_NAME} ${PUBLIC_LIBS} pthread)