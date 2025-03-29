package("libxau")

    set_homepage("https://www.x.org/")
    set_description("X.Org: A Sample Authorization Protocol for X")

    set_urls("https://www.x.org/archive/individual/lib/libXau-$(version).tar.gz0")
    add_versions("1.0.10", "51a54da42475d4572a0b59979ec107c27dacf6c687c2b7b04e5cf989a7c7e60c")
    add_versions("1.0.11", "3a321aaceb803577a4776a5efe78836eb095a9e44bbc7a465d29463e1a14f189")
    add_versions("1.0.12", "2402dd938da4d0a332349ab3d3586606175e19cb32cb9fe013c19f1dc922dcee")

    on_install("macosx", "linux", "bsd", "cross", function (package)
        local configs = {"--sysconfdir=" .. package:installdir("etc"),
            "--localstatedir=" .. package:installdir("var"),
            "--disable-dependency-tracking",
            "--disable-silent-rules"}
        table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:config("pic") then
            table.insert(configs, "--with-pic")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_ctypes("Xauth", {includes = "X11/Xauth.h"}))
    end)
package_end()

package("glfw-mod")
    set_sourcedir(path.join(os.scriptdir(), "glfw"))

    add_configs("glfw_include", {description = "Choose submodules enabled in glfw", default = "none", type = "string", values = {"none", "vulkan", "glu", "glext", "es2", "es3", "system"}})
    add_configs("x11", {description = "Build support for X11", default = is_plat("linux"), type = "boolean"})
    add_configs("wayland", {description = "Build support for Wayland", default = false, type = "boolean"})

    add_deps("cmake")
    add_deps("opengl", {optional = true})
    if is_plat("macosx") then
        add_frameworks("Cocoa", "IOKit")
    elseif is_plat("windows") then
        add_syslinks("user32", "shell32", "gdi32")
    elseif is_plat("mingw") then
        add_syslinks("gdi32")
    elseif is_plat("android") then
        add_syslinks("dl", "log", "android")
    elseif is_plat("linux") then
        add_syslinks("dl", "pthread")
    end

    on_load(function (package)
        local glfw_include = package:config("glfw_include")
        if glfw_include ~= "system" then
            package:add("defines", "GLFW_INCLUDE_" .. glfw_include:upper())
        end
        if package:config("x11") then
            package:add("deps", "libx11", "libxrandr", "libxrender", "libxinerama", "libxfixes", "libxcursor", "libxi", "libxext")
        end
        if package:config("wayland") then
            package:add("deps", "wayland")
        end
    end)

    on_install("!wasm and !ios", function (package)
        local configs = {"-DGLFW_BUILD_DOCS=OFF", "-DGLFW_BUILD_TESTS=OFF", "-DGLFW_BUILD_EXAMPLES=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        if package:is_plat("windows") then
            table.insert(configs, "-DUSE_MSVC_RUNTIME_LIBRARY_DLL=" .. (package:has_runtime("MT") and "OFF" or "ON"))
        end
        table.insert(configs, "-DGLFW_BUILD_X11=" .. (package:config("x11") and "ON" or "OFF"))
        table.insert(configs, "-DGLFW_BUILD_WAYLAND=" .. (package:config("wayland") and "ON" or "OFF"))
        if package:is_plat("linux") then
            import("package.tools.cmake").install(package, configs, {packagedeps = {"libxrender", "libxfixes", "libxext", "libx11", "wayland"}})
        else
            import("package.tools.cmake").install(package, configs)
        end
    end)
package_end()

add_requires("glfw-mod", { configs = { shared = true } })

target("glfw-wrap")
set_kind("binary")
add_files("../src/external/glfw/helper.cpp")
add_packages("glfw-mod")
