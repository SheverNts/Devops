nexus () {
    docker rm nexus
    echo "Starting nexus.."
    docker run -d -p 8081:8081 --name nexus sonatype/nexus3
    output $? "http://localhost:8081" "nexus"

}

stash (){
    docker rm stash
    echo "Starting stash.."
    docker run -u root -v ${HOME}/data/stash:/var/atlassian/application-data/stash atlassian/stash chown -R daemon  /var/atlassian/application-data/stash
    docker run -v ${HOME}/data/stash:/var/atlassian/application-data/stash --name="stash" -d -p 7990:7990 -p 7999:7999 atlassian/stash
    output $? "http://localhost:7990" "stash"
}

artifatory () {
    docker rm artifactory
    echo "Starting artifactory.."
    docker run --name artifactory -d -p 8082:8082 -e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx2g -Xss256k -XX:+UseG1GC' docker.bintray.io/jfrog/artifactory-oss:latest
    output $? "http://localhost:8082" "artifactory"
}

jenkins () {
    docker rm jenkins
    echo "Starting jenkins.."
    docker run --name jenkins -p 8080:8080 -p 50000:50000  jenkins
    output $? "http://localhost:8080" "artifactory"

}
output () {
    local status=$1
    local url=$2
    local service_name=$3

    if [[ $? != $status ]]
    then
    echo "Unable to start the $service_name.."
    exit $status
    else
    echo "Access the $service_name >> $url"
    fi
}

all () {
    nexus
    stash
    artifatory
    jenkins
}


$@
