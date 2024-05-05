class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass1") || option("Pass3")
            moveFile("#{workDirectoryPath}/Mpfr-4.1.0","#{mainWorkDirectoryPath}/mpfr")
            moveFile("#{workDirectoryPath}/Gmp-6.2.1","#{mainWorkDirectoryPath}/gmp")
            moveFile("#{workDirectoryPath}/Mpc-1.2.1","#{mainWorkDirectoryPath}/mpc")
        end

        if !option("Pass1") && !option("Pass2") && !option("Pass3") && !option("Pass4")
            fileDeleteLine("#{mainWorkDirectoryPath(false)}/libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp",170)
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp","return kAltStackSize;","return SIGSTKSZ * 4;",170)
        end

        if architecture("x86_64")
            if (option("Pass1") || option("Pass3")) && !option("Pass3") && !option("Pass4")
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
            makeDirectory("#{buildDirectoryPath}/#{Ism.settings.chrootTarget}/libgcc")
            makeLink(   "../../../libgcc/gthr-posix.h",
                        "#{buildDirectoryPath}/#{Ism.settings.chrootTarget}/libgcc/gthr-default.h",
                        :symbolicLink)
        end

        if option("Pass4")
            makeLink(   "gthr-posix.h",
                        "#{mainWorkDirectoryPath(false)}libgcc/gthr-default.h",
                        :symbolicLink)
        end
    end
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--target=#{Ism.settings.chrootTarget}",
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
            configureSource([   "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(../config.guess)",
                                "--prefix=#{Ism.settings.rootPath}usr",
                                "--disable-multilib",
                                "--disable-nls",
                                "--disable-libstdcxx-pch",
                                "--with-gxx-include-dir=#{Ism.settings.toolsPath}#{Ism.settings.chrootTarget}/include/c++/11.2.0"],
                                buildDirectoryPath,
                                "libstdc++-v3")
        elsif option("Pass3")
            configureSource([   "--build=$(../config.guess)",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--prefix=/usr",
                                "CC_FOR_TARGET=#{Ism.settings.chrootTarget}-gcc",
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
        elsif option("Pass4")
            configureSource([   "--prefix=/usr",
                                "--disable-multilib",
                                "--disable-nls",
                                "--host=#{Ism.settings.target}",
                                "--disable-libstdcxx-pch"],
                                buildDirectoryPath,
                                "libstdc++-v3",
                                {"CXXFLAGS" => "-g -O2 -D_GNU_SOURCE"})
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
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end

        if !option("Pass1") && !option("Pass2") && !option("Pass3") && !option("Pass4")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/bfd-plugins")
            moveFile(Dir["#{Ism.settings.rootPath}usr/lib/*gdb.py"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/gdb/auto-load/usr/lib")

            makeLink("/usr/bin/cpp","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/cpp",:symbolicLink)
            makeLink("../../libexec/gcc/#{Ism.settings.target}11.2.0/liblto_plugin.so","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/bfd-plugins/liblto_plugin.so",:symbolicLinkByOverwrite)
        end

        if option("Pass3")
            makeLink("gcc","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/cc",:symbolicLink)
        end
    end

    def install
        super

        if !option("Pass1") && !option("Pass2") && !option("Pass3") && !option("Pass4")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/11.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.target}/linux-gnu/11.2.0/include-fixed","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/11.2.0/include","root","root")
            setOwnerRecursively("#{Ism.settings.rootPath}usr/lib/gcc/#{Ism.settings.architecture}-pc-linux-gnu/11.2.0/include-fixed","root","root")
        end
    end

    def clean
        super

        if !option("Pass1") && !option("Pass2") && !option("Pass3") && !option("Pass4")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}/usr/lib/gcc/#{Ism.settings.target}/11.2.0/include-fixed/bits/")
        end
    end

end
