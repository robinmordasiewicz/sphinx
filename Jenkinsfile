pipeline {
  options {
    disableConcurrentBuilds()
    skipDefaultCheckout(true)
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: ubuntu
            image: robinhoodis/ubuntu:latest
            imagePullPolicy: Always
            command:
            - cat
            tty: true
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            imagePullPolicy: IfNotPresent
            command:
            - /busybox/cat
            tty: true
            volumeMounts:
              - name: kaniko-secret
                mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
            - name: kaniko-secret
              secret:
                secretName: regcred
                items:
                  - key: .dockerconfigjson
                    path: config.json
        '''
    }
  }
  stages {
    stage('INIT') {
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage('Increment VERSION') {
      when {
        beforeAgent true
        allOf {
          anyOf {
            changeset "Dockerfile"
            changeset "requirements.txt"
          }
          // triggeredBy cause: 'UserIdCause'
          not {changeset "VERSION"} 
        }
      }
      steps {
        container('ubuntu') {
          sh 'sh increment-version.sh'
        }
      }
    }
    stage('Build/Push Container') {
      when {
        beforeAgent true
        expression {
          container('ubuntu') {
            sh(returnStatus: true, script: 'skopeo inspect docker://docker.io/robinhoodis/sphinx:`cat VERSION`') == 1
          }
        }
      }
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          script {
            sh ''' 
            /kaniko/executor --dockerfile=Dockerfile \
                             --context=`pwd` \
                             --destination=robinhoodis/sphinx:`cat VERSION` \
                             --destination=robinhoodis/sphinx:latest \
                             --cache=true
            '''
          }
        }
      }
    }
    stage('Commit new VERSION') {
      when {
        beforeAgent true
        allOf {
          anyOf {
            changeset "Dockerfile"
            changeset "requirements.txt"
          }
          // triggeredBy cause: 'UserIdCause'
          not {changeset "VERSION"}
        }
      }
//      when {
//        beforeAgent true
//        anyOf {
//          // not {changeset "VERSION"} 
//          // not {changeset "Jenkinsfile"} 
//          expression {
//            sh(returnStatus: true, script: 'git status --porcelain | grep --quiet "VERSION"') == 1
//          }
//          expression {
//            sh(returnStatus: true, script: '[ -f BUILDNEWCONTAINER.txt ]') == 0
//          }
//        }
//      }
      steps {
        sh 'git config user.email "robin@mordasiewicz.com"'
        sh 'git config user.name "Robin Mordasiewicz"'
        sh 'git add VERSION && git diff --staged --quiet || git commit -m "`cat VERSION`"'
        withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
          // sh 'git diff --quiet && git diff --staged --quiet || git push origin HEAD:main'
          // sh 'git diff --quiet HEAD || git push origin HEAD:main'
          sh 'git push origin HEAD:main'
        }
      }
    }
    stage('clone nginx repo') {
      steps {
        dir ( 'nginx' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/nginx.git'
        }
      }
    }
    stage('Update nginx Jenkinsfile') {
      steps {
        dir ( 'nginx' ) {
          container('ubuntu') {
            sh 'sh increment-version.sh'
          }
        }
      }
    }
    stage('Commit Jenkinsfile to nginx') {
//      when {
//        beforeAgent true
//        anyOf {
//          allOf {
//            not {changeset "VERSION"}
//            changeset "Dockerfile"
//          }
//          triggeredBy cause: 'UserIdCause'
//        }
//      }
      steps {
        dir ( 'nginx' ) {
          sh 'git config user.email "robin@mordasiewicz.com"'
          sh 'git config user.name "Robin Mordasiewicz"'
          // sh 'git add .'
          // sh 'git diff --quiet && git diff --staged --quiet || git commit -m "`cat ../VERSION`"'
          sh 'git add . && git diff --staged --quiet || git commit -m "`cat ../VERSION`"'
          withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
            // sh 'git diff --quiet && git diff --staged --quiet || git push origin HEAD:main'
            // sh 'git diff --quiet HEAD || git push origin HEAD:main'
            sh 'git push origin HEAD:main'
          }
        }
      }
    }
    stage('clean up') {
      steps {
        sh 'rm -rf nginx'
      }
    }
  }
  post {
    always {
      cleanWs(cleanWhenNotBuilt: false,
            deleteDirs: true,
            disableDeferredWipeout: true,
            notFailBuild: true,
            patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                       [pattern: '.propsfile', type: 'EXCLUDE']])
    }
  }
}
