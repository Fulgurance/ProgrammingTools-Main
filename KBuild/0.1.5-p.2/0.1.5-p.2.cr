class Target < ISM::Software
    
    def prepareInstallation
        super

        moveFile("#{mainWorkDirectoryPath(false)}/bin","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/bin")
    end

end
