target("libxau")
set_kind("static")
add_headerfiles("include/X11/Xauth.h")
add_includedirs("include")
add_files("*.c")
