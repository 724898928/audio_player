cmake_minimum_required(VERSION 3.10)

# # 项目名称
set(PROJECT_NAME "mingw64")
project(${PROJECT_NAME} LANGUAGES CXX)

# # 源文件
# add_library(${PROJECT_NAME} SHARED
#     "./native_add.cpp"
# )

# 动态库的输出目录
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:DEBUG>:Debug>$<$<CONFIG:RELEASE>:Release>")
# 安装动态库的目标目录
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")
# 安装动态库，到执行目录
install(FILES "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${PROJECT_NAME}.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)