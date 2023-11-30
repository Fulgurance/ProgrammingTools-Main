class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if !option("Pass1") && !option("Pass2")
            fileDeleteLine("#{mainWorkDirectoryPath(false)}/etc/texi2pod.pl",63)
            deleteAllFilesRecursivelyFinishing("#{mainWorkDirectoryPath(false)}",".1")
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=#{Ism.settings.toolsPath}",
                                "--with-sysroot=#{Ism.settings.rootPath}",
                                "--target=#{Ism.settings.chrootTarget}",
                                "--disable-nls",
                                "--disable-werror",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}"],
                                buildDirectoryPath)
        elsif option("Pass2")
            configureSource([   "--prefix=/usr",
                                "--build=$(../config.guess)",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--disable-nls",
                                "--enable-shared",
                                "--disable-werror",
                                "--enable-64-bit-bfd",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--enable-gold",
                                "--enable-ld=default",
                                "--enable-plugins",
                                "--enable-shared",
                                "--disable-werror",
                                "--enable-64-bit-bfd",
                                "--with-system-zlib",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}"],
                                buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1") || option("Pass2")
            makeSource(path: buildDirectoryPath)
        else
            makeSource(["tooldir=/usr"],buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        if option("Pass1")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
        elsif option("Pass2")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            moveFile("#{buildDirectoryPath}/libctf/.libs/libctf.so.0.0.0","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libctf.so.0.0.0")
        else
            makeSource(["tooldir=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
        end
    end

    def install
        super

        if option("Pass2")
            setPermissions("#{Ism.settings.rootPath}usr/lib/libctf.so.0.0.0",755)
        end
    end

end
