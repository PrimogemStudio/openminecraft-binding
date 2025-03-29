package("spirv-tools-local")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "spirv-tools"))
    on_install(function (package)
        local configs = { 
            "-DSPIRV-Headers_SOURCE_DIR=" .. string.gsub(path.join(os.scriptdir(), "spirv-headers"), "\\", "/"), 
            "-DSPIRV_SKIP_TESTS=ON", 
            "-DSPIRV_WERROR=OFF", 
            "-DBUILD_SHARED_LIBS=OFF"
        }
        import("package.tools.cmake").install(package, configs)
        package:add("links", "SPIRV-Tools", "SPIRV-Tools-link", "SPIRV-Tools-reduce", "SPIRV-Tools-opt", "SPIRV-Tools-diff", "SPIRV-Tools-lint")
    end)
package_end()

package("glslang-local")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "glslang"))
    add_deps("spirv-tools-local")
    on_install(function (package)
        local configs = { "-DENABLE_OPT=1", "-DALLOW_EXTERNAL_SPIRV_TOOLS=OFF", "-DENABLE_HLSL=ON" }
        local pth = path.join(os.scriptdir(), "glslang/glslang/CMakeLists.txt")
        io.replace(pth, "message(\"unknown platform\")", "add_subdirectory(OSDependent/Unix)", { plain = true })
        local pth = path.join(os.scriptdir(), "glslang/StandAlone/CMakeLists.txt")
        if not is_plat("iphoneos", "macosx", "bsd") then
            io.replace(pth, "set(LIBRARIES ${LIBRARIES} pthread)", "set(LIBRARIES ${LIBRARIES} pthread atomic)", { plain = true })
        end
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

package("googletest-local")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "googletest"))
    on_install(function (package)
        local configs = {}
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

add_requires("glslang-local", "spirv-tools-local", "googletest-local", { configs = { shared = false } })

function shaderc_source()
add_packages("spirv-tools-local", "googletest-local")
if not is_plat("iphoneos") then
    add_packages("glslang-local")
end
add_includedirs("extlibs/spirv-headers/include")
add_includedirs("extlibs/glslang")

add_files("extlibs/shaderc/libshaderc/src/shaderc.cc")
add_includedirs("extlibs/shaderc/libshaderc/include")
add_includedirs("extlibs/shaderc/libshaderc/src")
add_files("extlibs/shaderc/libshaderc_util/src/*.cc")
add_includedirs("extlibs/shaderc/libshaderc_util/include")
add_defines("ENABLE_HLSL=1")
if is_plat("windows") then
    add_defines("WIN32")
end
add_files("extlibs/spirv-tools/source/util/timer.cpp")
add_files("extlibs/spirv-tools/source/util/bit_vector.cpp")
add_includedirs("extlibs/spirv-tools")
if not is_plat("windows") then
    add_defines("SPIRV_TIMER_ENABLED=1")
end
end
