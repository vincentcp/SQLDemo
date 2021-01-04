pipeline {
  agent none
  stages {
    stage('Build SSDT project to dacpac') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe" SQLDemo\\SQLDemo.sqlproj'
        stash(name: 'SQLDemoDacpac', includes: 'SQLDemo/bin/Debug/SQLDemo.dacpac')
        archiveArtifacts(artifacts: 'SQLDemo/bin/Debug/SQLDemo.dacpac', onlyIfSuccessful: true)
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: true)
      }
    }

    stage('Deploy to DEV') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"SQLDemo\\bin\\Debug\\SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_DEV -TargetServerName:localhost'
      }
    }

    stage('Run tests') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe" SQLDemo_Test\\SQLDemo_Test.sqlproj'
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"SQLDemo_Test\\bin\\Debug\\SQLDemo_Test.dacpac" -TargetDatabaseName:SQLDemo_DEV -TargetServerName:localhost'
        powershell 'sqlcmd -S localhost -d SQLDemo_DEV -i .\\SQLDemo_Test\\RuntSQLtTests.sql '
        powershell 'sqlcmd -S localhost -d SQLDemo_DEV -y 0 -i .\\SQLDemo_Test\\ExportJUnitXML.sql -o DEV_tSQLt.xml'
        junit 'DEV_tSQLt.xml'
      }
    }

    stage('Trigger Deploy to INT') {
      steps {
        timeout(time: 3, unit: 'MINUTES') {
          input(message: 'Should we move to integration?', submitter: 'vincent')
        }

      }
    }

    stage('Deploy to INT') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        powershell ' & "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"SQLDemo\\bin\\Debug\\SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_INT -TargetServerName:localhost'
      }
    }

    stage('Trigger Deploy to PRD') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          input(message: 'Should we move to production?', submitter: 'vincent')
        }

      }
    }

    stage('Deploy to PRD') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        powershell ' & "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"SQLDemo\\bin\\Debug\\SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_PRD -TargetServerName:localhost'
      }
    }

  }
}