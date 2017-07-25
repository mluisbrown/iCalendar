FROM kylef/swiftenv

RUN swiftenv install 4.0-DEVELOPMENT-SNAPSHOT-2017-07-23-a
RUN swift --version
