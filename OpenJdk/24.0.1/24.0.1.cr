class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                  \
                                    --with-stdc++lib=dynamic                        \
                                    --with-boot-jdk=../OpenJdk-Binaries-#{version}  \
                                    --disable-ccache                                \
                                    --disable-precompiled-headers                   \
                                    --disable-warnings-as-errors                    \
                                    --enable-full-docs=no                           \
                                    --with-freetype=system                          \
                                    --with-libjpeg=system                           \
                                    --with-giflib=system                            \
                                    --with-libpng=system                            \
                                    --with-lcms=system                              \
                                    --with-zlib=system                              \
                                    --enable-unlimited-crypto                       \
                                    --with-harfbuzz=system",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource( arguments: "images",
                    path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/opt")

        moveFile(   "#{buildDirectoryPath}/build/*/images/jdk",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/opt/jdk-#{version}")

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/qt.sh")
            copyFile(   "/etc/profile.d/qt.sh",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        end

        jdkData = <<-CODE
        JAVA_HOME=/opt/jdk
        AUTO_CLASSPATH_DIR=/usr/share/java

        pathappend $JAVA_HOME/bin

        for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
            pathappend $dir CLASSPATH
        done

        for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
            pathappend $jar CLASSPATH
        done

        _JAVA_OPTIONS="-XX:-UsePerfData"

        export JAVA_HOME
        export _JAVA_OPTIONS
        unset AUTO_CLASSPATH_DIR dir jar _JAVA_OPTIONS
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/jdk.sh",jdkData)

        makeLink(   target: "/etc/pki/tls/java/cacerts",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/opt/jdk/lib/security/cacerts",
                    type:   :symbolicLink)

        if isGreatestVersion
            makeLink(   target: "jdk-#{version}",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/opt/jdk",
                        type:   :symbolicLink)
        end
    end

end
