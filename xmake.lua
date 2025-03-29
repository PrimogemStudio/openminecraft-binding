set_languages("c++17")

-- includes("extlibs/openal.lua")
includes("extlibs/shaderc.lua")

if not is_plat("iphoneos", "harmony", "android") then
    includes("extlibs/glfw.lua")
end

add_requires("yoga", "stb", "harfbuzz", "freetype", "glm", "bullet3", "xxhash", "meshoptimizer", "openal-soft", { system = false })

target("openminecraft")
set_kind("binary")
add_files("src/external/placeholder.cpp")
add_packages("harfbuzz", "freetype", "glm", "bullet3", "openal-soft", "yoga", "stb", "xxhash", "meshoptimizer")
if not is_plat("iphoneos", "harmony", "android") then
    add_packages("glfw-mod")
end
shaderc_source()
