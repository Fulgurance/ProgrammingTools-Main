class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass1")
            makeLink(   target: "ld-linux-x86-64.so.2",
                        path:   "#{Ism.settings.rootPath}/lib64/ld-lsb-x86-64.so.3",
                        type:   :symbolicLinkByOverwrite)
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                                                          \
                                        --host=#{Ism.settings.chrootTarget}                                     \
                                        --build=$(../scripts/config.guess)                                      \
                                        --enable-kernel=4.14                                                    \
                                        --with-headers=#{Ism.settings.rootPath}/usr/include                     \
                                        #{option("32Bits") || option("x32Bits") ? "--enable-multi-arch" : ""}   \
                                        libc_cv_slibdir=/usr/lib",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                                                          \
                                        --disable-werror                                                        \
                                        --enable-kernel=4.14                                                    \
                                        --enable-stack-protector=strong                                         \
                                        --with-headers=/usr/src/main-kernel-sources/usr/include                 \
                                        #{option("32Bits") || option("x32Bits") ? "--enable-multi-arch" : ""}   \
                                        libc_cv_slibdir=/usr/lib",
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
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}")
        else
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/cache/nscd")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/locale")
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/ld.so.conf")

            fileReplaceText(path:       "#{mainWorkDirectoryPath}Makefile",
                            text:       "$(PERL)",
                            newText:    "echo not running")
        end

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/ldd",
                        text:       "RTLDLIST=\"/usr/lib/ld-linux.so.2 /usr/lib64/ld-linux-x86-64.so.2 /usr/libx32/ld-linux-x32.so.2\"",
                        newText:    "RTLDLIST=\"/lib/ld-linux.so.2 /lib64/ld-linux-x86-64.so.2 /libx32/ld-linux-x32.so.2\"")

        if !option("Pass1")
            copyFile(   "#{mainWorkDirectoryPath}/nscd/nscd.conf",
                        "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/nscd.conf")

            nsswitchData = <<-CODE
            passwd: files
            group: files
            shadow: files

            hosts: files dns
            networks: files

            protocols: files
            services: files
            ethers: files
            rpc: files
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}etc/nsswitch.conf",nsswitchData)

            ldsoData = <<-CODE
            include /etc/ld.so.conf.d/*.conf
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}etc/ld.so.conf",ldsoData)
        end
    end

end
