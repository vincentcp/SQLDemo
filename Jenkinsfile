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
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: true)
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
        archiveArtifacts 'DEV_tSQLt.xml'
        script {
          hasNoFailures = powershell(
                      script: '(([xml](Get-Content -Path DEV_tSQLt.xml)).SelectNodes(\'//failure\')).Count -eq 0', 
                      returnStdout: true) 
          println hasNoFailures 
          println hasNoFailures.getClass()
          if (hasNoFailures!='True') {
            error('There was a failure while testing')
          }
        }
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: false)
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
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: true)
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
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: true)
      }
    }

  }
}
