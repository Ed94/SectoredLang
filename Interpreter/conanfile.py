from conans import ConanFile, CMake


class MAS_Interpreter_Conan(ConanFile):
    name = "MAS_Interpreter"
    version = "0.1.0"
    settings = "os", "arch", "compiler", "build_type"
    
    
    # generators = "cmake_find_package"
    
    
    
    
    
    

#     def build(self):
#         cmake = CMake(self)                # CMake helper auto-formats CLI arguments for CMake
#         cmake.configure()                  # cmake -DCMAKE_TOOLCHAIN_FILE=conantoolchain.cmake
#         cmake.build()                      # cmake --build .  

         
#     def package(self):
#         cmake = CMake(self)                # For CMake projects which define an install target, leverage it
#         cmake.install()                    # cmake --build . --target=install 
# #                                            sets CMAKE_INSTALL_PREFIX = <appropriate directory in conan cache
   
#     # def requirements(self):

#     def export_sources(self):
#         self.copy("*.cpp")                 # -> copies all .cpp files from working dir to a "source" dir
#         self.copy("CMakeLists.txt")        # -> copies CMakeLists.txt from working dir to a "source" dir
        
#     def generate(self):
#         self.copy("project/*")
       
#     def package_info(self):
#         self.cpp_info.includedirs = ["include"]
#         self.cpp_info.libdirs = ["lib"]
#         self.cpp_info.libs = ["lib"]
