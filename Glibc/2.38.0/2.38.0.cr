class Target < ISM::Software

    def prepare

        @buildDirectory = true

        if option("32Bits")
            @buildDirectoryNames["32Bits"] = "mainBuild-32"
        end

        if option("x32Bits")
            @buildDirectoryNames["x32Bits"] = "mainBuild-x32"
        end

        super

        if option("Pass1")
            makeLink(   "ld-linux.so.2",
                        "#{Ism.settings.rootPath}/lib/ld-lsb.so.3",
                        :symbolicLinkByOverwrite)
            makeLink(   "../lib/ld-linux-x86-64.so.2",
                        "#{Ism.settings.rootPath}/lib64",
                        :symbolicLinkByOverwrite)
            makeLink(   "../lib/ld-linux-x86-64.so.2",
                        "#{Ism.settings.rootPath}/lib64/ld-lsb-x86-64.so.3",
                        :symbolicLinkByOverwrite)
        end
    end

    def configure32Bits

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}32",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=4.14",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "--enable-multi-arch",
                                "-libdir=/usr/lib32",
                                "--libexecdir=/usr/lib32",
                                "libc_cv_slibdir=/usr/lib32"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" => "#{Ism.settings.chrootTarget}-gcc -m32",
                                                "CXX" => "#{Ism.settings.chrootTarget}-g++ -m32"})
        else
            configureSource([   "--prefix=/usr",
                                "--host=i686-#{Ism.settings.targetName}-linux-gnu",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=4.14",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "--enable-multi-arch",
                                "-libdir=/usr/lib32",
                                "--libexecdir=/usr/lib32",
                                "libc_cv_slibdir=/usr/lib32"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" => "#{Ism.settings.chrootTarget}-gcc -m32",
                                                "CXX" => "#{Ism.settings.chrootTarget}-g++ -m32"})
        end
    end

    def configurex32Bits

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}X32",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=4.14",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "--enable-multi-arch",
                                "-libdir=/usr/libx32",
                                "--libexecdir=/usr/libx32",
                                "libc_cv_slibdir=/usr/libx32"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" => "#{Ism.settings.chrootTarget}-gcc -mx32",
                                                "CXX" => "#{Ism.settings.chrootTarget}-g++ -mx32"})
        else
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}X32",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=4.14",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "--enable-multi-arch",
                                "--libdir=/usr/libx32",
                                "--libexecdir=/usr/libx32",
                                "libc_cv_slibdir=/usr/libx32"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" => "#{Ism.settings.chrootTarget}-gcc -mx32",
                                                "CXX" => "#{Ism.settings.chrootTarget}-g++ -mx32"})
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(../scripts/config.guess)",
                                "--enable-kernel=4.14",
                                "--with-headers=#{Ism.settings.rootPath}/usr/include",
                                "#{option("32Bits") || option("x32Bits") ? "--enable-multi-arch" : ""}",
                                "libc_cv_slibdir=/usr/lib"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--disable-werror",
                                "--enable-kernel=4.14",
                                "--enable-stack-protector=strong",
                                "--with-headers=/usr/include",
                                "#{option("32Bits") || option("x32Bits") ? "--enable-multi-arch" : ""}",
                                "libc_cv_slibdir=/usr/lib"],
                                buildDirectoryPath)
        end

        if option("32Bits")
            configure32Bits
        end

        if option("x32Bits")
            configurex32Bits
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeSource(path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource(path: buildDirectoryPath(entry: "x32Bits"))
        end
    end

    def prepare32Bits
        makeDirectory("#{buildDirectoryPath(false, entry: "32Bits")}/32Bits")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu")

        makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                    "install"],
                    path: buildDirectoryPath(entry: "32Bits"))

        copyDirectory(  "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/lib32",
                        "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib32")

        copyFile(   "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/include/gnu/lib-names-32.h",
                    "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu/lib-names-32.h")

        copyFile(   "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/include/gnu/stubs-32.h",
                    "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu/stubs-32.h")
    end

    def preparex32Bits
        makeDirectory("#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu")

        makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                    "install"],
                    path: buildDirectoryPath(entry: "x32Bits"))

        copyDirectory(  "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/libx32",
                        "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/libx32")

        copyFile(   "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/include/gnu/lib-names-x32.h",
                    "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu/lib-names-x32.h")

        copyFile(   "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/include/gnu/stubs-x32.h",
                    "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/include/gnu/stubs-x32.h")
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

        if option("32Bits")
            prepare32Bits

            makeLink(   "../lib32/ld-linux.so.2",
                        "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/lib/ld-linux.so.2",
                            :symbolicLinkByOverwrite)
        end

        if option("x32Bits")
            preparex32Bits

            makeLink(   "../libx32/ld-linux-x32.so.2",
                        "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/lib/ld-linux-x32.so.2",
                            :symbolicLinkByOverwrite)
        end
    end

end
