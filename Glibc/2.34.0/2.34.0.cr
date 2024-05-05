class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass1")
            makeLink(   "ld-linux.so.2",
                        "#{Ism.settings.rootPath}/lib/ld-lsb.so.3",
                        :symbolicLinkByOverwrite)
            makeLink(   "../lib/ld-linux-x86-64.so.2",
                        "#{Ism.settings.rootPath}/lib64/ld-linux-x86-64.so.2",
                        :symbolicLinkByOverwrite)
            makeLink(   "../lib/ld-linux-x86-64.so.2",
                        "#{Ism.settings.rootPath}/lib64/ld-lsb-x86-64.so.3",
                        :symbolicLinkByOverwrite)
        else
            fileReplaceText("#{mainWorkDirectoryPath(false)}/sysdeps/unix/sysv/linux/mq_notify.c","NOTIFY_REMOVED)","NOTIFY_REMOVED && data.attr != NULL)")
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=3.2",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "libc_cv_slibdir=/usr/lib"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--disable-werror",
                                "--enable-kernel=3.2",
                                "--enable-stack-protector=strong",
                                "--with-headers=/usr/include",
                                "libc_cv_slibdir=/usr/lib"],
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
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}")
        else
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}var/cache/nscd")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/locale")
            generateEmptyFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf")
            fileReplaceText("#{mainWorkDirectoryPath(false)}Makefile","$(PERL)","echo not running")
        end

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Pass1")
            fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/ldd",
                "RTLDLIST=\"/usr/lib/ld-linux.so.2 /usr/lib64/ld-linux-x86-64.so.2 /usr/libx32/ld-linux-x32.so.2\"",
                "RTLDLIST=\"/lib/ld-linux.so.2 /lib64/ld-linux-x86-64.so.2 /libx32/ld-linux-x32.so.2\"")

            runScript(  "mkheaders",
                        path: "#{Ism.settings.toolsPath}/libexec/gcc/#{Ism.settings.target}/11.2.0/install-tools")
        else
            fileReplaceText("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/ldd",
                "RTLDLIST=\"/usr/lib/ld-linux.so.2 /usr/lib64/ld-linux-x86-64.so.2 /usr/libx32/ld-linux-x32.so.2\"",
                "RTLDLIST=\"/lib/ld-linux.so.2 /lib64/ld-linux-x86-64.so.2 /libx32/ld-linux-x32.so.2\"")

            copyFile("#{mainWorkDirectoryPath(false)}/nscd/nscd.conf","#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/nscd.conf")

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
            fileWriteData("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}etc/nsswitch.conf",nsswitchData)

            ldsoData = <<-CODE
            include /etc/ld.so.conf.d/*.conf
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}etc/ld.so.conf",ldsoData)
        end
    end

end
