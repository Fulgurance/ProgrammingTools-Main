class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass1") || option("Pass2")
            moveFile("#{workDirectoryPath}/mpfr-4.1.0","#{mainWorkDirectoryPath}/mpfr")
            moveFile("#{workDirectoryPath}/gmp-6.2.1","#{mainWorkDirectoryPath}/gmp")
            moveFile("#{workDirectoryPath}/mpc-1.2.1","#{mainWorkDirectoryPath}/mpc")
        end

        if !option("Pass1") && !option("Pass2")
            fileDeleteLine("#{mainWorkDirectoryPath(false)}/libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp",170)
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp","return kAltStackSize;","return SIGSTKSZ * 4;",170)
        end

        if architecture("x86_64")
            if option("Pass1") || option("Pass2")
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

        if option("Pass2")
            makeDirectory("#{buildDirectoryPath}/#{Ism.settings.target}/libgcc")
            makeLink(   "../../../libgcc/gthr-posix.h",
                        "#{buildDirectoryPath}/#{Ism.settings.target}/libgcc/gthr-default.h",
                        :symbolicLink)
        end
    end
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--target=#{Ism.settings.target}",
                                "--prefix=#{Ism.settings.toolsPath}",
                                "--with-glibc-version=2.11",
                                "--with-sysroot=#{Ism.settings.rootPath}",
                                "--with-newlib",
                                "--without-headers",
                                "--enable-initfini-array",
                                "--disable-nls",
                                "--disable-shared",
                                "--disable-multilib",
                                "--disable-decimal-float",
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
            configureSource([   "--build=$(../config.guess)",
                                "--host=#{Ism.settings.target}",
                                "--prefix=/usr",
                                "CC_FOR_TARGET=#{Ism.settings.target}-gcc",
                                "--with-build-sysroot=#{Ism.settings.rootPath}",
                                "--enable-initfini-array",
                                "--disable-nls",
                                "--disable-multilib",
                                "--disable-decimal-float",
                                "--disable-libatomic",
                                "--disable-libgomp",
                                "--disable-libquadmath",
                                "--disable-libssp",
                                "--disable-libvtv",
                                "--disable-libstdcxx",
                                "--enable-languages=c,c++"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "LD=ld",
                                "--enable-languages=c,c++",
                                "--disable-multilib",
                                "--disable-bootstrap",
                                "--with-system-zlib"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                        getFileContent(mainWorkDirectoryPath + "gcc/limitx.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/glimits.h"))
            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}lib/gcc/#{Ism.settings.target}/#{@information.version}/install-tools/include/limits.h",
                            getFileContent(mainWorkDirectoryPath + "gcc/limity.h"))
        else
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end

        if !option("Pass1") && !option("Pass2")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
            moveFile(Dir["#{Ism.settings.rootPath}usr/lib/*gdb.py"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
        end
    end

    def install
        super

        if option("Pass2")
            makeLink("gcc","#{Ism.settings.rootPath}usr/bin/cc",:symbolicLink)
        end

        if !option("Pass1") && !option("Pass2")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/11.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/11.2.0/include-fixed","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/11.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/11.2.0/include-fixed","root","root")
            makeLink("/usr/bin/cpp","#{Ism.settings.rootPath}usr/lib",:symbolicLink)
            makeLink("../../libexec/gcc/#{Ism.settings.target}11.2.0/liblto_plugin.so","#{Ism.settings.rootPath}usr/lib/bfd-plugins/",:symbolicLinkByOverwrite)
        end
    end

    def clean
        super

        if !option("Pass1") && !option("Pass2")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}/usr/lib/gcc/#{Ism.settings.target}/11.2.0/include-fixed/bits/")
        end
    end

end
