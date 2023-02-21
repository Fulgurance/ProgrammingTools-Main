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
                                "--target=#{Ism.settings.target}",
                                "--disable-nls",
                                "--disable-werror"],
                                buildDirectoryPath)
        elsif option("Pass2")
            configureSource([   "--prefix=#{Ism.settings.rootPath}usr",
                                "--build=$(../config.guess)",
                                "--host=#{Ism.settings.target}",
                                "--disable-nls",
                                "--enable-shared",
                                "--disable-werror",
                                "--enable-64-bit-bfd"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--enable-gold",
                                "--enable-ld=default",
                                "--enable-plugins",
                                "--enable-shared",
                                "--disable-werror",
                                "--enable-64-bit-bfd",
                                "--with-system-zlib"],
                                buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1") || option("Pass2")
            makeSource([Ism.settings.makeOptions],buildDirectoryPath)
        else
            makeSource([Ism.settings.makeOptions,"tooldir=/usr"],buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        if option("Pass1") || option("Pass2")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
        else
            makeSource([Ism.settings.makeOptions,"tooldir=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end

        if option("Pass2")
            moveFile("#{buildDirectoryPath}/libctf/.libs/libctf.so.0.0.0","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libctf.so.0.0.0")
        end
    end

    def install
        super
        if option("Pass2")
            setPermissions("#{Ism.settings.rootPath}usr/lib/libctf.so.0.0.0",755)
        end
    end

    def clean
        super
        if !option("Pass1") && !option("Pass2")
            deleteFile("#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
        end
    end

end
