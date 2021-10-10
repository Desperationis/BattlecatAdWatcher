set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

cmake_minimum_required(VERSION 3.5)

project(ImageDec VERSION 1.0.0)

find_package(OpenCV REQUIRED)

add_executable(output) 

target_include_directories(output PUBLIC ${OpenCV_INCLUDE_DIRS})

target_sources(output 
		PUBLIC 
		main.cpp
		)

target_link_libraries(output ${OpenCV_LIBS})
