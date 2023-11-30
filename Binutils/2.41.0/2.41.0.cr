class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass2")
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/ltmain.sh","$add_dir","",6009)
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=#{Ism.settings.toolsPath}",
                                "--with-sysroot=#{Ism.settings.rootPath}",
                                "--target=#{Ism.settings.chrootTarget}",
                                "--disable-nls",
                                "--enable-gprofng=no",
                                "--disable-werror",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}"],
                                buildDirectoryPath)
        elsif option("Pass2")
            configureSource([   "--prefix=/usr",
                                "--build=$(../config.guess)",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--disable-nls",
                                "--enable-shared",
                                "--enable-gprofng=no",
                                "--disable-werror",
                                "--enable-64-bit-bfd",
                                "#{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--sysconfdir=/etc"
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

            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libsframe.a")

            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libbfd.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libopcodes.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libsframe.la")
        else
            makeSource(["tooldir=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libgprofng.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib/libsframe.a")
        end
    end

end
