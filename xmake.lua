set_languages("c++17")

includes("extlibs/openal.lua")
includes("extlibs/shaderc.lua")

if not is_plat("iphoneos", "harmony", "android") then
    includes("extlibs/glfw.lua")
end

add_requires("yoga", "stb", "harfbuzz", "freetype", "glm", "bullet3", "xxhash", { system = false })

target("openminecraft")
set_kind("binary")
add_files("src/external/placeholder.cpp")
add_packages("glfw-mod", "harfbuzz", "freetype", "glm", "bullet3", "openal-soft-mod", "yoga", "stb", "xxhash")
shaderc_source()
