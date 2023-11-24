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
            else
                fileReplaceText(mainWorkDirectoryPath(false) +
                                "/gcc/config/i386/t-linux64",
                                "m64=../lib64",
                                "m64=../lib")
            end
        end

        if option("Pass3")
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/libgcc/Makefile.in","@thread_header@","gthr-posix.h",52)

            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/libstdc++-v3/include/Makefile.in","@thread_header@","gthr-posix.h",348)
        end
    end
    
    def configure
        super

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
                                "--disable-multilib",
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
                                "--disable-multilib",
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
                                "--disable-multilib",
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
                                "--disable-multilib",
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

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/install-tools/include/limits.h",
                        getFileContent(mainWorkDirectoryPath + "gcc/limitx.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/install-tools/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/glimits.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.chrootTarget}/#{@information.version}/install-tools/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/limity.h"))
        elsif option("Pass2")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath}/usr/lib/stdc++.la")
            deleteFile("#{builtSoftwareDirectoryPath}/usr/lib/stdc++fs.la")
            deleteFile("#{builtSoftwareDirectoryPath}/usr/lib/supc++.la")
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end

        if !option("Pass1") && !option("Pass2") && !option("Pass3")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
            moveFile(Dir["#{Ism.settings.rootPath}usr/lib/*gdb.py"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
        end
    end

    def install
        super

        if option("Pass3")
            makeLink("gcc","#{Ism.settings.rootPath}usr/bin/cc",:symbolicLink)
        end

        if !option("Pass1") && !option("Pass2") && !option("Pass3")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/13.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/13.2.0/include-fixed","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/13.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/13.2.0/include-fixed","root","root")
            makeLink("/usr/bin/cpp","#{Ism.settings.rootPath}usr/lib",:symbolicLink)
            makeLink("../../libexec/gcc/#{Ism.settings.target}13.2.0/liblto_plugin.so","#{Ism.settings.rootPath}usr/lib/bfd-plugins/",:symbolicLinkByOverwrite)
        end
    end

    def clean
        super

        if !option("Pass1") && !option("Pass2") && !option("Pass3")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}/usr/lib/gcc/#{Ism.settings.target}/13.2.0/include-fixed/bits/")
        end
    end

end
