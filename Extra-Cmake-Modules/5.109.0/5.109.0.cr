class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

        fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath}/kde-modules/KDEInstallDirsCommon.cmake","set(_LIBDIR_DEFAULT \"lib64\")","set(_LIBDIR_DEFAULT \"lib\")",44)

        fileReplaceText("#{mainWorkDirectoryPath}/ECMConfig.cmake.in","@PACKAGE_INIT@","set(SAVE_PACKAGE_PREFIX_DIR \"${PACKAGE_PREFIX_DIR}\")\n@PACKAGE_INIT@")

        fileReplaceText("#{mainWorkDirectoryPath}/ECMConfig.cmake.in","include(\"${ECM_MODULE_DIR}/ECMUseFindModules.cmake\")","include(\"${ECM_MODULE_DIR}/ECMUseFindModules.cmake\")\nset(PACKAGE_PREFIX_DIR \"${SAVE_PACKAGE_PREFIX_DIR}\")")
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            ".."],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
