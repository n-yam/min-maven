##### MINIMIZE JDK #####
FROM eclipse-temurin:21-jdk-alpine AS min-jdk

WORKDIR /tmp
RUN jlink --module-path jmods --add-modules jdk.compiler,java.naming,java.logging --output /opt/jdk21


##### INSTALL MAVEN #####
FROM alpine:3.20.3

# Download maven
WORKDIR /opt/maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz -O maven.tar.gz \
    && tar xzf maven.tar.gz --strip-components 1 \
    && rm maven.tar.gz

COPY --from=min-jdk /opt/jdk21 /opt/jdk21
COPY --from=min-jdk /opt/java/openjdk/bin/javac /opt/jdk21/bin

ENV JAVA_HOME=/opt/jdk21
ENV PATH=$PATH:/opt/maven/bin

CMD ["mvn", "--version"]
