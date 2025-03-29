set_languages("c++17")

includes("extlibs/freetype.lua")
includes("extlibs/openal.lua")
includes("extlibs/meshoptimizer.lua")
includes("extlibs/yoga.lua")
includes("extlibs/stb.lua")
includes("extlibs/xxhash.lua")
if not is_plat("bsd0") then
    includes("extlibs/shaderc.lua")
end

if not is_plat("iphoneos", "harmony", "android") then
    includes("extlibs/glfw.lua")
end

--add_requires("bullet3", "glm", { system = false })
--add_rules("mode.debug")
--add_rules("mode.release")

--function libmmd_source()
--    add_packages("bullet3", "glm")
--    add_files("src/libmmd/**.cpp")
--    add_includedirs("include")
--end

--target("mmd")
--set_kind("shared")
--libmmd_source()

--target("mmdtest")
--set_kind("binary")
--libmmd_source()
