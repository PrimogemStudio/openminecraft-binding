set_languages("c++17")

includes("extlibs/openal.lua")
includes("extlibs/shaderc.lua")

if not is_plat("iphoneos", "harmony", "android") then
    includes("extlibs/glfw.lua")
end

add_requires("yoga", "stb", "harfbuzz", "freetype", "glm", "bullet3", "xxhash", "opengl", "opengl-headers", "vulkan-headers", { system = false })
if is_plat("macosx", "iphoneos") then
    add_requires("moltenvk", { system = false })
end

target("openminecraft")
set_kind("binary")
add_files("src/external/placeholder.cpp")
add_packages("harfbuzz", "freetype", "glm", "bullet3", "openal-soft-mod", "yoga", "stb", "xxhash", "opengl", "opengl-headers", "vulkan-headers")
if not is_plat("iphoneos", "harmony", "android") then
    add_packages("glfw-mod")
end
if is_plat("macosx", "iphoneos") then
    add_packages("moltenvk")
end
shaderc_source()
