package("opengl")

    set_homepage("https://opengl.org/")
    set_description("OpenGL - The Industry Standard for High Performance Graphics")

    on_fetch(function (package, opt)
        -- we always get it from compiler toolchain
        if package:is_plat("macosx") then
            return {frameworks = "OpenGL", defines = "GL_SILENCE_DEPRECATION"}
        elseif package:is_plat("windows", "mingw") then
            return {links = "opengl32"}
        end
        if opt.system then
            if package:is_plat("linux") and package.find_package then
                return package:find_package("opengl", opt) or package:find_package("libgl", opt)
            end
        end
    end)
package_end()

set_languages("c++17")

includes("extlibs/openal.lua")
includes("extlibs/shaderc.lua")

if not is_plat("iphoneos", "harmony", "android") then
    includes("extlibs/glfw.lua")
end

add_requires("yoga", "stb", "harfbuzz", "freetype", "glm", "bullet3", "xxhash", "opengl-headers", "vulkan-headers", { system = false })
if is_plat("macosx", "iphoneos") then
    add_requires("moltenvk", { system = false })
end
if not is_plat("harmony", "android", "iphoneos") then
    add_requires("opengl")
end

target("openminecraft")
set_kind("binary")
add_files("src/external/placeholder.cpp")
add_packages("harfbuzz", "freetype", "glm", "bullet3", "openal-soft-mod", "yoga", "stb", "xxhash", "opengl-headers", "vulkan-headers")
if not is_plat("iphoneos", "harmony", "android") then
    add_packages("glfw-mod", "opengl")
end
if is_plat("macosx", "iphoneos") then
    add_packages("moltenvk")
end
shaderc_source()
