class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass1") || option("Pass3")
            moveFile("#{workDirectoryPath}/Mpfr-4.2.0","#{mainWorkDirectoryPath}/mpfr")
            moveFile("#{workDirectoryPath}/Gmp-6.3.0","#{mainWorkDirectoryPath}/gmp")
            moveFile("#{workDirectoryPath}/Mpc-1.3.1","#{mainWorkDirectoryPath}/mpc")
        end

        if architecture("x86_64")
            if option("Pass1") || option("Pass3")
                fileReplaceText(mainWorkDirectoryPath +
                                "/gcc/config/i386/t-linux64",
                                "m64=../lib64",
                                "m64=../lib")

                if option("32Bits")
                    fileReplaceLineContaining(  mainWorkDirectoryPath +
                                                "/gcc/config/i386/t-linux64",
                                                "MULTILIB_OSDIRNAMES+= m32=",
                                                "MULTILIB_OSDIRNAMES+= m32=../lib32$(call if_multiarch,:i386-linux-gnu)")
                end
            else
                if !option("Pass2")
                    fileReplaceText(mainWorkDirectoryPath +
                                    "/gcc/config/i386/t-linux64",
                                    "m64=../lib64",
                                    "m64=../lib")

                    if option("32Bits")
                        fileReplaceLineContaining(  mainWorkDirectoryPath +
                                                    "/gcc/config/i386/t-linux64",
                                                    "MULTILIB_OSDIRNAMES+= m32=",
                                                    "MULTILIB_OSDIRNAMES+= m32=../lib32$(call if_multiarch,:i386-linux-gnu)")
                    end
                end
            end
        end

        if option("Pass3")
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath}/libgcc/Makefile.in","@thread_header@","gthr-posix.h",52)

            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath}/libstdc++-v3/include/Makefile.in","@thread_header@","gthr-posix.h",348)
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
            configureSource([   "--target=#{Ism.settings.chrootTarget}",
                                "--prefix=#{Ism.settings.toolsPath}",
                                "--with-glibc-version=2.38",
                                "--with-sysroot=#{Ism.settings.rootPath}",
                                "--with-newlib",
                                "--without-headers",
                                "--enable-default-pie",
                                "--enable-default-ssp",
                                "--disable-nls",
                                "--disable-shared",
                                "#{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"}",
                                "--disable-threads",
                                "--disable-libatomic",
                                "--disable-libgomp",
                                "--disable-libquadmath",
                                "--disable-libssp",
                                "--disable-libvtv",
                                "--disable-libstdcxx",
                                "--enable-languages=c,c++"],
                                buildDirectoryPath)
        elsif option("Pass2")
            configureSource([   "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(../config.guess)",
                                "--prefix=#{Ism.settings.rootPath}usr",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}",
                                "--disable-nls",
                                "--disable-libstdcxx-pch",
                                "--with-gxx-include-dir=#{Ism.settings.toolsPath}#{Ism.settings.chrootTarget}/include/c++/13.2.0"],
                                buildDirectoryPath,
                                "libstdc++-v3")
        elsif option("Pass3")
            configureSource([   "--build=$(../config.guess)",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--target=#{Ism.settings.chrootTarget}",
                                "LDFLAGS_FOR_TARGET=-L#{buildDirectoryPath}/#{Ism.settings.chrootTarget}/libgcc",
                                "--prefix=/usr",
                                "--with-build-sysroot=#{Ism.settings.rootPath}",
                                "--enable-default-pie",
                                "--enable-default-ssp",
                                "--disable-nls",
                                "#{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"}",
                                "--disable-libatomic",
                                "--disable-libgomp",
                                "--disable-libquadmath",
                                "--disable-libsanitizer",
                                "--disable-libssp",
                                "--disable-libvtv",
                                "--enable-languages=c,c++"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "LD=ld",
                                "--enable-languages=c,c++",
                                "--enable-default-pie",
                                "--enable-default-ssp",
                                "#{option("Multilib") ? "--enable-multilib --with-multilib-list=#{multilibList}" : "--disable-multilib"}",
                                "--disable-bootstrap",
                                "--disable-fixincludes",
                                "--with-system-zlib"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                        getFileContent(mainWorkDirectoryPath + "gcc/limitx.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/glimits.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/limity.h"))
        elsif option("Pass2")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libstdc++.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libstdc++fs.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libsupc++.la")
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end

        if !option("Pass1") && !option("Pass2") && !option("Pass3")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/bfd-plugins")
            moveFile(Dir["#{Ism.settings.rootPath}usr/lib/*gdb.py"],"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")


            makeLink("/usr/bin/cpp","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/cpp",:symbolicLink)
            makeLink("../../libexec/gcc/#{Ism.settings.target}13.2.0/liblto_plugin.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/bfd-plugins/liblto_plugin.so",:symbolicLinkByOverwrite)
        end

        if option("Pass3")
            makeLink("gcc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cc",:symbolicLink)
        end
    end

    def install
        super

        if !option("Pass1") && !option("Pass2") && !option("Pass3")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/13.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/13.2.0/include-fixed","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/13.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/13.2.0/include-fixed","root","root")
        end
    end

end
