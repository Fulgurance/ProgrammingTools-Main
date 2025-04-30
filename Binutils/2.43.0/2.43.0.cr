class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass2")
            fileReplaceTextAtLineNumber(path:       "#{mainWorkDirectoryPath}/ltmain.sh",
                                        text:       "$add_dir",
                                        newText:    "",
                                        lineNumber: 6009)
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=#{Ism.settings.toolsPath}     \
                                        --with-sysroot=#{Ism.settings.rootPath} \
                                        --target=#{Ism.settings.chrootTarget}   \
                                        --disable-nls                           \
                                        --enable-gprofng=no                     \
                                        --disable-werror                        \
                                        --enable-new-dtags                      \
                                        --enable-default-hash-style=gnu         \
                                        #{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}",
                            path:       buildDirectoryPath)
        elsif option("Pass2")
            configureSource(arguments:  "--prefix=/usr                          \
                                        --build=$(../config.guess)              \
                                        --host=#{Ism.settings.chrootTarget}     \
                                        --disable-nls                           \
                                        --enable-shared                         \
                                        --enable-gprofng=no                     \
                                        --disable-werror                        \
                                        --enable-64-bit-bfd                     \
                                        --enable-new-dtags                      \
                                        --enable-default-hash-style=gnu         \
                                        #{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                          \
                                        --sysconfdir=/etc                       \
                                        --enable-gold                           \
                                        --enable-ld=default                     \
                                        --enable-plugins                        \
                                        --enable-shared                         \
                                        --disable-werror                        \
                                        --enable-64-bit-bfd                     \
                                        --with-system-zlib                      \
                                        --enable-new-dtags                      \
                                        --enable-default-hash-style=gnu         \
                                        #{option("Multilib") ? "--enable-multilib" : "--disable-multilib"}",
                            path:       buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1") || option("Pass2")
            makeSource(path: buildDirectoryPath)
        else
            makeSource( arguments:  "tooldir=/usr",
                        path:       buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        if option("Pass1")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath} install",
                        path:       buildDirectoryPath)
        elsif option("Pass2")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libsframe.a")

            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libbfd.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libopcodes.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libsframe.la")
        else
            makeSource( arguments:  "tooldir=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libbfd.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libgprofng.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libopcodes.a")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libsframe.a")

            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libbfd.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libctf-nobfd.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libopcodes.la")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libsframe.la")
        end
    end

end
