class Target < ISM::Software

    def setup
        super

        if option("Pass1") || option("Pass3")
            @additions = [  dependency("@BaseLibraries-Main:Mpfr").sourcesLink,
                            dependency("@BaseLibraries-Main:Gmp").sourcesLink,
                            dependency("@BaseLibraries-Main:Mpc").sourcesLink]
        end
    end

    def prepare
        @buildDirectory = true
        super

        if option("Pass1") || option("Pass3")
            mpfrVersion = "#{softwareVersion("@BaseLibraries-Main:Mpfr")}"
            gmpVersion = "#{softwareVersion("@BaseLibraries-Main:Gmp")}"
            mpcVersion = "#{softwareVersion("@BaseLibraries-Main:Mpc")}"

            moveFile(   "#{workDirectoryPath}/Mpfr-#{mpfrVersion}",
                        "#{mainWorkDirectoryPath}/mpfr")

            moveFile(   "#{workDirectoryPath}/Gmp-#{gmpVersion}",
                        "#{mainWorkDirectoryPath}/gmp")

            moveFile(   "#{workDirectoryPath}/Mpc-#{mpcVersion}",
                        "#{mainWorkDirectoryPath}/mpc")
        end

        if architecture("x86_64")
            if option("Pass1") || option("Pass3")
                if option("32Bits")
                    fileReplaceLineContaining(  path:       "#{mainWorkDirectoryPath}/gcc/config/i386/t-linux64",
                                                text:       "MULTILIB_OSDIRNAMES+= m32=",
                                                newLine:    "MULTILIB_OSDIRNAMES+= m32=../lib32$(call if_multiarch,:i386-linux-gnu)")
                end
            else
                if !option("Pass2")
                    if option("32Bits")
                        fileReplaceLineContaining(  path:       "#{mainWorkDirectoryPath}/gcc/config/i386/t-linux64",
                                                    text:       "MULTILIB_OSDIRNAMES+= m32=",
                                                    newLine:    "MULTILIB_OSDIRNAMES+= m32=../lib32$(call if_multiarch,:i386-linux-gnu)")
                    end
                end
            end
        end

        if option("Pass3")
            fileReplaceTextAtLineNumber(path:       "#{mainWorkDirectoryPath}/libgcc/Makefile.in",
                                        text:       "@thread_header@",
                                        newText:    "gthr-posix.h",
                                        lineNumber: 52)

            fileReplaceTextAtLineNumber(path:       "#{mainWorkDirectoryPath}/libstdc++-v3/include/Makefile.in",
                                        text:       "@thread_header@",
                                        newText:    "gthr-posix.h",
                                        lineNumber: 348)
        end
    end
    
    def configure
        super

        if option("Multilib") && !option("Pass2")
            multilibList = "m64"

            if option("32Bits")
                multilibList += ",m32"
            end

            if option("32Bits")
                multilibList += ",mx32"
            end
        end

        if option("Pass1")
            configureSource(arguments:  "--target=#{Ism.settings.chrootTarget}                                                                  \
                                        --prefix=#{Ism.settings.toolsPath}                                                                      \
                                        --with-glibc-version=2.41                                                                    \
                                        --with-sysroot=#{Ism.settings.rootPath}                                                                 \
                                        --with-newlib                                                                                           \
                                        --without-headers                                                                                       \
                                        --enable-default-pie                                                                                    \
                                        --enable-default-ssp                                                                                    \
                                        --disable-nls                                                                                           \
                                        --disable-shared                                                                                        \
                                        #{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"} \
                                        --disable-threads                                                                                       \
                                        --disable-libatomic                                                                                     \
                                        --disable-libgomp                                                                                       \
                                        --disable-libquadmath                                                                                   \
                                        --disable-libssp                                                                                        \
                                        --disable-libvtv                                                                                        \
                                        --disable-libstdcxx                                                                                     \
                                        --enable-languages=c,c++",
                            path:       buildDirectoryPath)
        elsif option("Pass2")
            configureSource(arguments:          "--host=#{Ism.settings.chrootTarget}                                \
                                                --build=$(../config.guess)                                          \
                                                --prefix=#{Ism.settings.rootPath}/usr                               \
                                                #{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}  \
                                                --disable-nls                                                       \
                                                --disable-libstdcxx-pch                                             \
                                                --with-gxx-include-dir=#{Ism.settings.toolsPath}#{Ism.settings.chrootTarget}/include/c++/#{version}",
                            path:               buildDirectoryPath,
                            configureDirectory: "libstdc++-v3")
        elsif option("Pass3")
            configureSource(arguments:  "--build=$(../config.guess)                                                                             \
                                        --host=#{Ism.settings.chrootTarget}                                                                     \
                                        --target=#{Ism.settings.chrootTarget}                                                                   \
                                        LDFLAGS_FOR_TARGET=-L#{buildDirectoryPath}/#{Ism.settings.chrootTarget}/libgcc                          \
                                        --prefix=/usr                                                                                           \
                                        --with-build-sysroot=#{Ism.settings.rootPath}                                                           \
                                        --enable-default-pie                                                                                    \
                                        --enable-default-ssp                                                                                    \
                                        --disable-nls                                                                                           \
                                        #{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"} \
                                        --disable-libatomic                                                                                     \
                                        --disable-libgomp                                                                                       \
                                        --disable-libquadmath                                                                                   \
                                        --disable-libsanitizer                                                                                  \
                                        --disable-libssp                                                                                        \
                                        --disable-libvtv                                                                                        \
                                        --enable-languages=c,c++",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                                                                                          \
                                        --build=$(../config.guess)                                                                              \
                                        LD=ld                                                                                                   \
                                        --enable-languages=c,c++                                                                                \
                                        --enable-default-pie                                                                                    \
                                        --enable-host-pie                                                                                       \
                                        --enable-default-ssp                                                                                    \
                                        #{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"} \
                                        --disable-bootstrap                                                                                     \
                                        --disable-fixincludes                                                                                   \
                                        --with-system-zlib",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath} install",
                        path:       buildDirectoryPath)

            fileAppendDataFromFile( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                                    fromPath:   mainWorkDirectoryPath + "/gcc/limitx.h")

            fileAppendDataFromFile( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                                    fromPath:   mainWorkDirectoryPath + "/gcc/glimits.h")

            fileAppendDataFromFile( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                                    fromPath:   mainWorkDirectoryPath + "/gcc/limity.h")
        elsif option("Pass2")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath} install",
                        path:       buildDirectoryPath)
        else
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)
        end

        if !passEnabled
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/bfd-plugins")

            moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib64/*gdb.py",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")


            makeLink(   target: "/usr/bin/cpp",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/cpp",
                        type:   :symbolicLink)

            makeLink(   target: "/usr/libexec/gcc/#{Ism.settings.systemTarget}/#{version}/liblto_plugin.so",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/bfd-plugins/liblto_plugin.so",
                        type:   :symbolicLinkByOverwrite)
        end

        if option("Pass3")
            makeLink(   target: "gcc",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cc",
                        type:   :symbolicLink)
        end
    end

end
